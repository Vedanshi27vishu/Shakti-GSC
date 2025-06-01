import 'package:flutter/material.dart';
import 'package:shakti/Screens/CommunityHome.dart';
import 'package:shakti/Screens/Mentors.dart';
import 'package:shakti/Screens/followers.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/helpers/helper_functions.dart';

class MeesageBar extends StatelessWidget {
  const MeesageBar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = THelperFunctions.screenHeight();
    return Column(
      children: [
        Container(
          color: Scolor.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommunityHomeScreen()));
                },
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Scolor.secondry,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MentorsScreen()));
                },
                icon: const Icon(Icons.group, color: Colors.black),
                label: const Text(
                  "Meesages",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UsersListScreen()));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
