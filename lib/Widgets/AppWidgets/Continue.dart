import 'package:flutter/material.dart';
import 'package:shakti/Utils/constants/colors.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.text,
    required this.onPressed,
  });

  final double screenHeight;
  final double screenWidth;
  final dynamic text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.06,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Scolor.secondry,
          foregroundColor: Scolor.primary,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
