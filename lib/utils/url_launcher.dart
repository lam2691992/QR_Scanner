import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  // Kiểm tra xem có ứng dụng nào có thể mở URL không
  if (await canLaunchUrl(uri)) {
    // Mở URL bằng ứng dụng bên ngoài (trình duyệt)
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    print("Không thể mở URL: $url");
  }
}
