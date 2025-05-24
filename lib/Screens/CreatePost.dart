import 'package:flutter/material.dart';
import 'package:shakti/Screens/BottomNavBar.dart';
import 'package:shakti/Screens/CommunityHome.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/CommunityPostAppBar.dart';
import 'package:shakti/Widgets/AppWidgets/ScreenHeadings.dart';
import 'package:shakti/Widgets/AppWidgets/YellowLine.dart';
import 'package:shakti/helpers/helper_functions.dart';


class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
       double screenWidth = THelperFunctions.screenWidth();
    double screenHeight = THelperFunctions.screenHeight();
    return Scaffold(
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
          }
        ),
      ),
     body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Container(color: Colors.red,height: 10,width: 10,),
               CustomTopBar3(),
                  SizedBox(height: screenHeight * 0.015),
              Center(
                child: ScreenHeadings(text: "Create New Post")
              ),
              SizedBox(height: screenHeight * 0.005),
              const Text(
                "Add the main post details here. They'll be connected to the layout and take on the layout design.",
                style: TextStyle(color: Colors.grey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),
              const Text(
                "Post Title",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
             TextField(
  maxLength: 200,
  style: const TextStyle(color: Colors.white),
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white10,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Scolor.secondry, width: 2), // Default border
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Scolor.secondry, width: 2), // Yellow border when not focused
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.amber, width: 3), // Thicker yellow border when focused
    ),
    counterStyle: const TextStyle(color: Colors.white70),
  ),
),
              SizedBox(height: screenHeight * 0.01),
              const Text(
                "Post author",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              TextField(
                controller: TextEditingController(text: "Meera Patel"),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                   enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Scolor.secondry, width: 2), // Yellow border when not focused
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.amber, width: 3), // Thicker yellow border when focused
    ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Container(
                  width: screenWidth * 0.3,
                  height: screenWidth * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo,
                        color: Colors.white, size: 40),
                    onPressed: () {},
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Yellowline(screenWidth: screenWidth),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Scolor.secondry
                      ,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Start Your Journey",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.amber),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Learn More",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Yellowline(screenWidth: screenWidth),
              SizedBox(height: screenHeight * 0.03),
              const Text(
                "Previous Posts",
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.015),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.06,
                      backgroundColor: Colors.amber,
                      child: Text(
                        "M",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Meera Patel",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Finance",
                            style: TextStyle(color: Colors.amber, fontSize: 13),
                          ),
                          const Text(
                            "22h - @",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          const Text(
                            "\"5 Simple Steps to Start Saving Money Today\"",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

