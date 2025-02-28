import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Hàm copy văn bản vào Clipboard và hiển thị SnackBar thông báo.
Future<void> copyText(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Copied to clipboard!"),
      duration: Duration(seconds: 2),
    ),
  );
}
