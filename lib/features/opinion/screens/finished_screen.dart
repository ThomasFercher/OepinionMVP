import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:web_mvp/common/extensions.dart';

class FinishedScreen extends StatelessWidget {
  const FinishedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: ConfettiController()..play(),
            numberOfParticles: 5,
            emissionFrequency: 0.05,
            blastDirectionality: BlastDirectionality.explosive,
            blastDirection: .5 * pi,
            shouldLoop: true,
          ),
        ),
        Align(
          alignment: const Alignment(0, -0.5),
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              "Danke für deine Teilnahme!",
              style: context.typography.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
