import 'package:flutter/material.dart';
import 'package:shakti/Screens/Login.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/helpers/helper_functions.dart'; // Importing helper functions

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = THelperFunctions.screenWidth();
    double screenHeight = THelperFunctions.screenHeight();

    return Scaffold(
      backgroundColor: Scolor.primary,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.25),

            // Logo
            CircleAvatar(
              radius: screenWidth * 0.20, // Responsive size
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage(
                  'assets/logo.png'), // Update with your logo path
            ),

            SizedBox(height: screenHeight * 0.02), // Responsive spacing

            // App Name
            Text(
              "Shakti-Nxt",
              style: TextStyle(
                color: Scolor.light,
                fontSize: screenWidth * 0.07, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            // Tagline
            Text(
              "Your AI-Powered Business Guide",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Scolor.secondry.withOpacity(0.8),
                fontSize: screenWidth * 0.05,
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            // Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Scolor.secondry,
                      foregroundColor: Scolor.primary,
                      minimumSize: Size(double.infinity,
                          screenHeight * 0.07), // Responsive button height
                    ),
                    child: Text(
                      "Start Your Journey",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Scolor.secondry,
                      side: BorderSide(color: Scolor.secondry),
                      minimumSize: Size(double.infinity, screenHeight * 0.07),
                    ),
                    child: Text(
                      "Learn More",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.1),
          ],
        ),
      ),
    );
  }
}
