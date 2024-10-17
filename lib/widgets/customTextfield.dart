
import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  CustomTextField({
    required this.labelText,
    required this.controller,
    this.maxLines = 1, // Default maxLines is 1 for single-line input
  });

  final String labelText;
  final int maxLines; // maxLines should be of type int
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          maxLines: maxLines, // Use maxLines as it is
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

