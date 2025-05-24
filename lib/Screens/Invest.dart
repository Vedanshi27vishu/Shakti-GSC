import 'package:flutter/material.dart';
import 'package:shakti/Screens/InvestScreen.dart';
import 'package:shakti/Screens/InvestmentGroup.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/helpers/helper_functions.dart';

class Invest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = THelperFunctions.screenHeight();
    double width = THelperFunctions.screenWidth(); // Fixed issue

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, // Dynamic padding
          vertical: height * 0.02,
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, Entrepreneur!",
                  style: TextStyle(
                    fontSize: height * 0.04, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Scolor.white,
                  ),
                ),
                SizedBox(height: height * 0.05),

                // Info Cards
                Row(
                  children: [
                    Expanded(
                        child: _infoCard(
                            "Total Outstanding Loans",
                            "₹25,000",
                            "Across 2 active loans",
                            height,
                            "assets/images/rupeesyellow.png")),
                    SizedBox(width: width * 0.02),
                    Expanded(
                        child: _infoCard(
                            "Monthly Revenue",
                            "₹7,500",
                            "Due Every Month",
                            height,
                            "assets/images/Vector-1.png")),
                    SizedBox(width: width * 0.02),
                    Expanded(
                        child: _infoCard(
                            "Available Credit",
                            "₹25,000",
                            "Additional Capacity",
                            height,
                            "assets/images/arrow (1).png")),
                  ],
                ),

                SizedBox(height: height * 0.05),

                // Active Loans
                Text(
                  "Active Loans",
                  style: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w600,
                    color: Scolor.white,
                  ),
                ),
                SizedBox(height: height * 0.05),
                _loanTable(),

                SizedBox(height: height * 0.05),

                // Loan Scheme Scrollable Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _schemeCard(
                        height,
                        width,
                        "Government Schemes",
                        "assets/images/raphael_piechart.png",
                      ),
                      SizedBox(width: width * 0.02),
                      _schemeCard(
                        height,
                        width,
                        "Private Schemes",
                        "assets/images/famicons_person-outline.png",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvestmentScreen()));
                      },
                      child: BottomContainer(
                          height: height, width: width, heading: "INVEST"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvestmentGroupsScreen ()));
                      },
                      child: BottomContainer(
                          height: height, width: width, heading: "GROUPS"),
                    ),
                    BottomContainer(
                        height: height, width: width, heading: "TRACKER")
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// *Info Card Widget (Ensures Equal Height & Responsive)*
  Widget _infoCard(String title, String amount, String subtitle, double height,
      String image) {
    return Container(
      height: height * 0.22, // Responsive height
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Scolor.secondry),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height * 0.03,
            width: height * 0.03,
            child: Image.asset(image),
          ),
          SizedBox(height: height * 0.01), // Added spacing
          Text(
            title,
            style: TextStyle(
              fontSize: height * 0.018, // Responsive text size
              fontWeight: FontWeight.bold,
              color: Scolor.secondry,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: height * 0.005),
          Text(
            amount,
            style: TextStyle(
              fontSize: height * 0.020,
              fontWeight: FontWeight.bold,
              color: Scolor.white,
            ),
            maxLines: 1,
          ),
          SizedBox(height: height * 0.005),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: height * 0.016,
              color: Color(0xFF41836B),
            ),
          ),
        ],
      ),
    );
  }

  /// *Active Loans Table*
  Widget _loanTable() {
    return Column(children: [
      Container(
        color: Scolor.secondry,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tableHeader("Lender"),
            _tableHeader("Amount"),
            _tableHeader("Remaining"),
          ],
        ),
      ),
      _loanRow("State Bank of India", "₹50,000", "₹35,000"),
      _loanRow("Central Bank of India", "₹25,000", "₹20,000"),
    ]);
  }

  /// *Table Header*
  Widget _tableHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Scolor.primary,
      ),
    );
  }

  /// *Loan Row*
  Widget _loanRow(String lender, String amount, String remaining) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              lender,
              style: TextStyle(fontSize: 12, color: Scolor.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              amount,
              style: TextStyle(fontSize: 12, color: Scolor.white),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              remaining,
              style: TextStyle(fontSize: 12, color: Scolor.white),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  /// *Scheme Card Widget (Reused for Consistency)*
  Widget _schemeCard(
      double height, double width, String heading, String image) {
    return Container(
      height: height * 0.18,
      width: width * 0.55,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Scolor.secondry),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  height: height * 0.03,
                  width: height * 0.03,
                  color: Colors.transparent,
                  child: Image.asset(image)),
              Text(
                heading,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Scolor.secondry,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          _schemeRow("PMEGP Scheme", "Upto ₹25L"),
          SizedBox(height: 3),
          _schemeRow("MUDRA Loan", "Upto ₹10L"),
          SizedBox(height: 3),
          _schemeRow("Stand Up India", "Upto ₹1Cr"),
        ],
      ),
    );
  }

  /// *Scheme Row*
  Widget _schemeRow(String scheme, String amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            scheme,
            style: TextStyle(fontSize: 12, color: Scolor.white),
            textAlign: TextAlign.center,
          ),
          Text(
            amount,
            style: TextStyle(fontSize: 12, color: Color(0xFF41836B)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  String heading;
  BottomContainer(
      {super.key,
      required this.height,
      required this.width,
      required this.heading});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.03,
      width: width * 0.25,
      decoration: BoxDecoration(
        color: Scolor.secondry.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          heading,
          style: TextStyle(color: Scolor.secondry, fontSize: 10),
        ),
      ),
    );
  }
}
