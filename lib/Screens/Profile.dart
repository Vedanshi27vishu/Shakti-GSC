import 'package:flutter/material.dart';
import 'package:shakti/Screens/FinancialDetails.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/Continue.dart';
import 'package:shakti/Widgets/AppWidgets/InputField.dart';
import 'package:shakti/Widgets/AppWidgets/ThreeCircle.dart';
import 'package:shakti/Widgets/AppWidgets/UnderlineHeading.dart';
import 'package:shakti/helpers/helper_functions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = THelperFunctions.screenWidth();
    double screenHeight = THelperFunctions.screenHeight();

    return Scaffold(
      backgroundColor:Scolor.primary, // Dark theme background
      appBar: AppBar(
        backgroundColor:Scolor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Scolor.secondry),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Indicator
              ThreeCircle(screenWidth: screenWidth),

              SizedBox(height: screenHeight * 0.03),

              // Title
              const Text(
                "Create Your Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Section: Personal Information
              buildSectionHeader("Personal Information"),
              InputField( label: "Full Name", controller: nameController),
              InputField(label:"Preferred Language",controller: languageController),

              SizedBox(height: screenHeight * 0.02),

              // Section: Professional Details
               buildSectionHeader("Professional Details"),
              InputField(label:"Business Experience",controller: experienceController),
              InputField(
                  label:"Educational Qualifications",controller: qualificationController),

              SizedBox(height: screenHeight * 0.04),

              // Continue Button
             ContinueButton(screenHeight: screenHeight, screenWidth: screenWidth, text: "Continue", Screen: FinancialDetails()),

              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

