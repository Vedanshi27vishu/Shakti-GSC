import 'package:flutter/material.dart';
import 'package:shakti/Screens/Start.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/helpers/helper_functions.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn)
      ..addListener(() {
        setState(() {});
      });

    _controller!.forward();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StartScreen())); // Replace with your main screen widget
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = THelperFunctions.screenWidth(context);
    double screenHeight = THelperFunctions.screenHeight(context);
    return Scaffold(
      backgroundColor: Scolor.primary,
      body: FadeTransition(
        opacity: _animation!,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 250,
                  width: 250,
                  child: Image.asset('assets/logo.png')),
              SizedBox(height: screenHeight * 0.02), // Responsive spacing

              // App Name
              Text(
                "Shakti-Nxt",
                style: TextStyle(
                  color: Scolor.light,
                  fontSize: screenWidth * 0.10, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ), // Replace with your image asset
        ),
      ),
    );
  }
}
