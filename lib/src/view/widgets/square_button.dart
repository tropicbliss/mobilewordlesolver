import 'package:flutter/material.dart';
import 'package:wordle_solver/src/constants/styling.dart';

class SquareButton extends StatelessWidget {
  final bool disableAllInputs;
  final Widget icon;
  final bool visible;

  const SquareButton({
    super.key,
    required this.disableAllInputs,
    this.visible = true,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(AppDimensions.commonMedium)),
        child: icon,
      ),
    );
  }
}
