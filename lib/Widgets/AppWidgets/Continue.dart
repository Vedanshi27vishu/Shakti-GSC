import 'package:flutter/material.dart';
import 'package:shakti/Utils/constants/colors.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.text,
    required this.Screen,
  });

  final double screenHeight;
  final double screenWidth;
  final dynamic text;
  final dynamic Screen;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.06,
      child: ElevatedButton(
        onPressed: () {
          // Handle Login Logic
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Screen));
        },
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
