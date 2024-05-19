import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:wordle_solver/src/constants/animation.dart';
import 'package:wordle_solver/src/constants/styling.dart';

const double keyboardHeight = 150;

class Keyboard extends StatelessWidget {
  final bool visible;
  final void Function(dynamic) onKeyPress;

  const Keyboard({super.key, required this.visible, required this.onKeyPress});

  @override
  Widget build(BuildContext context) {
    return FadeAndTranslate(
      visible: visible,
      translate: const Offset(0, keyboardHeight),
      duration: const Duration(milliseconds: AnimationSpeed.animationFastMs),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.commonMedium)),
            color: Colors.deepPurple),
        child: VirtualKeyboard(
          height: keyboardHeight,
          type: VirtualKeyboardType.Alphanumeric,
          alwaysCaps: true,
          onKeyPress: onKeyPress,
          textColor: Colors.white,
          customLayoutKeys: CustomLayoutKeys(),
        ),
      ),
    );
  }
}

class CustomLayoutKeys extends VirtualKeyboardLayoutKeys {
  @override
  int getLanguagesCount() => 1;

  @override
  List<List> getLanguage(int index) {
    return _defaultEnglishLayout;
  }
}

const List<List> _defaultEnglishLayout = [
  [
    'q',
    'w',
    'e',
    'r',
    't',
    'y',
    'u',
    'i',
    'o',
    'p',
  ],
  [
    'a',
    's',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
  ],
  [
    VirtualKeyboardKeyAction.Backspace,
    'z',
    'x',
    'c',
    'v',
    'b',
    'n',
    'm',
  ]
];
