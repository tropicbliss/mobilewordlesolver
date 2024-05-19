import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordle_solver/src/constants/styling.dart';

class HardModeSlider extends StatelessWidget {
  final bool isHardMode;
  final void Function(bool) onChanged;

  const HardModeSlider(
      {super.key, required this.isHardMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(AppLocalizations.of(context)!.hardMode,
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(
          width: AppDimensions.commonMedium,
        ),
        Switch(value: isHardMode, onChanged: onChanged),
      ],
    );
  }
}
