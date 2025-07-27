import 'package:flutter/material.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/ScreenHeadings.dart';
import 'package:shakti/Widgets/AppWidgets/YellowLine.dart';
import 'package:shakti/helpers/helper_functions.dart';

class YourProgressScreen extends StatelessWidget {
  final List<Map<String, dynamic>> progressData;

  const YourProgressScreen({
    super.key,
    this.progressData = const [],
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = THelperFunctions.screenWidth(context);

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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/Progress.png",
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 10),
                  ScreenHeadings(text: "Your Progress"),
                ],
              ),
              const SizedBox(height: 10),
              Yellowline(screenWidth: screenWidth),
              const SizedBox(height: 20),

              // Dynamic Progress Content
              if (progressData.isNotEmpty) ...[
                ...progressData.asMap().entries.map((entry) {
                  int index = entry.key;
                  final item = entry.value;
                  final title = item['title'] ?? '';
                  final description = item['description'] ?? '';

                  return Column(
                    children: [
                      buildSection(
                        title: "${index + 1}. $title",
                        description: description,
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ] else ...[
                buildSection(
                  title: "1. Set Clear Financial Goals",
                  description:
                      "Establishing clear financial goals helps you define where you want your business to be in the short, medium, and long term.\n\n"
                      "Implementation Tips:\n"
                      "• Break this goal into smaller, manageable tasks\n"
                      "• Set specific deadlines and milestones\n"
                      "• Track your progress regularly\n"
                      "• Adjust your approach based on results\n\n"
                      "Remember: Consistent small steps lead to significant progress over time.",
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection({required String title, required String description}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Scolor.primary,
        borderRadius: BorderRadius.circular(12),
        //    border: Border.all(color: Scolor.secondry.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Scolor.secondry,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
