import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

/// ويدجت الاحتفال بالكونفيتي
class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({
    required this.child,
    required this.controller,
    super.key,
  });

  final Widget child;
  final ConfettiController controller;

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Confetti من أعلى الشاشة
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: widget.controller,
            blastDirection: pi / 2, // للأسفل
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.3,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
              Colors.yellow,
            ],
          ),
        ),
        // Confetti من يسار الشاشة
        Align(
          alignment: Alignment.centerLeft,
          child: ConfettiWidget(
            confettiController: widget.controller,
            blastDirection: 0, // لليمين
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 10,
            gravity: 0.1,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
        // Confetti من يمين الشاشة
        Align(
          alignment: Alignment.centerRight,
          child: ConfettiWidget(
            confettiController: widget.controller,
            blastDirection: pi, // لليسار
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 10,
            gravity: 0.1,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
      ],
    );
  }
}
