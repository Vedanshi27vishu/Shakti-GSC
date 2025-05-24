import 'package:flutter/material.dart';
import 'package:shakti/Screens/BusinessDetails.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/Continue.dart';
import 'package:shakti/Widgets/AppWidgets/InputField.dart';
import 'package:shakti/Widgets/AppWidgets/Subheading.dart';
import 'package:shakti/Widgets/AppWidgets/ThreeCircle.dart';
import 'package:shakti/Widgets/AppWidgets/UnderlineHeading.dart';
import 'package:shakti/helpers/helper_functions.dart';

class FinancialDetails extends StatefulWidget {
  const FinancialDetails({super.key});

  @override
  State<FinancialDetails> createState() => _FinancialDetailsState();
}

class _FinancialDetailsState extends State<FinancialDetails> {
  // Controllers for input fields
  final TextEditingController primaryIncomeController = TextEditingController();
  final TextEditingController additionalIncomeController =
      TextEditingController();
  final TextEditingController goldAmountController = TextEditingController();
  final TextEditingController goldValueController = TextEditingController();
  final TextEditingController landAreaController = TextEditingController();
  final TextEditingController landValueController = TextEditingController();
  final TextEditingController loanPaymentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = THelperFunctions.screenWidth();
    double screenHeight = THelperFunctions.screenHeight();

    return Scaffold(
      backgroundColor:Scolor.primary, // Dark background color
      appBar: AppBar(
        backgroundColor: Scolor.primary,
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
              // Progress Indicator
              ThreeCircle(screenWidth: screenWidth),

              SizedBox(height: screenHeight * 0.03),

              // Financial Details Title
              const Text(
                "Financial Details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Section: Income Details
              buildSectionHeader("Income Details"),
              InputField(
                  label: "Primary Monthly Income",
                  controller: primaryIncomeController),
              InputField(
                  label: "Additional Monthly Income",
                  controller: additionalIncomeController),

              SizedBox(height: screenHeight * 0.02),

              // Section: Assets Details
              buildSectionHeader("Assets Details"),
              buildSubSection("Gold Assets"),
              InputField(
                  label: "Amount (in grams)", controller: goldAmountController),
              InputField(
                  label: "Approximate Value (₹)",
                  controller: goldValueController),

              SizedBox(height: screenHeight * 0.02),

              buildSubSection("Land Assets"),
              InputField(
                  label: "Area (in acres)", controller: landAreaController),
              InputField(
                  label: "Approximate Value (₹)",
                  controller: landValueController),

              SizedBox(height: screenHeight * 0.02),

              // Section: Existing Loans
              buildSectionHeader("Existing Loans"),
              InputField(
                  label: "Monthly Payment", controller: loanPaymentController),

                SizedBox(height: screenHeight * 0.04),

              // Continue Button
             ContinueButton(screenHeight: screenHeight, screenWidth: screenWidth, text: "Continue", Screen: BusinessDetails()),

              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
