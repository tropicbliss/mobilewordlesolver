import 'package:flutter/material.dart';
import 'package:wordle_solver/src/constants/animation.dart';
import 'package:wordle_solver/src/constants/styling.dart';

class LetterBoxParams {
  final BoxStatus state;
  final String? char;

  LetterBoxParams({required this.state, this.char});
}

class LetterBox extends StatelessWidget {
  final VoidCallback? onTap;
  final LetterBoxParams params;

  const LetterBox({
    super.key,
    required this.params,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.commonSmall,
          vertical: AppDimensions.commonSmall / 2),
      child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: params.state.toColour(),
                borderRadius: BorderRadius.circular(AppDimensions.commonSmall)),
            alignment: Alignment.center,
            child: params.char == null
                ? null
                : Text(
                    params.char!,
                    style: const TextStyle(fontSize: 35, color: Colors.white),
                  ),
          )),
    );
  }
}

class AnimatedLetterBox extends StatelessWidget {
  final VoidCallback onTap;
  final InitialLetterBoxState params;
  final Color borderColour;

  const AnimatedLetterBox({
    super.key,
    required this.params,
    required this.borderColour,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.commonSmall,
          vertical: AppDimensions.commonSmall / 2),
      child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration:
                const Duration(milliseconds: AnimationSpeed.animationFastMs),
            curve: Curves.easeInOut,
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: params.state?.toColour() ?? Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.commonSmall),
                border: Border.all(
                    color: borderColour, width: AppDimensions.commonSmall)),
            alignment: Alignment.center,
            child: Text(
              params.char ?? "",
              style: TextStyle(
                  fontSize: 35,
                  color: params.state == null ? null : Colors.white),
            ),
          )),
    );
  }
}

enum BoxStatus {
  notInWord,
  wrongSpot,
  correct;

  Color toColour() {
    switch (this) {
      case BoxStatus.correct:
        return AppColour.green;
      case BoxStatus.notInWord:
        return AppColour.grey;
      case BoxStatus.wrongSpot:
        return AppColour.yellow;
    }
  }
}

class InitialLetterBoxState {
  String? char;
  BoxStatus? state;

  InitialLetterBoxState({this.char});
}

class CompletedLetterBoxState {
  final String char;
  final BoxStatus state;

  CompletedLetterBoxState({required this.char, required this.state});
}

List<InitialLetterBoxState> generateEmptyLetterBoxes([String? word]) {
  return List.generate(5, (idx) => InitialLetterBoxState(char: word?[idx]),
      growable: false);
}
