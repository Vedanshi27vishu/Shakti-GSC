import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shakti/Widgets/AppWidgets/UnderlineHeading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shakti/Screens/BusinessDetails.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/Continue.dart';
import 'package:shakti/Widgets/AppWidgets/InputField.dart';
import 'package:shakti/Widgets/AppWidgets/Subheading.dart';
import 'package:shakti/Widgets/AppWidgets/ThreeCircle.dart';
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
  final TextEditingController monthlyloanPaymentController = TextEditingController();
  final TextEditingController totalloanPaymentController= TextEditingController();
   double screenWidth = 0;
  double screenHeight = 0;

Future<void> submitFinancialDetails() async {
  final prefs = await SharedPreferences.getInstance();
  final sessionId = prefs.getString('sessionId');

  if (sessionId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Session ID not found. Please restart the form.")),
    );
    return;
  }

  final url = Uri.parse("http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/api/signup/signup2");

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "sessionId": sessionId, // ✅ Moved to body
      "incomeDetails": {
        "Primary_Monthly_Income": primaryIncomeController.text.trim(),
        "Additional_Monthly_Income": additionalIncomeController.text.trim(),
      },
      "assetDetails": {
        "Gold_Asset_amount": goldAmountController.text.trim(),
        "Gold_Asset_App_Value": goldValueController.text.trim(),
        "Land_Asset_Area": landAreaController.text.trim(),
        "Land_Asset_App_Value": landValueController.text.trim(),
      },
      "existingloanDetails": {
        "Monthly_Payment": monthlyloanPaymentController.text.trim(),
        "Total_Loan_Amount": totalloanPaymentController.text.trim(),
      }
    }),
  );

  if (response.statusCode == 200) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BusinessDetails()),
    );
  } else {
    debugPrint("Error: ${response.body}");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to submit financial details.")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
     screenWidth = THelperFunctions.screenWidth();
     screenHeight = THelperFunctions.screenHeight();

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
                  label: "Monthly Payment", controller: monthlyloanPaymentController),
              InputField(
                  label: "Total_Loan_Amount", controller: totalloanPaymentController),

                SizedBox(height: screenHeight * 0.04),

              // Continue Button
             ContinueButton(screenHeight: screenHeight, screenWidth: screenWidth, text: "Continue", onPressed:submitFinancialDetails, ),

              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
