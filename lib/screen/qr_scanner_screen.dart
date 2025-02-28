import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatelessWidget {
  final Function(String) onQRScanned;

  const QRScannerScreen({super.key, required this.onQRScanned});

  @override
  Widget build(BuildContext context) {
    // Tạo controller với danh sách định dạng barcode bạn muốn quét
    final MobileScannerController scannerController =
        MobileScannerController(formats: [BarcodeFormat.all]);

    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR')),
      body: MobileScanner(
        controller: scannerController,
        onDetect: (BarcodeCapture barcodeCapture) {
          for (final barcode in barcodeCapture.barcodes) {
            final String? scannedData = barcode.rawValue;
            if (scannedData != null) {
              onQRScanned(scannedData);
              break;
            }
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
