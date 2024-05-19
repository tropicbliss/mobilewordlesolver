import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _themeModeKey = 'themeMode';
  static const _hardModeKey = "hardMode";

  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey);
    return ThemeMode.values[themeModeIndex ?? ThemeMode.system.index];
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, theme.index);
  }

  Future<bool> isHardMode() async {
    final prefs = await SharedPreferences.getInstance();
    final hardModeIndex = prefs.getBool(_hardModeKey);
    return hardModeIndex ?? false;
  }

  Future<void> updateHardMode(bool isHardMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hardModeKey, isHardMode);
  }
}
