import 'package:flutter/material.dart';
import 'package:qr_scanner/utils/copy_text.dart';

class CopyIconButton extends StatelessWidget {
  final String data;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final double iconSize;
  final Color iconColor;

  const CopyIconButton({
    super.key,
    required this.data,
    this.padding,
    this.decoration,
    this.iconSize = 24,
    this.iconColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        copyText(context, data);
      },
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: decoration ??
            BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
        child: Icon(
          Icons.copy,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
