import 'package:flutter/material.dart';
import 'package:shakti/Screens/resetpassword.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _responseMessage;

  Future<void> sendForgotPasswordRequest() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    final url = Uri.parse('https://shaktinxt.me/auth/forgot-password');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"Email": email}),
    );

    final prefs = await SharedPreferences.getInstance();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final message = data['message'];
      final token = data['token'];

      if (token != null && token is String) {
        await prefs.setString('Token', token); // Save under correct key
        setState(() {
          _responseMessage = message;
        });

        // Navigate to ResetPasswordScreen
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
        );
      } else {
        setState(() {
          _responseMessage = 'Token not found in response.';
        });
      }
    } else {
      setState(() {
        _responseMessage = 'Error: ${response.reasonPhrase}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Scolor.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Scolor.secondry),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Scolor.secondry,
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: sendForgotPasswordRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Scolor.secondry,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: const Text(
                  'Send',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Scolor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_responseMessage != null)
              Text(
                _responseMessage!,
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
