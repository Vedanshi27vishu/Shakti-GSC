import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakti/Screens/Login.dart';
import 'package:shakti/Utils/constants/colors.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Scolor.primary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive maxWidth: 400 (phone), 600 (tablet), 900 (desktop)
          double contentMaxWidth;
          double sw = constraints.maxWidth;
          if (sw < 600) {
            contentMaxWidth = 400;
          } else if (sw < 1000) {
            contentMaxWidth = 600;
          } else {
            contentMaxWidth = 900;
          }

          return Center(
            child: Container(
              width: contentMaxWidth,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w.clamp(16, 40), // responsive side padding
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 120.h.clamp(60, 160)),

                    // Logo
                    CircleAvatar(
                      radius: 70.r.clamp(48, 90),
                      backgroundColor: Colors.transparent,
                      backgroundImage: const AssetImage('assets/logo.png'),
                    ),

                    SizedBox(height: 20.h.clamp(8, 40)),

                    // App Name
                    Text(
                      "Shakti-Nxt",
                      style: TextStyle(
                        color: Scolor.light,
                        fontSize: 28.sp.clamp(20, 32),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 8.h.clamp(4, 16)),

                    // Tagline
                    Text(
                      "Your AI-Powered Business Guide",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Scolor.secondry.withOpacity(0.8),
                        fontSize: 16.sp.clamp(12, 20),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 40.h.clamp(18, 64)),

                    // Start Journey Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h.clamp(45, 55),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Scolor.secondry,
                          foregroundColor: Scolor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r.clamp(8, 20)),
                          ),
                        ),
                        child: Text(
                          "Start Your Journey",
                          style: TextStyle(
                            fontSize: 16.sp.clamp(14, 20),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h.clamp(8, 24)),

                    // Learn More Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h.clamp(45, 55),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Scolor.secondry,
                          side: BorderSide(color: Scolor.secondry),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r.clamp(8, 20)),
                          ),
                        ),
                        child: Text(
                          "Learn More",
                          style: TextStyle(
                            fontSize: 16.sp.clamp(14, 20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 80.h.clamp(24, 120)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
