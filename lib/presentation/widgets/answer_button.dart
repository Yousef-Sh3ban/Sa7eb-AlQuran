import 'package:flutter/material.dart';

/// Answer button widget for quiz
class AnswerButton extends StatefulWidget {
  const AnswerButton({
    required this.text,
    required this.index,
    required this.onPressed,
    this.isSelected = false,
    this.isCorrect = false,
    this.isAnswered = false,
    this.fontSize = 1.0,
    super.key,
  });

  final String text;
  final int index;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final double fontSize;

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.isAnswered) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isAnswered) return;
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (widget.isAnswered) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? borderColor;
    Color? textColor;

    if (widget.isAnswered) {
      if (widget.isCorrect) {
        backgroundColor = Colors.green;
        borderColor = Colors.green;
        textColor = Colors.white;
      } else if (widget.isSelected) {
        backgroundColor = Colors.red;
        borderColor = Colors.red;
        textColor = Colors.white;
      }
    } else if (widget.isSelected) {
      borderColor = Theme.of(context).colorScheme.primary;
    }

    final scale = _isPressed ? 0.96 : 1.0;

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: OutlinedButton(
          onPressed: widget.isAnswered ? null : widget.onPressed,
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
                    String.fromCharCode(65 + widget.index),
                    style: TextStyle(
                      color: textColor ??
                          (widget.isSelected
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
                  widget.text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16 * widget.fontSize,
                  ),
                ),
              ),
              if (widget.isAnswered && widget.isCorrect)
                const Icon(Icons.check_circle, color: Colors.white),
              if (widget.isAnswered && widget.isSelected && !widget.isCorrect)
                const Icon(Icons.cancel, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
