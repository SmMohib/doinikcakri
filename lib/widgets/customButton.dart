
import 'package:doinikcakri/widgets/texts.dart';
import 'package:flutter/material.dart';

import '../component/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
  
  });
  final String title;
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: primaryColor,
      child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            onPressed();
          },
          child: Padding(
            padding: const EdgeInsets.only(
                left: 18, right: 18, top: 10, bottom: 10),
            child: Center(
              child: textPoppins(
                  text: title, color: whiteColor, isTile: false, fontSize: 14),
            ),
          )),
    );
  }
}