import 'package:flutter/material.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  String? _responseMessage;

  Future<void> resetPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token');

    if (token == null) {
      setState(() {
        _responseMessage = 'Token not found. Please request again.';
      });
      return;
    }

    final url = Uri.parse('https://shaktinxt.me/auth/reset-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": token,
        "newPassword": _passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _responseMessage = 'Password reset successfully!';
      });

      await prefs.remove('Token');

      // ✅ Show dialog box
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Your password has been reset successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } else {
      setState(() {
        _responseMessage = 'Failed to reset password. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Scolor.primary, // dark background for contrast
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white), // ✅ white inner text
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.yellow.shade700, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Scolor.secondry,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Scolor.primary,
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
