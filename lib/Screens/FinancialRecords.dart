import 'package:flutter/material.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/ScreenHeadings.dart';
import 'package:shakti/Widgets/AppWidgets/YellowLine.dart';
import 'package:shakti/helpers/helper_functions.dart';

class FinancialRecordsScreen extends StatelessWidget {
  const FinancialRecordsScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenHeadings(text:  "Financial Records -"),
            SizedBox(height: screenHeight*0.01),
            Yellowline(screenWidth: screenWidth),
             SizedBox(height: screenHeight*0.02),
            const Text(
              "Documents:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight*0.02),
            Expanded(
              child: ListView.builder(
                itemCount: financialDocuments.length,
                itemBuilder: (context, index) {
                  final doc = financialDocuments[index];
                  return Card(
                    color: Scolor.primary,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.amber, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.insert_drive_file, color: Colors.amber, size: 30),
                      title: Text(
                        doc['title']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        doc['description']!,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Sample Data
final List<Map<String, String>> financialDocuments = [
  {
    'title': 'Monthly Planner.docs',
    'description': 'A detailed template to track income, expenses, and savings goals.',
  },
  {
    'title': 'Saving Goal Sheet.docs',
    'description': 'A document to plan and monitor short- and long-term savings goals.',
  },
  {
    'title': 'Balance Sheet.docs',
    'description': 'A snapshot of a company’s assets, liabilities, and equity at a specific point in time.',
  },
  {
    'title': 'Risk Assessment.docs',
    'description': 'A form to evaluate financial risk tolerance and align investments accordingly.',
  },
  {
    'title': 'Income Tax Filing.docs',
    'description': 'A detailed form to organize income, deductions, and tax liabilities before filing.',
  },
];
