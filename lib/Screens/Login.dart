import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shakti/Widgets/AppWidgets/communitywidget/authhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shakti/Screens/BottomNavBar.dart';
import 'package:shakti/Screens/Profile.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/Continue.dart';
import 'package:shakti/Widgets/AppWidgets/InputField.dart';
import 'package:shakti/Widgets/AppWidgets/Subheading.dart';
import 'package:shakti/helpers/helper_functions.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  bool isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '701319090890-5ptlmu3ogiej1lneklmsh72n4d4im2uu.apps.googleusercontent.com',
  );

  bool isGoogleLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      isGoogleLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        setState(() {
          isGoogleLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // googleAuth.idToken is what you send to backend
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        setState(() {
          isGoogleLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get Google ID token')),
        );
        return;
      }

      // Send idToken to your backend API for verification
      final response = await http.post(
        Uri.parse(
            "http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/api/auth/google"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": idToken}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", responseData['token']);

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBarExample()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(responseData['message'] ?? 'Google Sign-In failed')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        isGoogleLoading = false;
      });
    }
  }

  final String loginUrl =
      "http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/api/auth/login";

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Email": email,
          "Password": password,
        }),
      );

      final responseData = jsonDecode(response.body);
      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200 && responseData['token'] != null) {
        // Save token locally using SharedPreferences (optional)
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", responseData['token']);
        await AuthHelper.saveLoginData(responseData);
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBarExample()),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "Login failed")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = THelperFunctions.screenWidth();
    double screenHeight = THelperFunctions.screenHeight();

    return Scaffold(
      backgroundColor: Scolor.primary,
      appBar: AppBar(
        backgroundColor: Scolor.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Scolor.secondry),
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
              CircleAvatar(
                radius: screenWidth * 0.15,
                backgroundColor: Colors.transparent,
                backgroundImage: const AssetImage('assets/logo.png'),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Shakti-Nxt",
                style: TextStyle(
                  color: Scolor.light,
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
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
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Need a Shakti-Nxt account? ",
                      style: TextStyle(color: Scolor.light),
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
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  border: Border.all(color: Scolor.secondry),
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.005),
                    InputField(
                      controller: emailController,
                      label: "Email-Id",
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: buildSubSection("Password")),
                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      style: const TextStyle(color: Scolor.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Scolor.primary,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Scolor.secondry, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Scolor.white, width: 2.5),
                        ),
                        hintText: "Enter Password",
                        hintStyle:
                            TextStyle(color: Scolor.white.withOpacity(0.5)),
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
                    isLoading
                        ? const CircularProgressIndicator(
                            color: Scolor.secondry)
                        : ContinueButton(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            text: "Log in",
                            onPressed: loginUser,
                          ),
                    SizedBox(height: screenHeight * 0.02),
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
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                width: screenWidth * 0.9,
                child: ElevatedButton.icon(
                  onPressed: isGoogleLoading ? null : _handleGoogleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Scolor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Scolor.secondry),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    elevation: 2,
                  ),
                  icon: Image.asset(
                    'assets/images/Google.png',
                    height: 20,
                    width: 20,
                  ),
                  label: isGoogleLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'SignUp with Google',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Scolor.light,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
