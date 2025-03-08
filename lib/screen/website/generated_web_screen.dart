import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scanner/utils/custom_colors.dart';
import 'package:qr_scanner/utils/icons/copy_icon_button.dart';
import '../../utils/get_formatted_data.dart';
import '../../utils/save_qr_code.dart';
import '../../utils/share_qr_code.dart';

class GeneratedWebsiteScreen extends StatelessWidget {
  final String data;
  final GlobalKey _globalKey = GlobalKey();
  GeneratedWebsiteScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130), // Tăng chiều cao AppBar
        child: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.orange),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Website",
                          style: TextStyle(color: Colors.orange, fontSize: 20),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => shareQrCode(context, _globalKey),
                        icon: const Icon(Icons.ios_share, color: Colors.orange),
                      ),
                      IconButton(
                        onPressed: () async {
                          await saveQrCode(_globalKey, context);
                        },
                        icon: const Icon(Icons.download, color: Colors.orange),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding:const EdgeInsets.only(top: 40, left: 30),
                    child: Text(
                      "QR Code",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  color:
                        Theme.of(context).extension<CustomColors>()?.qrBackground,
                  padding: const EdgeInsets.all(20),
                  child: QrImageView(
                    data: _ensureUrlFormat(data), // Đảm bảo dữ liệu là URL hợp lệ
                    version: QrVersions.auto,
                    size: 300.0,
                    gapless: false,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      getFormattedData(data), // Hiển thị nội dung người dùng nhập
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  CopyIconButton(data: data),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _ensureUrlFormat(String input) {
  if (!input.startsWith("http://") && !input.startsWith("https://")) {
    return "https://$input"; // Thêm tiền tố nếu thiếu
  }
  return input;
}
