import json
import re
import os
import sys

# Define input and output filenames
INPUT_FILE = r'raw_data.txt'
OUTPUT_FILE = r'clean_quran_words.json'
ERROR_LOG_FILE = r'parsing_errors.log'

def remove_diacritics(text):
    # Arabic diacritics Unicode range
    return re.sub(r'[\u064B-\u065F\u0670]', '', text)

def clean_meaning(meaning_text, word):
    """
    Cleans the meaning text by removing specific prefixes and whitespace.
    """
    meaning_text = meaning_text.strip()
    
    # 1. Remove text-based prefixes
    prefixes = ["أيْ:", "أي:", "أي :"]
    for prefix in prefixes:
        if meaning_text.startswith(prefix):
            meaning_text = meaning_text[len(prefix):].strip()

    # 2. Remove redundant word definition (e.g. word is "Rubb", meaning starts with "Al-Rubb:")
    # We build a regex that matches the word (with optional 'Al') and ignores diacritics
    clean_w = remove_diacritics(word)
    # Escape special regex chars in the word just in case
    clean_w = re.escape(clean_w)
    
    # Pattern: optional "Wa" or "Fa" or "Al" (very basic), mostly just "Al" (ال)
    # The user example was "الرَّبُّ:" for word "رَبِّ".
    # Pattern: Start of line, optional whitespace, optional 'ال', optional whitespace, 
    # then the word characters interspersed with optional diacritics, then colon.
    
    # Insert diacritic matcher between every character of the word
    tashkeel = r'[\u064B-\u065F\u0670]*'
    word_regex = tashkeel.join(list(clean_w))
    
    # Full regex: ^\s*(?:ال)?\s*{word_regex}{tashkeel}\s*:
    redundant_pattern = re.compile(r'^\s*(?:ال)?\s*' + word_regex + tashkeel + r'\s*:', re.UNICODE)
    
    match = redundant_pattern.match(meaning_text)
    if match:
        meaning_text = meaning_text[match.end():].strip()
            
    return meaning_text

def parse_vocabulary():
    print(f"Starting parsing of {INPUT_FILE}...")
    
    if not os.path.exists(INPUT_FILE):
        print(f"Error: The file '{INPUT_FILE}' was not found.")
        return

    data_entries = []
    current_surah_id = None
    
    # Regex Patterns
    # Surah Header: "سورة الفاتحة (1)"
    surah_pattern = re.compile(r"سورة\s+(.+?)\s+\((\d+)\)")
    
    # Type 1: «WORD»: MEANING
    type1_pattern = re.compile(r"«(.+?)»:\s*(.*)")
    
    # Type 2: 1- ﴿WORD﴾: MEANING  OR  ﴿WORD﴾: MEANING
    # The number and dash part `(?:\d+-\s*)?` is optional non-capturing group
    type2_pattern = re.compile(r"(?:\d+-\s*)?﴿(.+?)﴾:\s*(.*)")

    malformed_lines = []

    try:
        with open(INPUT_FILE, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            
        for line_num, line in enumerate(lines, 1):
            original_line = line
            line = line.strip()
            
            if not line:
                continue

            try:
                # Check for Surah Header
                surah_match = surah_pattern.match(line)
                if surah_match:
                    current_surah_name = surah_match.group(1)
                    current_surah_id = int(surah_match.group(2))
                    # print(f"Found Surah: {current_surah_name} ({current_surah_id})")
                    continue

                # Check for Word Definitions
                match = None
                word = None
                raw_meaning = None
                
                # Try Type 1
                type1_match = type1_pattern.match(line)
                if type1_match:
                    word = type1_match.group(1)
                    raw_meaning = type1_match.group(2)
                else:
                    # Try Type 2
                    type2_match = type2_pattern.match(line)
                    if type2_match:
                        word = type2_match.group(1)
                        raw_meaning = type2_match.group(2)
                
                if word and raw_meaning:
                    if current_surah_id is None:
                        # Warning if word found before any Surah header
                        print(f"Warning: Word found before Surah header at line {line_num}: {line}")
                        malformed_lines.append(f"Line {line_num} (No Surah ID): {original_line.strip()}")
                        continue
                        
                    clean_def = clean_meaning(raw_meaning, word)
                    
                    entry = {
                        "surah_id": current_surah_id,
                        "word": word,
                        "correct_meaning": clean_def
                    }
                    data_entries.append(entry)
                else:
                    # Line didn't match Surah or Word patterns
                    # Check if it looks like it SHOULD have matched (e.g. contains brackets but regex failed)
                    if '«' in line or '»' in line or '﴿' in line or '﴾' in line:
                         print(f"Skipping malformed line: {line}")
                         malformed_lines.append(f"Line {line_num} (Malformed): {original_line.strip()}")
                    else:
                        # Just a random line (like page numbers "134: 1" seen in the file)
                        # We can ignore these silently or verify if they are important
                         pass

            except Exception as e:
                print(f"Error parsing line {line_num}: {line}. Error: {e}")
                malformed_lines.append(f"Line {line_num} (Exception): {original_line.strip()} | Error: {e}")

        # Save to JSON
        with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
            json.dump(data_entries, f, ensure_ascii=False, indent=2)
            
        print(f"Successfully processed {len(data_entries)} entries.")
        print(f"Output saved to {OUTPUT_FILE}")
        
        # Save errors if any
        if malformed_lines:
            with open(ERROR_LOG_FILE, 'w', encoding='utf-8') as f:
                f.write("\n".join(malformed_lines))
            print(f"WARNING: Found {len(malformed_lines)} malformed/skipped lines. Details saved to {ERROR_LOG_FILE}")
        else:
            print("No malformed lines found.")

    except Exception as e:
        print(f"Critical Error: {e}")

if __name__ == "__main__":
    parse_vocabulary()
