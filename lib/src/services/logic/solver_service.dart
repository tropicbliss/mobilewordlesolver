import 'package:flutter/material.dart';
import 'package:wordle_solver/src/rust/api/compute.dart';
import 'package:wordle_solver/src/rust/helper.dart';
import 'package:wordle_solver/src/view/widgets/letter_box.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SolverService {
  static Future<SolverResult> solve(
      List<List<CompletedLetterBoxState>> words, bool hardMode) async {
    String actualWord = words.last.map((state) => state.char).join();
    bool isWord = await isAWord(actualWord);
    if (!isWord) {
      return NotAWord(word: actualWord);
    }
    List<RustLetterBoxArray5> conversion = words
        .map((word) => RustLetterBoxArray5(word
            .map((letterbox) => RustLetterBox(
                char: letterbox.char, state: fromBoxStatus(letterbox.state)))
            .toList()))
        .toList();
    String? foundWord = await compute(state: conversion, hardMode: hardMode);
    if (foundWord == null) {
      return NoWordsLeft();
    } else {
      return FoundWord(newWord: foundWord);
    }
  }

  static Future<bool> isAWord(String word) async {
    return await isWord(word: word);
  }

  static String getWordErrorReason(BuildContext context, SolverError error) {
    switch (error) {
      case NotAWord(word: String word):
        return AppLocalizations.of(context)!.notAWord(capitaliseFirst(word));
      case NoWordsLeft():
        return AppLocalizations.of(context)!.noWordsLeft;
    }
  }
}

String capitaliseFirst(String word) {
  if (word.isEmpty) return word;
  return word[0].toUpperCase() + word.substring(1).toLowerCase();
}

Correctness fromBoxStatus(BoxStatus boxStatus) {
  switch (boxStatus) {
    case BoxStatus.correct:
      return Correctness.correct;
    case BoxStatus.notInWord:
      return Correctness.wrong;
    case BoxStatus.wrongSpot:
      return Correctness.misplaced;
  }
}

sealed class SolverResult {}

class FoundWord implements SolverResult {
  final String newWord;

  FoundWord({required this.newWord});
}

sealed class SolverError implements SolverResult {}

class NoWordsLeft implements SolverError {}

class NotAWord implements SolverError {
  final String word;

  NotAWord({required this.word});
}
