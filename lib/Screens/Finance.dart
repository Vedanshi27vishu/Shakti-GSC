import 'package:flutter/material.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Utils/constants/sizes.dart';

class Finance extends StatelessWidget {
  const Finance({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading : false,
        backgroundColor: Scolor.primary,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width * 0.05),
            child: SizedBox(
              height: height * 0.04,
              width: height * 0.04,
              child: Image.asset("assets/images/newwallet.png"),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, Entrepreneur!",
                style: TextStyle(
                  fontSize: height * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: height * 0.005),
              Text(
                "Your Business Score is 74/100",
                style: TextStyle(
                  fontSize: height * 0.02,
                  color: Scolor.secondry,
                ),
              ),
              SizedBox(height: height * 0.03),

              /// *Disha AI Assistant Card*
              Container(
                height: height * 0.12,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Scolor.secondry,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Disha AI Assistant",
                              style: TextStyle(
                                color: Scolor.primary,
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: height * 0.005),
                            Text(
                              "Ask me anything about your Business",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: height * 0.018,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.06,
                        width: height * 0.06,
                        child: Image.asset("assets/images/dishablack.png"),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: height * 0.03),

              /// *Suggestions Row*
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SuggestionContainer(
                      image: "assets/images/rupees.png",
                      heading: "Monthly Revenue",
                      suggestion1: "₹25,000",
                      suggestion2: "12% vs Last Month",
                      height: height,
                      width: width,
                    ),
                  ),
                  SizedBox(width: width * 0.04),
                  Expanded(
                    child: SuggestionContainer(
                      image: "assets/images/yellowcommunity.png",
                      heading: "Customers",
                      suggestion1: "148",
                      suggestion2: "8 new this week",
                      height: height,
                      width: width,
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.03),

              /// *Priority Tasks Card*
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Scolor.primary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Scolor.secondry, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Priority Tasks",
                        style: TextStyle(
                          color: Scolor.white,
                          fontSize: height * 0.022,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: height * 0.015),

                      /// *Task 1*
                      TaskRow(
                        icon: "assets/images/mdi_circle-double.png",
                        title: "Complete Business Plan",
                        subtitle: "Due Today",
                        height: height,
                      ),

                      SizedBox(height: height * 0.015),

                      /// *Task 2*
                      TaskRow(
                        icon: "assets/images/mdi_circle-double.png",
                        title: "Review Monthly Goals",
                        subtitle: "2 Items Pending",
                        height: height,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              Container(
                height: height * 0.13,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Scolor.secondry,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Learning Progress",
                        style: TextStyle(
                            fontSize: ESizes.fontSizeSm,
                            color: Scolor.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: height * 0.03,
                              width: width * 0.4,
                              decoration: BoxDecoration(
                                color: Scolor.secondry.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                  child: Text("FINANCIAL PLANNING",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Scolor.white,
                                          fontWeight: FontWeight.w500)))),
                          Text(
                            "74%",
                            style: TextStyle(
                                fontSize: ESizes.fontSizeSm,
                                color: Scolor.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      LinearProgressIndicator(
                        value: 0.74, // 74% progress
                        minHeight: height * 0.008, // Adjust height as needed
                        backgroundColor:
                            Colors.grey.shade700, // Background color
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Scolor.secondry), // Progress color
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// *Suggestion Card Component*
class SuggestionContainer extends StatelessWidget {
  final String image;
  final String heading;
  final String suggestion1;
  final String suggestion2;
  final double height;
  final double width;

  const SuggestionContainer({
    required this.image,
    required this.heading,
    required this.suggestion1,
    required this.suggestion2,
    required this.height,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.4,
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: Scolor.primary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Scolor.secondry, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.04,
            width: height * 0.04,
            child: Image.asset(image),
          ),
          SizedBox(height: height * 0.01),
          Text(
            heading,
            style: TextStyle(
              color: Scolor.secondry,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: height * 0.008),
          Text(
            suggestion1,
            style: TextStyle(
              color: Colors.white,
              fontSize: height * 0.018,
            ),
          ),
          SizedBox(height: height * 0.008),
          Text(
            suggestion2,
            style: TextStyle(
              color: Color(0xFF41836B),
              fontSize: height * 0.016,
            ),
          ),
        ],
      ),
    );
  }
}

/// *Task Row Component*
class TaskRow extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final double height;

  const TaskRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: height * 0.05,
          width: height * 0.05,
          decoration: BoxDecoration(
            color: Scolor.secondry.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
              height: height * 0.02,
              width: height * 0.02,
              child: Image.asset(icon)),
        ),
        SizedBox(width: height * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Scolor.white,
                fontSize: 12,
              ),
            ),
            Text(subtitle,
                style: TextStyle(
                    color: Scolor.secondry, fontSize: height * 0.016)),
          ],
        ),
      ],
    );
  }
}