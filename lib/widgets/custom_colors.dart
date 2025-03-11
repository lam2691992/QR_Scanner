import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? qrBackground; // Thuộc tính màu cho container QR

  const CustomColors({required this.qrBackground});

  @override
  CustomColors copyWith({Color? qrBackground}) {
    return CustomColors(
      qrBackground: qrBackground ?? this.qrBackground,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      qrBackground: Color.lerp(qrBackground, other.qrBackground, t),
    );
  }
}
