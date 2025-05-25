import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shakti/Screens/Success.dart';
import 'package:shakti/Widgets/AppWidgets/Continue.dart';
import 'package:shakti/Widgets/AppWidgets/InputField.dart';
import 'package:shakti/Widgets/AppWidgets/ThreeCircle.dart';
import 'package:shakti/Widgets/AppWidgets/UnderlineHeading.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/helpers/helper_functions.dart';

class BusinessDetails extends StatefulWidget {
  const BusinessDetails({super.key});

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  final TextEditingController monthlyPaymentController =
      TextEditingController();
  final TextEditingController lenderNameController = TextEditingController();
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController monthlySavingsController =
      TextEditingController();
  String? selectedLoanType;
  final List<String> loanTypes = [
    'Personal Loan',
    'Home Loan',
    'Business Loan'
  ];

  bool lifeInsurance = false;
  bool healthInsurance = false;
  bool cropInsurance = false;

   bool isLoading = false;

   // API call to submit business details
Future<void> submitBusinessDetails() async {
  try {
    setState(() {
      isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('sessionId');

    if (sessionId == null) {
      throw Exception("Session ID not found. Please restart the signup process.");
    }

    final url = Uri.parse(
      "http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/api/signup/signup3"
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "sessionId": sessionId,
        "ideaDetails": {
          "Business_Name": lenderNameController.text,
          "Business_Sector": selectedLoanType,
          "Business_Location": "Dummy Location",
          "Buisness_City": "Dummy City",
          "Idea_Description": "This is a placeholder description.",
          "Target_Market": "Rural India",
          "Unique_Selling_Proposition": "Affordable service"
        },
        "financialPlan": {
          "Estimated_Startup_Cost": loanAmountController.text,
          "Funding_Required": "100000",
          "Expected_Revenue_First_Year": "500000"
        },
        "operationalPlan": {
          "Team_Size": "3",
          "Resources_Required": "Basic machinery",
          "Timeline_To_Launch": "3 months"
        }
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 && data['token'] != null) {
      await prefs.setString('token', data['token']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SuccessScreen()),
      );
    } else {
      throw Exception(data['message'] ?? "Signup failed.");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error: ${e.toString()}"),
      backgroundColor: Colors.red,
    ));
  } finally {
    setState(() {
      isLoading = false;
    });
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

              // Business Details Title
              const Text(
                "Business Details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              buildSectionHeader("Loan Details"),
              InputField(
                  label: "Monthly Payment",
                  controller: monthlyPaymentController),
              InputField(
                  label: "Lender Name", controller: lenderNameController),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  value: selectedLoanType,
                  hint: const Text("Select Payment Type"),
                  items: loanTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLoanType = value;
                    });
                  },
                ),
              ),
              InputField(
                  label: "Loan Amount", controller: loanAmountController),

              SizedBox(height: screenHeight * 0.02),
              buildSectionHeader("Savings & Insurance"),
              InputField(
                  label: "Monthly Savings",
                  controller: monthlySavingsController),

              Column(
                children: [
                  CheckboxListTile(
                    title: const Text("Life Insurance",
                        style: TextStyle(color: Colors.white)),
                    value: lifeInsurance,
                    onChanged: (val) {
                      setState(() {
                        lifeInsurance = val!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Health Insurance",
                        style: TextStyle(color: Colors.white)),
                    value: healthInsurance,
                    onChanged: (val) {
                      setState(() {
                        healthInsurance = val!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Other Insurance",
                        style: TextStyle(color: Colors.white)),
                    value: cropInsurance,
                    onChanged: (val) {
                      setState(() {
                        cropInsurance = val!;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              // Continue Button
              ContinueButton(screenHeight: screenHeight, screenWidth: screenWidth, text: "Continue", onPressed: submitBusinessDetails ),

              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
