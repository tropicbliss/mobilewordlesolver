import 'package:flutter/material.dart';

class ThemeModeHelper {
  static ThemeMode getSystemThemeMode(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }
}

enum AppTheme {
  light,
  dark;

  IconData getThemeIcon() {
    switch (this) {
      case AppTheme.light:
        return Icons.dark_mode;
      case AppTheme.dark:
        return Icons.light_mode;
    }
  }
}
