import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/surah_model.dart';

/// Repository for managing Surah data
class SurahRepository {
  SurahRepository._();
  
  static final SurahRepository instance = SurahRepository._();
  
  List<SurahModel>? _cachedSurahs;

  /// Load all surahs from JSON
  Future<List<SurahModel>> getAllSurahs() async {
    if (_cachedSurahs != null) {
      return _cachedSurahs!;
    }

    try {
      print('📖 Loading surahs from all_surahs.json...');
      final String jsonString =
          await rootBundle.loadString('assets/data/all_surahs.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<dynamic> surahsJson = data['surahs'] as List<dynamic>;

      _cachedSurahs = surahsJson
          .map((json) => SurahModel.fromJson(json as Map<String, dynamic>))
          .toList();

      print('✅ Loaded ${_cachedSurahs!.length} surahs successfully');
      return _cachedSurahs!;
    } catch (e, stackTrace) {
      print('❌ Error loading surahs: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get a single surah by ID
  Future<SurahModel?> getSurahById(int surahId) async {
    try {
      final List<SurahModel> surahs = await getAllSurahs();
      print('🔍 Looking for surah with ID: $surahId in ${surahs.length} surahs');
      final surah = surahs.firstWhere((s) => s.id == surahId);
      print('✅ Found surah: ${surah.nameArabic}');
      return surah;
    } catch (e, stackTrace) {
      print('❌ Error getting surah $surahId: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }
}
