default:
	flutter build apk --release
icons:
	flutter pub run flutter_launcher_icons
clean:
	flutter clean
bundle:
	flutter build appbundle