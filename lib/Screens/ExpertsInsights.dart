import 'package:flutter/material.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/ScreenHeadings.dart';
import 'package:shakti/Widgets/AppWidgets/YellowLine.dart';
import 'package:shakti/helpers/helper_functions.dart';

class FinancialInsightsScreen extends StatelessWidget {
  const FinancialInsightsScreen({super.key});

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
            ScreenHeadings(text: "Experts insights for financial business-"),
            SizedBox(height: screenHeight*0.01),
            Yellowline(screenWidth: screenWidth),
          SizedBox(height: screenHeight*0.01),

            // Expanded ListView for responsiveness
            Expanded(
              child: ListView.builder(
                itemCount: insights.length,
                itemBuilder: (context, index) {
                  final item = insights[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item['image'] ?? 'assets/default.png',
                            width: screenWidth * 0.25, // Responsive image width
                            height: screenHeight * 0.12, // Responsive image height
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Expanded to prevent overflow
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] ?? 'No title available',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                item['description'] ?? '',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Duration Container
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            item['duration'] ?? '0:00',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
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

// ✅ Corrected Sample Data
final List<Map<String, String>> insights = [
  {
    'image': "assets/video1.png",
    'title': 'Financial Management For Small Businesses',
    'description': 'This video covers essential financial management practices.',
    'duration': '5:41',
  },
  {
    'image': 'assets/video2.png',
    'title': 'Profitability and Cash Flow Management',
    'description': 'Strategies to enhance profitability in SMEs.',
    'duration': '2:20',
  },
  {
    'image': 'assets/video3.png',
    'title': '2022 ABH Training - Financial Management',
    'description': 'Insights for business owners on profitability.',
    'duration': '6:00',
  },
  {
    'image': 'assets/video4.png',
    'title': 'Financial Literacy and Management Skills',
    'description': 'The importance of financial literacy for SMEs.',
    'duration': '6:34',
  },
  {
    'image': 'assets/video5.png',
    'title': 'How to Manage Small Business Finances',
    'description': 'Practical habits to enhance financial management.',
    'duration': '7:54',
  },
];
