import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  const UrlHelper._();
  static void openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}
