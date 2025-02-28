import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/copy_text.dart';
import '../../utils/get_formatted_data.dart';
import '../../utils/save_qr_code.dart';
import '../../utils/share_qr_code.dart';

class GeneratedLocationScreen extends StatelessWidget {
  final String data;
  final GlobalKey _globalKey = GlobalKey();
  GeneratedLocationScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(95), // Tăng chiều cao AppBar
        child: AppBar(
          backgroundColor: Colors.black,
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
                          "Location",
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
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40, left: 30),
                    child: Text(
                      "QR Code",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: QrImageView(
                  data: data,
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
                GestureDetector(
                  onTap: () {
                    copyText(context,
                        data); // Gọi hàm copyText để copy 'data' vào clipboard
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.copy,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
