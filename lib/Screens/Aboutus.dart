import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double contentMaxWidth;

    // Responsive max width according to login screen pattern
    if (sw < 600) {
      contentMaxWidth = sw * 0.95 > 400 ? 400 : sw * 0.95;
    } else if (sw < 1000) {
      contentMaxWidth = 600;
    } else {
      contentMaxWidth = 850;
    }

    return Scaffold(
      backgroundColor: Scolor.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Scolor.secondry,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "About Us",
          style: TextStyle(
            color: Scolor.light,
            fontSize: 20.sp.clamp(18, 25),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentMaxWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: sw < 600 ? 10.w.clamp(8, 20) : 20.w.clamp(16, 40)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  SizedBox(height: 30.h),

                  // Test Credentials Container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w.clamp(16, 24)),
                    decoration: BoxDecoration(
                      color: Scolor.secondry,
                      borderRadius: BorderRadius.circular(16.r.clamp(12, 20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.key,
                              color: Scolor.primary,
                              size: 24.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Test Credentials",
                              style: TextStyle(
                                color: Scolor.primary,
                                fontSize: 18.sp.clamp(16, 22),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Email Field
                        _buildCredentialField(
                          context,
                          "Email",
                          "aikanshtiwari007@gmail.com",
                          Icons.email,
                        ),
                        SizedBox(height: 12.h),

                        // Password Field
                        _buildCredentialField(
                          context,
                          "Password",
                          "Test@123",
                          Icons.lock,
                        ),
                        SizedBox(height: 16.h),

                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Scolor.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Scolor.primary,
                                size: 16.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  "Use these credentials for testing and exploring the app features only.",
                                  style: TextStyle(
                                    color: Scolor.primary,
                                    fontSize: 12.sp.clamp(10, 14),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Team Section
                  Text(
                    "Meet Our Team",
                    style: TextStyle(
                      color: Scolor.light,
                      fontSize: 24.sp.clamp(20, 28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Team Members
                  _buildTeamMember(
                      "assets/images/Aikansh.jpg",
                      "Aikansh Tiwari",
                      "Software Developer",
                      "\"I'm a Full Stack App Developer with experience in Flutter and Node.js. I also have a strong passion for problem solving and Data Structures & Algorithms. You can connect with me on GitHub(aikansh008) and via email(aikanshtiwari007@gmail.com).\""),
                  SizedBox(height: 20.h),
                  _buildTeamMember(
                    "assets/images/1750482628529.jpeg",
                    "Vedanshi Aggarwal",
                    "Software Developer",
                    "\"Hi, I'm an expert Flutter and Node.js developer with a strong grasp of Data Structures and Algorithms, as well as excellent problem-solving skills. connect with me on GitHub (Vedanshi27vishu) and via email (vedanshi27vishu@gmail.com)\"",
                  ),
                  SizedBox(height: 40.h),

                  // Mission Statement
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w.clamp(16, 24)),
                    decoration: BoxDecoration(
                      color: Scolor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Scolor.secondry,
                        width: 3,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Scolor.secondry,
                          size: 32.sp,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Our Mission",
                          style: TextStyle(
                            color: Scolor.light,
                            fontSize: 18.sp.clamp(16, 22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // RichText for clickable link
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: Scolor.light.withOpacity(0.8),
                              fontSize: 14.sp.clamp(12, 16),
                              height: 1.5,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    "To empower businesses with AI-driven insights and tools that simplify complex decisions and accelerate growth in the digital age (AI based SHARK TANK). For more information about code base visit our GitHub repository: ",
                              ),
                              TextSpan(
                                text: "Frontend",
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url =
                                        "https://github.com/aikansh008/Shakti-Nxt";
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url),
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                              ),
                              const TextSpan(text: " and "),
                              TextSpan(
                                text: "Backend",
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url =
                                        "https://github.com/aikansh008/Shakti-Backend";
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url),
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                              ),
                              const TextSpan(text: ". "),
                              TextSpan(
                                text: "APK",
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url =
                                        "https://drive.google.com/drive/u/0/folders/1Bd8dH0U6-gzoOZg-YAeIxSOm208epLlc";
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url),
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialField(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Scolor.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Scolor.primary.withOpacity(0.7),
            size: 18.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Scolor.primary.withOpacity(0.7),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Scolor.primary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$label copied to clipboard"),
                  backgroundColor: Scolor.primary,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Scolor.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(
                Icons.copy,
                color: Scolor.primary,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
    String imagePath,
    String name,
    String role,
    String description,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w.clamp(16, 24)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Scolor.secondry,
          width: 3,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40.r.clamp(32, 48),
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(height: 16.h),
          Text(
            name,
            style: TextStyle(
              color: Scolor.light,
              fontSize: 18.sp.clamp(16, 22),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            role,
            style: TextStyle(
              color: Scolor.secondry,
              fontSize: 14.sp.clamp(12, 16),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            description,
            style: TextStyle(
              color: Scolor.light.withOpacity(0.8),
              fontSize: 13.sp.clamp(11, 15),
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
