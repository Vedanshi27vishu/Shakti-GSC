import 'package:flutter/material.dart';
import 'package:shakti/Utils/constants/colors.dart';

class ThreeCircle extends StatelessWidget {
  const ThreeCircle({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child: Container(
            width: screenWidth * 0.1,
            height: screenWidth * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Scolor.secondry, width: 2),
              color: index == 0 ? Scolor.secondry : Colors.transparent,
            ),
            child: Center(
              child: index == 0
                  ? const Icon(Icons.check, color: Colors.white)
                  : Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Scolor.secondry,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
