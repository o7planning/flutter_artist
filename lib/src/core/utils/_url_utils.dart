import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static Future<void> open({required String url}) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  static Future<void> tryOpen({required String url}) async {
    try {
      open(url: url);
    } catch (e) {}
  }
}
