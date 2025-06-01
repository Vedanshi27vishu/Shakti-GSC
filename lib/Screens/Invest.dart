import 'package:flutter/material.dart';
import 'package:shakti/Screens/InvestScreen.dart';
import 'package:shakti/Screens/InvestmentGroup.dart';
import 'package:shakti/Screens/government.dart';
import 'package:shakti/Screens/tracker.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/helpers/helper_functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Invest extends StatefulWidget {
  @override
  State<Invest> createState() => _InvestState();
}

class _InvestState extends State<Invest> {
  List<dynamic> recommendedLoans = [];
  List<dynamic> privateSchemes = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchRecommendedLoans();
    fetchPrivateSchemes();
  }

  Future<void> fetchRecommendedLoans() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final url = Uri.parse(
        'http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/filter-loans');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          recommendedLoans = data['recommendedLoans'] ?? [];
        });
      } else {
        setState(() {
          error = 'Error fetching loans: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchPrivateSchemes() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final url = Uri.parse(
        'http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/private-schemes');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          privateSchemes = data['recommendedLoans'] ?? [];
        });
      } else {
        setState(() {
          error = 'Error fetching private schemes: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = THelperFunctions.screenHeight();
    double width = THelperFunctions.screenWidth();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
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
                    fontSize: height * 0.04,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GovernmentLoansScreen(
                                loans: recommendedLoans,
                              ),
                            ),
                          );
                        },
                        child: _schemeCard(
                          height,
                          width,
                          "Government Schemes",
                          "assets/images/raphael_piechart.png",
                          true, // isGovernment = true
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GovernmentLoansScreen(
                                loans: privateSchemes,
                              ),
                            ),
                          );
                        },
                        child: _schemeCard(
                          height,
                          width,
                          "Private Schemes",
                          "assets/images/famicons_person-outline.png",
                          false, // isGovernment = false
                        ),
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
                                builder: (context) =>
                                    InvestmentGroupsScreen()));
                      },
                      child: BottomContainer(
                          height: height, width: width, heading: "GROUPS"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrackerApp()));
                      },
                      child: BottomContainer(
                          height: height, width: width, heading: "TRACKER"),
                    )
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
      height: height * 0.22,
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
          SizedBox(height: height * 0.01),
          Text(
            title,
            style: TextStyle(
              fontSize: height * 0.018,
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

  /// *Scheme Card Widget - Updated to show API data for both government and private*
  Widget _schemeCard(double height, double width, String heading, String image,
      bool isGovernment) {
    return Container(
      height: height * 0.22,
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Scolor.secondry,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          // Show loading, error, or loan data based on scheme type
          if (isGovernment) ...[
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Scolor.secondry,
                  strokeWidth: 2,
                ),
              )
            else if (error != null)
              Text(
                "Error loading loans",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              )
            else if (recommendedLoans.isEmpty)
              Text(
                "No loans available",
                style: TextStyle(
                  fontSize: 10,
                  color: Scolor.white,
                  fontWeight: FontWeight.w700,
                ),
              )
            else
              // Show top 3 government loans
              ...recommendedLoans
                  .take(4)
                  .map((loan) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          "• ${loan['name'] ?? 'Unknown Loan'}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Scolor.white,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
          ] else ...[
            // Private schemes section - exactly like government schemes
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Scolor.secondry,
                  strokeWidth: 2,
                ),
              )
            else if (error != null)
              Text(
                "Error loading schemes",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              )
            else if (privateSchemes.isEmpty)
              Text(
                "No schemes available",
                style: TextStyle(
                  fontSize: 12,
                  color: Scolor.white,
                  fontWeight: FontWeight.w700,
                ),
              )
            else
              // Show top 3 private schemes
              ...privateSchemes
                  .take(5)
                  .map((scheme) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          "• ${scheme['name'] ?? 'Unknown Loan'}",
                          style: TextStyle(
                              fontSize: 12,
                              color: Scolor.white,
                              fontWeight: FontWeight.w700),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
          ],
        ],
      ),
    );
  }

  /// *Scheme Row (kept for reference, not used anymore)*
}
