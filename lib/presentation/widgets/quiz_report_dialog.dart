import 'package:flutter/material.dart';

/// Dialog for reporting an issue with a question.
class QuizReportDialog extends StatefulWidget {
  const QuizReportDialog({required this.onSubmit, super.key});

  /// Callback when the report is submitted.
  /// Returns a `Future<bool>` indicating success.
  final Future<bool> Function({
    required String issueType,
    required String description,
  })
  onSubmit;

  @override
  State<QuizReportDialog> createState() => _QuizReportDialogState();
}

class _QuizReportDialogState extends State<QuizReportDialog> {
  String? _selectedIssue;
  final _issueController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedIssue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار نوع المشكلة')),
      );
      return;
    }
    if (_issueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الرجاء كتابة وصف المشكلة')));
      return;
    }

    setState(() => _isSending = true);

    final success = await widget.onSubmit(
      issueType: _selectedIssue!,
      description: _issueController.text.trim(),
    );

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? '✅ تم إرسال البلاغ بنجاح! شكراً لمساعدتك 🙏'
              : '❌ حدث خطأ. يرجى المحاولة لاحقاً',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('التبليغ عن السؤال'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('اختر نوع المشكلة:'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedIssue,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              hint: const Text('اختر المشكلة'),
              items: const [
                DropdownMenuItem(value: 'خطأ لغوي', child: Text('خطأ لغوي')),
                DropdownMenuItem(
                  value: 'خطأ في المعلومات',
                  child: Text('خطأ في المعلومات'),
                ),
                DropdownMenuItem(
                  value: 'خطأ في الإجابة',
                  child: Text('خطأ في الإجابة'),
                ),
                DropdownMenuItem(
                  value: 'رابط لا يعمل',
                  child: Text('رابط لا يعمل'),
                ),
                DropdownMenuItem(value: 'أخرى', child: Text('أخرى')),
              ],
              onChanged: (value) => setState(() => _selectedIssue = value),
            ),
            const SizedBox(height: 16),
            const Text('وصف المشكلة:'),
            const SizedBox(height: 8),
            TextField(
              controller: _issueController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'اكتب تفاصيل المشكلة هنا...',
              ),
            ),
            if (_isSending) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Center(child: Text('جاري الإرسال...')),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSending ? null : () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isSending ? null : _submit,
          child: const Text('إرسال'),
        ),
      ],
    );
  }
}
