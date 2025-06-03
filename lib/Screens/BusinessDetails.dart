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
  // controller for ideaDetails
  final TextEditingController BusinessNameController = TextEditingController();
  final TextEditingController BusinessSectorController =
      TextEditingController();
  final TextEditingController BusinessLocationController =
      TextEditingController();
  final TextEditingController BusinessCityController = TextEditingController();
  final TextEditingController IdeaDescriptionController =
      TextEditingController();
  final TextEditingController TargetMarketController = TextEditingController();
  final TextEditingController UniqueSellingController = TextEditingController();

  // controller for financialPlan
  final TextEditingController EstimatedCostController = TextEditingController();
  final TextEditingController FundingController = TextEditingController();
  final TextEditingController ExpectedRevenueController =
      TextEditingController();

  // controller for operational plan
  final TextEditingController TeamSizeController = TextEditingController();
  final TextEditingController ResourceRequiredController =
      TextEditingController();
  final TextEditingController TimelineController = TextEditingController();
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
        throw Exception(
            "Session ID not found. Please restart the signup process.");
      }

      final url = Uri.parse(
          "http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/api/signup/signup3");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "sessionId": sessionId,
          "ideaDetails": {
            "Business_Name": BusinessNameController.text,
            "Business_Sector": BusinessSectorController.text,
            "Business_City": BusinessCityController.text,
            "Buisness_Location":
                BusinessLocationController.text, // typo kept to match backend
            "Idea_Description": IdeaDescriptionController.text,
            "Target_Market": TargetMarketController.text,
            "Unique_Selling_Proposition": UniqueSellingController.text
          },
          "financialPlan": {
            "Estimated_Startup_Cost":
                int.tryParse(EstimatedCostController.text.trim()) ?? 0,
            "Funding_Required":
                int.tryParse(FundingController.text.trim()) ?? 0,
            "Expected_Revenue_First_Year":
                int.tryParse(ExpectedRevenueController.text.trim()) ?? 0,
          },
          "operationalPlan": {
            "Team_Size": int.tryParse(TeamSizeController.text.trim()) ?? 0,
            "Resources_Required": ResourceRequiredController.text.trim(),
            "Timeline_To_Launch": TimelineController.text.trim()
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

              buildSectionHeader("Idea Details"),
              InputField(
                  label: "Business Name", controller: BusinessNameController),
              InputField(
                  label: "Business Sector",
                  controller: BusinessSectorController),
              InputField(
                  label: "Business Location",
                  controller: BusinessLocationController),
              InputField(
                  label: "Business City", controller: BusinessCityController),
              InputField(
                  label: "Idea Description",
                  controller: IdeaDescriptionController),
              InputField(
                  label: "Target Market", controller: TargetMarketController),
              InputField(
                  label: "Unique Selling Proposition",
                  controller: UniqueSellingController),

              buildSectionHeader("Financial Plan"),
              InputField(
                  label: "Estimated Startup Cost",
                  controller: EstimatedCostController),
              InputField(
                  label: "Funding Required", controller: FundingController),
              InputField(
                  label: "Expected Revenue In 1st Year",
                  controller: ExpectedRevenueController),

              buildSectionHeader("Operational Plan"),
              InputField(label: "Team Size", controller: TeamSizeController),
              InputField(
                  label: "Resources Required",
                  controller: ResourceRequiredController),
              InputField(
                  label: "Timeline To Launch", controller: TimelineController),

              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8),
              //   child: DropdownButtonFormField<String>(
              //     decoration: InputDecoration(
              //       filled: true,
              //       fillColor: Colors.white,
              //       border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(12)),
              //     ),
              //     value: selectedLoanType,
              //     hint: const Text("Select Payment Type"),
              //     items: loanTypes.map((type) {
              //       return DropdownMenuItem(
              //         value: type,
              //         child: Text(type),
              //       );
              //     }).toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         selectedLoanType = value;
              //       });
              //     },
              //   ),
              // ),
              // InputField(
              //     label: "Loan Amount", controller: loanAmountController),

              // SizedBox(height: screenHeight * 0.02),
              // buildSectionHeader("Savings & Insurance"),
              // InputField(
              //     label: "Monthly Savings",
              //     controller: monthlySavingsController),

              // Column(
              //   children: [
              //     CheckboxListTile(
              //       title: const Text("Life Insurance",
              //           style: TextStyle(color: Colors.white)),
              //       value: lifeInsurance,
              //       onChanged: (val) {
              //         setState(() {
              //           lifeInsurance = val!;
              //         });
              //       },
              //     ),
              //     CheckboxListTile(
              //       title: const Text("Health Insurance",
              //           style: TextStyle(color: Colors.white)),
              //       value: healthInsurance,
              //       onChanged: (val) {
              //         setState(() {
              //           healthInsurance = val!;
              //         });
              //       },
              //     ),
              //     CheckboxListTile(
              //       title: const Text("Other Insurance",
              //           style: TextStyle(color: Colors.white)),
              //       value: cropInsurance,
              //       onChanged: (val) {
              //         setState(() {
              //           cropInsurance = val!;
              //         });
              //       },
              //     ),
              //   ],
              // ),

              SizedBox(height: screenHeight * 0.03),

              // Continue Button
              ContinueButton(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  text: "Continue",
                  onPressed: submitBusinessDetails),

              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
