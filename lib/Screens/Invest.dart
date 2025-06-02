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
  List<dynamic> userLoans = [];
  double totalRemainingLoanAmount = 0;
  double investmentAmount = 0;
  double totalInstallment = 0;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Combined method to load all data
  Future<void> _loadData() async {
    await Future.wait([
      fetchRecommendedLoans(),
      fetchPrivateSchemes(),
      fetchUserLoans(),
    ]);
  }

  // Helper method to format currency with comma separation
  String _formatCurrency(double amount) {
    String amountStr = amount.toInt().toString();

    if (amountStr.length > 3) {
      String result = '';
      int count = 0;

      for (int i = amountStr.length - 1; i >= 0; i--) {
        if (count == 3 || (count > 3 && (count - 3) % 2 == 0)) {
          result = ',$result';
        }
        result = '${amountStr[i]}$result';
        count++;
      }
      return result;
    }
    return amountStr;
  }

  Future<void> fetchRecommendedLoans() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse(
          'http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/filter-loans');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          recommendedLoans = data['recommendedLoans'] ?? [];
        });
      } else {
        throw Exception('Failed to fetch loans: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching recommended loans: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchPrivateSchemes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse(
          'http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/private-schemes');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          privateSchemes = data['recommendedLoans'] ?? [];
        });
      } else {
        throw Exception(
            'Failed to fetch private schemes: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching private schemes: $e';
      });
    }
  }

  Future<void> fetchUserLoans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse(
          'http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/api/financial/loans');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userLoans = data['loans'] ?? [];
          totalRemainingLoanAmount =
              (data['totalRemainingLoanAmount'] ?? 0).toDouble();
          investmentAmount = (data['investmentAmount'] ?? 0).toDouble();
          totalInstallment = (data['totalinstallment'] ?? 0).toDouble();
        });
      } else {
        throw Exception('Failed to fetch user loans: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching user loans: $e';
      });
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
                        "₹${_formatCurrency(totalRemainingLoanAmount)}",
                        "Across ${userLoans.length} active loans",
                        height,
                        "assets/images/rupeesyellow.png",
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Expanded(
                      child: _infoCard(
                        "Monthly Payment",
                        "₹${_formatCurrency(totalInstallment)}",
                        "Due Every Month",
                        height,
                        "assets/images/Vector-1.png",
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Expanded(
                      child: _infoCard(
                        "Investment Amount",
                        "₹${_formatCurrency(investmentAmount)}",
                        "Available Funds",
                        height,
                        "assets/images/arrow (1).png",
                      ),
                    ),
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
                SizedBox(height: height * 0.02),
                _loanTable(),

                SizedBox(height: height * 0.05),

                // Loan Scheme Scrollable Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
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
                          true,
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
                          false,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.05),

                // Bottom Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvestmentScreen(),
                          ),
                        );
                      },
                      child: BottomContainer(
                        height: height,
                        width: width,
                        heading: "INVEST",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvestmentGroupsScreen(),
                          ),
                        );
                      },
                      child: BottomContainer(
                        height: height,
                        width: width,
                        heading: "GROUPS",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrackerApp(),
                          ),
                        );
                      },
                      child: BottomContainer(
                        height: height,
                        width: width,
                        heading: "TRACKER",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String amount, String subtitle, double height,
      String image) {
    return Container(
      height: height * 0.22,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Scolor.secondry),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
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
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: height * 0.005),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: height * 0.016,
              color: const Color(0xFF41836B),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _loanTable() {
    return Column(
      children: [
        Container(
          color: Scolor.secondry,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            children: [
              _tableHeader("Lender"),
              _tableHeader("Type"),
              _tableHeader("Remaining"),
              _tableHeader("Monthly"),
            ],
          ),
        ),
        if (isLoading)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(
                color: Scolor.secondry,
              ),
            ),
          )
        else if (error != null)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              error!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else if (userLoans.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "No active loans found",
              style: TextStyle(
                color: Scolor.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          ...userLoans.map((loan) => _loanRow(
                loan['Lender_Name']?.toString() ?? 'Unknown Lender',
                loan['Loan_Type']?.toString() ?? 'Unknown Type',
                "₹${_formatCurrency((loan['Remaining_Loan_Amount'] ?? 0).toDouble())}",
                "₹${_formatCurrency((loan['Monthly_Payment'] ?? 0).toDouble())}",
              )),
      ],
    );
  }

  Widget _tableHeader(String text) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Scolor.primary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _loanRow(
      String lender, String loanType, String remaining, String monthly) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              lender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Scolor.white,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              loanType,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Scolor.white,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              remaining,
              style: TextStyle(
                fontSize: 12,
                color: Scolor.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              monthly,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Scolor.white,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _schemeCard(double height, double width, String heading, String image,
      bool isGovernment) {
    final schemes = isGovernment ? recommendedLoans : privateSchemes;

    return Container(
      height: height * 0.22,
      width: width * 0.55,
      padding: const EdgeInsets.all(8),
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
              SizedBox(
                height: height * 0.03,
                width: height * 0.03,
                child: Image.asset(image),
              ),
              Flexible(
                child: Text(
                  heading,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Scolor.secondry,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: Scolor.secondry,
                        strokeWidth: 2,
                      ),
                    )
                  else if (error != null)
                    Text(
                      "Error loading ${isGovernment ? 'loans' : 'schemes'}",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  else if (schemes.isEmpty)
                    Text(
                      "No ${isGovernment ? 'loans' : 'schemes'} available",
                      style: TextStyle(
                        fontSize: 10,
                        color: Scolor.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  else
                    ...schemes.take(4).map((scheme) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            "• ${scheme['name']?.toString() ?? 'Unknown ${isGovernment ? 'Loan' : 'Scheme'}'}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Scolor.white,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Assuming BottomContainer is defined elsewhere, here's a basic implementation
class BottomContainer extends StatelessWidget {
  final double height;
  final double width;
  final String heading;

  const BottomContainer({
    Key? key,
    required this.height,
    required this.width,
    required this.heading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.06,
      width: width * 0.25,
      decoration: BoxDecoration(
        border: Border.all(color: Scolor.secondry),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          heading,
          style: TextStyle(
            color: Scolor.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
