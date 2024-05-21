import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:wordle_solver/src/constants/styling.dart';
import 'package:wordle_solver/src/services/logic/solver_service.dart';
import 'package:wordle_solver/src/services/settings/settings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordle_solver/src/services/toast/toast_service.dart';
import 'package:confetti/confetti.dart';
import 'package:wordle_solver/src/services/webview/url_launcher_service.dart';
import 'package:wordle_solver/src/view/theme_mode_helper.dart';
import 'package:wordle_solver/src/view/widgets/letter_box.dart';
import 'package:wordle_solver/src/view/widgets/square_button.dart';
import 'package:wordle_solver/src/view/widgets/action.dart';
import 'package:wordle_solver/src/view/widgets/confetti.dart';
import 'package:wordle_solver/src/view/widgets/confirmation_dialog.dart';
import 'package:wordle_solver/src/view/widgets/hard_mode_slider.dart';
import 'package:wordle_solver/src/view/widgets/keyboard.dart';

class RootView extends StatefulWidget {
  const RootView({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  int selectedIdx = 0;
  final List<List<CompletedLetterBoxState>> immutableWords =
      List.empty(growable: true);
  List<InitialLetterBoxState> currentWord = generateEmptyLetterBoxes();
  bool disableAllInputs = false;
  bool isSolved = false;
  final ConfettiController confettiController =
      ConfettiController(duration: const Duration(seconds: 1));
  final shakeKey = GlobalKey<ShakeWidgetState>();

  AppTheme getTheme(BuildContext context, [ThemeMode? themeMode]) {
    switch (themeMode ?? widget.settingsController.themeMode) {
      case ThemeMode.system:
        return getTheme(context, ThemeModeHelper.getSystemThemeMode(context));
      case ThemeMode.dark:
        return AppTheme.dark;
      case ThemeMode.light:
        return AppTheme.light;
    }
  }

  void checkWordError(SolverError reason) {
    setState(() {
      selectedIdx = 0;
    });
    String message = SolverService.getWordErrorReason(context, reason);
    ToastService.showToast(message, ToastState.warning);
    shakeKey.currentState?.shake();
  }

  Future<void> launchInWebView(String url) async {
    bool isSuccess = await UrlLauncherService.launchInWebView(url);
    if (!isSuccess && mounted) {
      ToastService.showToast(
          AppLocalizations.of(context)!.cannotLaunchUrl(url), ToastState.error);
    }
  }

  Future<void> onSubmit(bool hardMode) async {
    bool isInvalid = currentWord
        .any((letterBox) => letterBox.char == null || letterBox.state == null);
    if (isInvalid) {
      shakeKey.currentState?.shake();
      return;
    }
    List<CompletedLetterBoxState> completedCurrentWord = currentWord
        .map((letterBox) => CompletedLetterBoxState(
            char: letterBox.char!, state: letterBox.state!))
        .toList();
    bool isAllGreen = completedCurrentWord
        .every((letterBox) => letterBox.state == BoxStatus.correct);
    setState(() {
      disableAllInputs = true;
    });
    String word =
        completedCurrentWord.map((letterBox) => letterBox.char).join();
    if (isAllGreen) {
      bool isAWord = await SolverService.isAWord(word);
      if (isAWord) {
        setState(() {
          isSolved = true;
        });
        confettiController.play();
      } else {
        checkWordError(NotAWord(word: word));
      }
    } else {
      List<List<CompletedLetterBoxState>> history = [
        ...immutableWords,
        completedCurrentWord
      ];
      SolverResult result = await SolverService.solve(history, hardMode);
      if (result is NotAWord) {
        checkWordError(result);
      } else if (result is NoWordsLeft) {
        checkWordError(result);
      } else if (result is FoundWord) {
        setState(() {
          immutableWords.add(completedCurrentWord);
          selectedIdx = 0;
          currentWord = generateEmptyLetterBoxes(result.newWord);
        });
      }
    }
    setState(() {
      disableAllInputs = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppTheme currentTheme = getTheme(context);
    bool isHardMode = widget.settingsController.hardMode;
    bool showBackButton = immutableWords.isNotEmpty && !isSolved;

    return Builder(builder: (context) {
      return Stack(
        children: [
          Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.appTitle),
                actions: [
                  AppBarAction(
                      visible: immutableWords.isNotEmpty || isSolved,
                      icon: Icons.delete,
                      onPressed: () {
                        void clear() {
                          setState(() {
                            immutableWords.clear();
                            currentWord = generateEmptyLetterBoxes();
                            isSolved = false;
                            selectedIdx = 0;
                          });
                        }

                        if (isSolved) {
                          clear();
                          return;
                        }
                        showConfirmationDialog(context, () {
                          clear();
                        });
                      },
                      disable: disableAllInputs),
                  AppBarAction(
                    icon: Icons.info,
                    onPressed: () {
                      launchInWebView(
                          "https://github.com/tropicbliss/mobilewordlesolver");
                    },
                  ),
                  AppBarAction(
                    icon: currentTheme.getThemeIcon(),
                    onPressed: () {
                      switch (currentTheme) {
                        case AppTheme.light:
                          widget.settingsController
                              .updateThemeMode(ThemeMode.dark);
                          break;
                        case AppTheme.dark:
                          widget.settingsController
                              .updateThemeMode(ThemeMode.light);
                      }
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: isSolved
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: currentWord.map((letterBox) {
                          return LetterBox(
                              params: LetterBoxParams(
                                  state: BoxStatus.correct,
                                  char: letterBox.char!));
                        }).toList(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                        children: [
                          HardModeSlider(
                              isHardMode: isHardMode,
                              onChanged: (newValue) {
                                widget.settingsController
                                    .updateHardMode(newValue);
                              }),
                          const SizedBox(
                            height: AppDimensions.commonBig,
                          ),
                          Column(
                            children: immutableWords.map((word) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List<int>.generate(5, (idx) => idx)
                                    .map((idx) {
                                  CompletedLetterBoxState letterBox = word[idx];
                                  return LetterBox(
                                      params: LetterBoxParams(
                                          state: letterBox.state,
                                          char: letterBox.char));
                                }).toList(),
                              );
                            }).toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                List<int>.generate(5, (idx) => idx).map((idx) {
                              InitialLetterBoxState letterBox =
                                  currentWord[idx];
                              return AnimatedLetterBox(
                                params: letterBox,
                                borderColour: selectedIdx == idx
                                    ? Colors.deepPurple
                                    : Colors.grey,
                                onTap: () {
                                  setState(() {
                                    selectedIdx = idx;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: AppDimensions.commonMedium,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BoxStatus.notInWord,
                              BoxStatus.wrongSpot,
                              BoxStatus.correct
                            ].map((boxState) {
                              return LetterBox(
                                  params: LetterBoxParams(state: boxState),
                                  onTap: () {
                                    setState(() {
                                      currentWord[selectedIdx].state = boxState;
                                      if (selectedIdx != 4) {
                                        selectedIdx++;
                                      }
                                    });
                                  });
                            }).toList(),
                          ),
                          const SizedBox(
                            height: AppDimensions.commonBig,
                          ),
                          Row(
                            mainAxisAlignment: showBackButton
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.end,
                            children: [
                              SquareButton(
                                disableAllInputs: disableAllInputs,
                                visible: showBackButton,
                                icon: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                  ),
                                  color: Colors.white,
                                  onPressed: disableAllInputs
                                      ? null
                                      : () {
                                          setState(() {
                                            List<CompletedLetterBoxState>
                                                lastWord =
                                                immutableWords.removeLast();
                                            currentWord =
                                                lastWord.map((letterBox) {
                                              InitialLetterBoxState result =
                                                  InitialLetterBoxState();
                                              result.char = letterBox.char;
                                              result.state = letterBox.state;
                                              return result;
                                            }).toList();
                                            selectedIdx = 0;
                                          });
                                        },
                                ),
                              ),
                              Row(
                                children: [
                                  SquareButton(
                                    disableAllInputs: disableAllInputs,
                                    icon: IconButton(
                                      icon: const Icon(Icons.check),
                                      color: Colors.white,
                                      onPressed: disableAllInputs
                                          ? null
                                          : () {
                                              setState(() {
                                                for (InitialLetterBoxState letterBox
                                                    in currentWord) {
                                                  letterBox.state =
                                                      BoxStatus.correct;
                                                }
                                                selectedIdx = 4;
                                              });
                                            },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: AppDimensions.commonMedium,
                                  ),
                                  ShakeMe(
                                    key: shakeKey,
                                    shakeOffset: AppDimensions.commonSmall,
                                    shakeDuration:
                                        const Duration(milliseconds: 500),
                                    child: SquareButton(
                                      disableAllInputs: disableAllInputs,
                                      icon: AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          transitionBuilder: (Widget child,
                                              Animation<double> animation) {
                                            return RotationTransition(
                                                turns: animation, child: child);
                                          },
                                          child: disableAllInputs
                                              ? const CircularProgressIndicator(
                                                  strokeWidth:
                                                      AppDimensions.commonSmall,
                                                  key: ValueKey("loading"),
                                                  color: Colors.white,
                                                )
                                              : IconButton(
                                                  icon: const Icon(
                                                      Icons.arrow_forward),
                                                  color: Colors.white,
                                                  key: const ValueKey("next"),
                                                  onPressed: () {
                                                    onSubmit(isHardMode);
                                                  })),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: AppDimensions.commonBig,
                          ),
                        ],
                      )),
              ),
              bottomNavigationBar: Keyboard(
                text: currentWord
                    .takeWhile((letterbox) => letterbox.char != null)
                    .map((letterbox) => letterbox.char)
                    .join(),
                visible: !(immutableWords.isNotEmpty || isSolved),
                onKeyPress: (key) {
                  setState(() {
                    switch (key.keyType) {
                      case VirtualKeyboardKeyType.String:
                        var itemMap = currentWord.asMap();
                        for (var entry in itemMap.entries) {
                          if (entry.value.char == null ||
                              entry.key == currentWord.length - 1) {
                            entry.value.char = key.capsText;
                            break;
                          }
                        }
                        break;
                      case VirtualKeyboardKeyType.Action:
                        if (key.action == VirtualKeyboardKeyAction.Backspace) {
                          int idx = currentWord.lastIndexWhere(
                              (letterBox) => letterBox.char != null);
                          if (idx != -1) {
                            currentWord[idx].char = null;
                          }
                        }
                    }
                  });
                },
              )),
          Confetti(confettiController: confettiController)
        ],
      );
    });
  }
}
