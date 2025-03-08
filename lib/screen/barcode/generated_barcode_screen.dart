import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_scanner/utils/icons/copy_icon_button.dart';

import '../../utils/copy_text.dart';
import '../../utils/get_formatted_data.dart';
import '../../utils/save_qr_code.dart';
import '../../utils/share_qr_code.dart';

class GeneratedBarcodeScreen extends StatelessWidget {
  final String data;
  final String barcodeType;
  final GlobalKey _globalKey = GlobalKey();

  GeneratedBarcodeScreen({
    super.key,
    required this.data,
    required this.barcodeType,
  });

  /// Chọn đối tượng Barcode dựa trên barcodeType được chọn
  Barcode getBarcode() {
    switch (barcodeType) {
      case "Code 93":
        return Barcode.code93();
      case "Code 39":
        return Barcode.code39();
      case "CODABAR":
        return Barcode.codabar();
      case "Code 128":
        return Barcode.code128();
      case "EAN-13":
        return Barcode.ean13();
      case "EAN-8":
        return Barcode.ean8();
      case "UPC-A":
        return Barcode.upcA();
      case "UPC-E":
        return Barcode.upcE();
      default:
        return Barcode.code128(); // Mặc định
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tạo barcode dưới dạng SVG
    final Barcode bc = getBarcode();
    final String svg = bc.toSvg(
      data,
      width: 300,
      height: 150,
      drawText: false,
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.orange),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Barcode",
                            style:
                                TextStyle(color: Colors.orange, fontSize: 20),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => shareQrCode(context, _globalKey),
                          icon:
                              const Icon(Icons.ios_share, color: Colors.orange),
                        ),
                        IconButton(
                          onPressed: () async {
                            await saveQrCode(_globalKey, context);
                          },
                          icon:
                              const Icon(Icons.download, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    child: Text(
                      "Barcode",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                    ),
                  ),
                ],
              ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                  ),
                  child: SvgPicture.string(
                    svg,
                    fit: BoxFit.scaleDown,
                    placeholderBuilder: (context) =>
                        const CircularProgressIndicator(),
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
