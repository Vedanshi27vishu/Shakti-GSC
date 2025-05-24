import 'package:flutter/material.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/ScreenHeadings.dart';
import 'package:shakti/Widgets/AppWidgets/YellowLine.dart';
import 'package:shakti/helpers/helper_functions.dart';

class InvestmentScreen extends StatelessWidget {
  const InvestmentScreen({super.key});

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
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
        //  vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const ScreenHeadings(text: "Invest-"),
            SizedBox(height: screenHeight * 0.005),
           Yellowline(screenWidth: screenWidth),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: investmentPlans.length,
                itemBuilder: (context, index) {
                  final plan = investmentPlans[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: plan['borderColor']!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/rupees.png",
                              width: screenWidth * 0.07,
                              height: screenWidth * 0.07,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: Text(
                                plan['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          plan['subtitle']!,
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          "Minimum: ${plan['minimum']}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Duration: ${plan['duration']}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: plan['features']!.map<Widget>((feature) {
                            return Row(
                              children: [
                                const Icon(Icons.circle,
                                    size: 6, color: Colors.amber),
                                SizedBox(width: screenWidth * 0.02),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Returns: ${plan['returns']}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Group: ${plan['group']}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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

// ✅ Sample Data
final List<Map<String, dynamic>> investmentPlans = [
  {
    'title': 'Daily Savings Scheme',
    'subtitle': 'Start with just ₹20 per day',
    'minimum': '₹20',
    'duration': 'Flexible',
    'features': [
      'No lock-in period',
      'Daily collection',
      'Mobile money deposit',
    ],
    'returns': '6%',
    'group': 'Individual',
    'borderColor': Colors.amber,
  },
  {
    'title': 'Micro Enterprise Bond',
    'subtitle': 'For established micro business',
    'minimum': '₹500',
    'duration': '1 year',
    'features': [
      'Business loans',
      'Insurance coverage',
      'Expert mentorship',
    ],
    'returns': '12%',
    'group': 'Individual',
    'borderColor': Colors.amber,
  },
  {
    'title': 'Self-Help Group Fund',
    'subtitle': 'Group-based weekly investment',
    'minimum': '₹100',
    'duration': '6 months',
    'features': [
      'Group liability',
      'Weekly meetings',
      'Skill development',
    ],
    'returns': '8%-10%',
    'group': '10-15 women',
    'borderColor': Colors.amber,
  },
];
