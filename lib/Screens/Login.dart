import 'package:flutter/material.dart';
import 'package:shakti/Screens/Profile.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/Continue.dart';

import 'package:shakti/Widgets/AppWidgets/InputField.dart';
import 'package:shakti/Widgets/AppWidgets/Subheading.dart';
import 'package:shakti/helpers/helper_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = THelperFunctions.screenWidth();
    double screenHeight = THelperFunctions.screenHeight();

    return Scaffold(
        backgroundColor: Scolor.primary,
        appBar: AppBar(
          backgroundColor: Scolor.primary,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Scolor.secondry),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.03),

                      // Logo
                      CircleAvatar(
                        radius: screenWidth * 0.15,
                        backgroundColor: Colors.transparent,
                        backgroundImage: const AssetImage('assets/logo.png'),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // App Name
                      Text(
                        "Shakti",
                        style: TextStyle(
                          color: Scolor.light,
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      // Login Heading
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            color: Scolor.light,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.005),

                      // Sign Up Link
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            text: "Need a Shakti account? ",
                            style:
                                TextStyle(color: Scolor.light.withOpacity(1)),
                            children: [
                              TextSpan(
                                text: "Create an account",
                                style: TextStyle(
                                  color: Scolor.secondry,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Login Form
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        decoration: BoxDecoration(
                          border: Border.all(color: Scolor.secondry),
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.03),
                        ),
                        child: Column(
                          children: [
                            // Email Field
                            
                            SizedBox(height: screenHeight * 0.005),
                            InputField(
                              controller: emailController,
                              label: "Username or Email-Id",
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // Password Field
                            Align(
                              alignment: Alignment.centerLeft,
                              child: buildSubSection("Password")
                            ),
                            //SizedBox(height: screenHeight * 0.005),
                            TextField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              style: const TextStyle(
                                  color: Scolor.white), // Match text color
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    Scolor.primary, // Match background color
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Scolor.secondry,
                                      width: 1), // Thin border
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Scolor.white,
                                      width: 3.5), // Focused border
                                ),
                                hintText: "Enter Password",
                                hintStyle: TextStyle(
                                    color: Scolor.white
                                        .withOpacity(0.5)), // Match hint style
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            // Login Button
                            ContinueButton(
                              screenHeight: screenHeight,
                              screenWidth: screenWidth,
                              text: "Log in",
                              Screen: ProfileScreen(),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // Forgot Username & Password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Forgot username?",
                                  style: TextStyle(
                                    color: Scolor.secondry,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                    color: Scolor.secondry,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                      //      SizedBox(height: screenHeight * 0.1),
                          ],
                        ),
                      ),
                    ]))));
  }
}
