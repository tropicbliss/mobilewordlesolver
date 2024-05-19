import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/services/settings/settings_controller.dart';
import 'src/services/settings/settings_service.dart';
import 'package:wordle_solver/src/rust/frb_generated.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = SettingsController(SettingsService());
  await Future.wait([settingsController.loadSettings(), RustLib.init()]);
  runApp(MyApp(settingsController: settingsController));
}
