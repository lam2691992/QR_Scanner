import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> saveQrCode(GlobalKey globalKey, BuildContext context) async {
  // Yêu cầu quyền lưu trữ
  var status = await Permission.storage.request();
  if (!status.isGranted) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Permission denied!"),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  // Lấy RenderObject từ GlobalKey
  RenderRepaintBoundary? boundary =
      globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error capturing QR code. Try again!"),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  // Chụp ảnh widget thành ảnh PNG
  var image = await boundary.toImage();
  ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
  if (byteData == null) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error converting image to bytes!"),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }
  Uint8List pngBytes = byteData.buffer.asUint8List();

  // Lưu ảnh vào thư mục tạm thời
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/QRcode.png');
  await file.writeAsBytes(pngBytes);

  if (await file.exists()) {
    // Lưu ảnh vào thư viện ảnh
    final result = await ImageGallerySaver.saveImage(
      pngBytes,
      quality: 100,
      name: "text",
    );
    if (result["isSuccess"]) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Image saved to gallery!"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error saving image!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } else {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("File does not exist after saving!"),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
