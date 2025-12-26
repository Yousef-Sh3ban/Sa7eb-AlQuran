import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/config/app_config.dart';
import '../models/question_model.dart';

/// Repository for handling issue reports (e.g., to Telegram).
class ReportRepository {
  /// Sends a report about a question to the configured Telegram channel.
  ///
  /// Returns `true` if the report was sent successfully, `false` otherwise.
  Future<bool> sendQuestionReport({
    required String issueType,
    required String description,
    required QuestionModel? question,
  }) async {
    if (!AppConfig.isTelegramConfigured) {
      debugPrint('Telegram reporting is not configured.');
      return false;
    }

    try {
      const botToken = AppConfig.telegramBotToken;
      const chatId = AppConfig.telegramChatId;

      // Build options list
      String optionsText = '';
      if (question != null && question.options.isNotEmpty) {
        for (int i = 0; i < question.options.length; i++) {
          final isCorrect = i == question.correctAnswerIndex;
          final prefix = isCorrect ? '✅' : '❌';
          optionsText += '$prefix ${i + 1}. ${question.options[i]}\n';
        }
      }

      final message = '''
🚨 *بلاغ جديد من تطبيق صاحب القرآن*

📋 *نوع المشكلة:* $issueType

📝 *الوصف:*
$description

━━━━━━━━━━━━━━━━
📌 *معلومات السؤال:*
• المعرف: ${question?.id ?? 'غير متوفر'}
• السورة: ${question?.surahId ?? 'غير متوفر'}
• الفئة: ${question?.category.displayName ?? 'غير متوفر'}

❓ *نص السؤال:*
${question?.questionText ?? 'غير متوفر'}

📝 *الإجابات:*
${optionsText.isNotEmpty ? optionsText : 'غير متوفرة'}
✅ *الإجابة الصحيحة:* ${question?.correctAnswer ?? 'غير متوفر'}

📖المصدر:${question?.explanation.isNotEmpty == true ? ' ${question!.explanation}' : ' غير متوفر'}

⏰ التاريخ: ${DateTime.now().toString().split('.')[0]}
''';

      final url = Uri.parse(
          'https://api.telegram.org/bot$botToken/sendMessage');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'chat_id': chatId,
          'text': message,
          'parse_mode': 'Markdown',
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error sending Telegram report: $e');
      return false;
    }
  }
}
