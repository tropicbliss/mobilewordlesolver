import 'package:flutter/material.dart';

import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;
  late ThemeMode _themeMode;
  late bool _hardMode;
  ThemeMode get themeMode => _themeMode;
  bool get hardMode => _hardMode;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _hardMode = await _settingsService.isHardMode();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateHardMode(bool isHardMode) async {
    if (isHardMode == _hardMode) return;
    _hardMode = isHardMode;
    notifyListeners();
    await _settingsService.updateHardMode(isHardMode);
  }
}
