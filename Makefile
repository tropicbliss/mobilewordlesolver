default:
	flutter build apk --obfuscate --split-debug-info --release
icons:
	flutter pub run flutter_launcher_icons
clean:
	flutter clean
bundle:
	flutter build appbundle