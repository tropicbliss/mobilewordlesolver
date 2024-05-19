import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class Confetti extends StatelessWidget {
  final ConfettiController confettiController;

  const Confetti({super.key, required this.confettiController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: confettiController,
        blastDirection: -pi / 2,
        maxBlastForce: 5,
        minBlastForce: 2,
        emissionFrequency: 0.05,
        numberOfParticles: 20,
        gravity: 0.1,
      ),
    );
  }
}
