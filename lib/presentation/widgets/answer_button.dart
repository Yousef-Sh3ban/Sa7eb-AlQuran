import 'package:flutter/material.dart';

/// Answer button widget for quiz
class AnswerButton extends StatelessWidget {
  const AnswerButton({
    required this.text,
    required this.index,
    required this.onPressed,
    this.isSelected = false,
    this.isCorrect = false,
    this.isAnswered = false,
    super.key,
  });

  final String text;
  final int index;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? borderColor;
    Color? textColor;

    if (isAnswered) {
      if (isCorrect) {
        backgroundColor = Colors.green;
        borderColor = Colors.green;
        textColor = Colors.white;
      } else if (isSelected) {
        backgroundColor = Colors.red;
        borderColor = Colors.red;
        textColor = Colors.white;
      }
    } else if (isSelected) {
      borderColor = Theme.of(context).colorScheme.primary;
    }

    return OutlinedButton(
      onPressed: isAnswered ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: BorderSide(
          color: borderColor ?? Colors.grey.shade300,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? Colors.grey.shade200,
              border: Border.all(
                color: borderColor ?? Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                String.fromCharCode(65 + index),
                style: TextStyle(
                  color: textColor ??
                      (isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade700),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
          ),
          if (isAnswered && isCorrect)
            const Icon(Icons.check_circle, color: Colors.white),
          if (isAnswered && isSelected && !isCorrect)
            const Icon(Icons.cancel, color: Colors.white),
        ],
      ),
    );
  }
}
