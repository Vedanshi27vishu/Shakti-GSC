import 'package:flutter/material.dart';

class ScreenHeadings extends StatelessWidget {
  final dynamic text;

  const ScreenHeadings({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return  Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
