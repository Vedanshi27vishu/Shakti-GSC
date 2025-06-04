import 'package:flutter/material.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/ScreenHeadings.dart';
import 'package:shakti/Widgets/AppWidgets/YellowLine.dart';
import 'package:shakti/Widgets/ScreenWidgets/progresscontent.dart';
import 'package:shakti/helpers/helper_functions.dart';

class YourProgressScreen extends StatelessWidget {
  const YourProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = THelperFunctions.screenWidth(context);

    return Scaffold(
      backgroundColor: Scolor.primary, // Dark background
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
              // Title Row with Icon
              Row(
                children: [
                  Image.asset(
                    "assets/Progress.png",
                    height: 24, // Adjust height as needed
                    width: 24, // Adjust width as needed
                  ),
                  const SizedBox(width: 10),
                  ScreenHeadings(text: "Your Progress"),
                ],
              ),

              const SizedBox(height: 10),

              // Divider
              Yellowline(screenWidth: screenWidth),

              const SizedBox(height: 20),

              // Section 1: Set Clear Financial Goals
              buildSection(
                title: "1. Set Clear Financial Goals",
                description:
                    "Establishing clear financial goals helps you define where you want your business to be in the short, medium, and long term. These goals guide your decision-making process and allow you to track progress. For example:\n\n"
                    "• Short-term goals could include covering monthly expenses or improving cash flow.\n"
                    "• Mid-term goals might focus on growing revenue or expanding your product range.\n"
                    "• Long-term goals could involve building a strong financial base for sustainability or planning for business expansion.\n\n"
                    "Setting goals will give your business direction and a clear path forward.",
              ),

              const SizedBox(height: 20),

              // Section 2: Track and Monitor Cash Flow
              buildSection(
                title: "2. Track and Monitor Cash Flow",
                description:
                    "Cash flow is critical for the survival and growth of any business, especially for SMEs. Regularly monitoring cash flow allows you to understand whether your business has enough liquidity to cover operational expenses and pursue opportunities.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
