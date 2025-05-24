import 'package:flutter/material.dart';
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
              ContinueButton(screenHeight: screenHeight, screenWidth: screenWidth, text: "Continue", Screen: SuccessScreen() ),

              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
