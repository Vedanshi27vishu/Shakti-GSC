import 'package:flutter/material.dart';
import 'package:shakti/Screens/BottomNavBar.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/CommunityMentorAppBar.dart';
import 'package:shakti/Widgets/AppWidgets/ScreenHeadings.dart';
import 'package:shakti/helpers/helper_functions.dart';

class MentorsScreen extends StatelessWidget {
  const MentorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = THelperFunctions.screenWidth();
    double screenHeight = THelperFunctions.screenHeight();

    final List<Map<String, dynamic>> mentors = [
      {"name": "Priya Singh", "field": "Small Business", "rating": 4.8},
      {"name": "Meera Patel", "field": "Finance", "rating": 4.9},
      {"name": "Aayush Gupta", "field": "Small Business", "rating": 4.5},
      {"name": "Aarti Agarwal", "field": "Small Business", "rating": 4.7},
    ];

    return Scaffold(
      backgroundColor: Scolor.primary,
      appBar: AppBar(
        backgroundColor: Scolor.primary,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Scolor.secondry),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomNavBarExample()));
            }),
      ), // Dark background
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomTopBar2(),
            SizedBox(height: screenHeight * 0.015),
            Center(child: ScreenHeadings(text: "Connect with Mentors")),
            Expanded(
              child: ListView.builder(
                itemCount: mentors.length,
                itemBuilder: (context, index) {
                  final mentor = mentors[index];
                  return MentorCard(
                    name: mentor["name"],
                    field: mentor["field"],
                    rating: mentor["rating"],
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
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

class MentorCard extends StatelessWidget {
  final String name;
  final String field;
  final double rating;
  final double screenWidth;
  final double screenHeight;

  const MentorCard({
    super.key,
    required this.name,
    required this.field,
    required this.rating,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Scolor.primary, // Darker Blue Card
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(color: Scolor.secondry, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Scolor.secondry,
                radius: screenWidth * 0.06,
                child: Icon(Icons.person,
                    color: Colors.black, size: screenWidth * 0.06),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      field,
                      style: TextStyle(
                          fontSize: screenWidth * 0.035, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.emoji_events,
                      color: Scolor.secondry, size: screenWidth * 0.05),
                  SizedBox(width: screenWidth * 0.01),
                  Text(
                    rating.toString(),
                    style: TextStyle(
                        fontSize: screenWidth * 0.04, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Scolor.secondry,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02)),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
              ),
              onPressed: () {},
              icon: Icon(Icons.chat_bubble_outline,
                  color: Colors.black, size: screenWidth * 0.05),
              label: Text(
                "Message",
                style: TextStyle(
                    color: Colors.black, fontSize: screenWidth * 0.045),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
