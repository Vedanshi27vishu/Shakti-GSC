import 'package:flutter/material.dart';
import 'package:shakti/Widgets/AppWidgets/CommunityHomeAppBar.dart';
import 'package:shakti/Widgets/AppWidgets/ScreenHeadings.dart';
import 'package:shakti/Widgets/ScreenWidgets/CommunityHomePostcard.dart';
import 'package:shakti/helpers/helper_functions.dart';
import 'package:shakti/Utils/constants/colors.dart';

class CommunityHomeScreen extends StatelessWidget {
  const CommunityHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = THelperFunctions.screenWidth();
    double screenHeight = THelperFunctions.screenHeight();

    /// **Post Data List**
    final List<Map<String, String>> posts = [
      {
        "name": "Meera Patel",
        "field": "Finance",
        "time": "22h",
        "content": '"5 Simple Steps to Start Saving Money Today"\n\n'
            'Saving money doesn’t have to be complicated! Follow these 5 simple steps to take control of your finances and build a secure future.',
        "hashtags": "#PersonalFinance #SavingsTips #FinancialFreedom",
        "imageUrl": "assets/Image1.png",
      },
      {
        "name": "Anuj Kumar",
        "field": "Business",
        "time": "23h",
        "content": '"Support Small Businesses, Make a Big Impact!"\n\n'
            'Every purchase you make helps a dream come true, supports local jobs, and strengthens the economy.\n\n'
            'Let’s grow together!\n- Shop local.\n- Share your experience.\n- Recommend to friends & family.',
        "hashtags": "#SupportSmallBusiness #ShopLocal #CommunityLove",
      },
    ];

    return Scaffold(
      backgroundColor: Scolor.primary,
      body: Column(
        children: [
          /// **Custom Top Bar**
          CustomTopBar1(),

          /// **Reduced Spacing for "Posts" Heading**
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.02), // Less space
            child: ScreenHeadings(text: "Posts"),
          ),

          /// **Posts List**
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight*0), // Less padding
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom:
                            screenWidth * 0.02), // Reduced gap between posts
                    child: PostCard(
                      name: posts[index]["name"]!,
                      field: posts[index]["field"]!,
                      time: posts[index]["time"]!,
                      content: posts[index]["content"]!,
                      hashtags: posts[index]["hashtags"]!,
                      imageUrl: posts[index]["imageUrl"],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
