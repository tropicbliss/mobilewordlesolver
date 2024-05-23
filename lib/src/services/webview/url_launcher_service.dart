import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  static Future<bool> launchInWebView(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView)) {
      return true;
    }
    return false;
  }
}
