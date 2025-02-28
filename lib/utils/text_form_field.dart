// text_fỏm_field
import 'package:flutter/material.dart';

/// Hàm tạo widget TextFormField
Widget buildTextFieldWithCounter({
  required BuildContext context,
  required TextEditingController controller,
  required int currentLength,
  int maxLength = 300,
  int maxLines = 10,
  String labelText = "Text here...",
}) {
  return Stack(
    children: [
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          floatingLabelAlignment: FloatingLabelAlignment.start,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          counterText: "",
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color: Colors.grey,
              ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        maxLength: maxLength,
      ),
      Positioned(
        bottom: 8,
        right: 12,
        child: Text(
          "$currentLength/$maxLength",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 14,
              ),
        ),
      ),
    ],
  );
}
