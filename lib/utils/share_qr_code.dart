import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Hàm này chụp ảnh từ RepaintBoundary được gán bằng globalKey,
// hiển thị hộp thoại để người dùng nhập nội dung chia sẻ,
// lưu ảnh tạm thời và chia sẻ ảnh kèm nội dung.
Future<void> shareQrCode(BuildContext context, GlobalKey globalKey) async {
  try {
    // Hiển thị hộp thoại để nhập nội dung chia sẻ
    TextEditingController textController = TextEditingController();
    String? shareText = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            "Share name",
            style: TextStyle(color: Colors.orange),
          ),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none),
              hintText: "...",
              hintStyle: const TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(null);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(textController.text);
              },
              child: const Text(
                "Share",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );

    if (shareText == null) return;

    // Lấy RenderObject từ GlobalKey
    RenderRepaintBoundary? boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      if (!context.mounted) return;

      // Nếu không lấy được RenderBoundary, hiển thị thông báo lỗi
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
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Lưu ảnh vào thư mục tạm thời
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/QRcode.png');
    await file.writeAsBytes(pngBytes);

    if (await file.exists()) {
      // Chia sẻ ảnh với nội dung mà người dùng nhập
      await Share.shareXFiles([XFile(file.path)], text: shareText);
    } else {
      print("❌ Lỗi: File không tồn tại sau khi lưu!");
    }
  } catch (e) {
    print("❌ Lỗi khi chia sẻ: $e");
  }
}
