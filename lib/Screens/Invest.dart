import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shakti/Screens/InvestScreen.dart';
import 'package:shakti/Screens/InvestmentGroup.dart';
import 'package:shakti/Screens/government.dart';
import 'package:shakti/Screens/tracker.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Invest extends StatefulWidget {
  const Invest({super.key});
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

  Future<void> _loadData() async {
    await Future.wait([
      fetchRecommendedLoans(),
      fetchPrivateSchemes(),
      fetchUserLoans(),
    ]);
    if (!mounted) return;
    setState(() {});
  }

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
    if (!mounted) return;
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No authentication token found');
      final url = Uri.parse('http://65.2.82.85:5000/filter-loans');
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          recommendedLoans = data['recommendedLoans'] ?? [];
        });
      } else {
        throw Exception('Failed to fetch loans: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Error fetching recommended loans: $e';
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> fetchPrivateSchemes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No authentication token found');
      final url = Uri.parse('http://65.2.82.85:5000/private-schemes');
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          privateSchemes = data['recommendedLoans'] ?? [];
        });
      } else {
        throw Exception(
            'Failed to fetch private schemes: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Error fetching private schemes: $e';
      });
    }
  }

  Future<void> fetchUserLoans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No authentication token found');
      final url = Uri.parse('http://65.2.82.85:5000/api/financial/loans');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          userLoans = data['loans'] ?? [];
          totalRemainingLoanAmount =
              (data['totalRemainingAmount'] ?? 0).toDouble();
          investmentAmount = (data['investmentAmount'] ?? 0).toDouble();
          totalInstallment = (data['totalinstallment'] ?? 0).toDouble();
        });
      } else {
        throw Exception('Failed to fetch user loans: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Error fetching user loans: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double maxContentWidth;
    if (screenWidth < 600) {
      maxContentWidth = double.infinity; // Mobile: full width
    } else if (screenWidth < 1000) {
      maxContentWidth = 600; // Tablet
    } else {
      maxContentWidth = 700; // Laptop/Desktop
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Scolor.primary,
        elevation: 0,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Hi, Entrepreneur!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 22),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => TrackerScreen())),
              child: SizedBox(
                height: 28,
                width: 28,
                child: Image.asset("assets/images/newwallet.png"),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
              width: maxContentWidth,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildContent(screenWidth, screenHeight, maxContentWidth),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      double screenWidth, double screenHeight, double maxWidth) {
    double cardWidth;
    if (screenWidth < 600) {
      cardWidth = screenWidth * 0.48;
    } else if (screenWidth < 1000) {
      cardWidth = 280;
    } else {
      cardWidth = 300;
    }
    double cardHeight = 114;

    double tableWidth;
    if (screenWidth < 600) {
      tableWidth = screenWidth * 0.9;
    } else if (screenWidth < 1000) {
      tableWidth = 600;
    } else {
      tableWidth = 700;
    }
    double tableHeight;
    if (screenWidth < 600) {
      tableHeight = screenHeight * 0.3;
    } else {
      tableHeight = 200;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _infoCard(
                  "Total Loans",
                  "₹${_formatCurrency(totalRemainingLoanAmount)}",
                  "${userLoans.length} active loans",
                  cardHeight,
                  cardWidth,
                  "assets/images/rupeesyellow.png"),
              const SizedBox(width: 10),
              _infoCard(
                  "Monthly Payment",
                  "₹${_formatCurrency(totalInstallment)}",
                  "Due Every Month",
                  cardHeight,
                  cardWidth,
                  "assets/images/Vector-1.png"),
              const SizedBox(width: 10),
              _infoCard(
                  "Investment",
                  "₹${_formatCurrency(investmentAmount)}",
                  "Available Funds",
                  cardHeight,
                  cardWidth,
                  "assets/images/arrow (1).png"),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Active Loans",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: tableHeight,
          width: tableWidth,
          child: _loanTable(),
        ),
        
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _schemeCard(cardHeight, cardWidth, "Government Schemes",
                  "assets/images/raphael_piechart.png", true),
              const SizedBox(width: 10),
              _schemeCard(cardHeight, cardWidth, "Private Schemes",
                  "assets/images/famicons_person-outline.png", false),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Invest())),
                child: BottomContainer(width: cardWidth * 0.6, height: 45, heading: "INVEST"),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const InvestmentGroupsScreen())),
                child: BottomContainer(width: cardWidth * 0.6, height: 45, heading: "GROUPS"),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const TrackerScreen())),
                child: BottomContainer(width: cardWidth * 0.6, height: 45, heading: "TRACKER"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoCard(
    String title,
    String amount,
    String subtitle,
    double height,
    double width,
    String image,
  ) {
    return Container(
      height: height * 0.9,
      width: width * 0.58,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Scolor.secondry),
        borderRadius: BorderRadius.circular(7),
        color: Scolor.primary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(image, height: height * 0.2, width: height * 0.15),
              const SizedBox(width: 5),
              Expanded(
                  child: Text(title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Scolor.secondry,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF41836B),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _schemeCard(
      double height, double width, String heading, String image, bool isGovernment) {
    final schemes = isGovernment ? recommendedLoans : privateSchemes;
    return Container(
      height: height * 1.2,
      width: width * 0.9,
      padding: const EdgeInsets.all(7),
      margin: const EdgeInsets.only(bottom: 6, right: 7),
      decoration: BoxDecoration(
        border: Border.all(color: Scolor.secondry),
        borderRadius: BorderRadius.circular(8),
        color: Scolor.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(image, height: height * 0.19, width: height * 0.17),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  heading,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Scolor.secondry,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: schemes.isEmpty
                ? Center(
                    child: Text(
                      isGovernment
                          ? "No Government Schemes."
                          : "No Private Schemes.",
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: schemes.take(4).map<Widget>((scheme) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 2),
                        child: Text(
                          "• ${scheme['name'] ?? (isGovernment ? "Government Scheme" : "Private Scheme")}",
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _loanTable() {
    return LayoutBuilder(builder: (context, constraints) {
      double tableheight = MediaQuery.of(context).size.height < 600
          ? MediaQuery.of(context).size.height * 0.4
          : 600;
      double tableWidth = MediaQuery.of(context).size.width < 600
          ? MediaQuery.of(context).size.width * 1.2
          : 600;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: tableWidth,
          height: tableheight,
          child: Column(
            children: [
              Container(
                color: Scolor.secondry,
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                child: Row(
                  children: [
                    _tableHeader("Lender"),
                    _tableHeader("Type"),
                    _tableHeader("Total"),
                    _tableHeader("Remaining"),
                    _tableHeader("Monthly"),
                  ],
                ),
              ),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                      child: CircularProgressIndicator(color: Scolor.secondry)),
                )
              else if (error != null)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (userLoans.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "No active loans found",
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...userLoans.map((loan) => _loanRow(
                      loan['Lender_Name'] ?? 'Unknown',
                      loan['Loan_Type'] ?? 'Unknown',
                      "₹${_formatCurrency((loan['Total_Loan_Amount'] ?? 0).toDouble())}",
                      "₹${_formatCurrency((loan['Remaining_Loan_Amount'] ?? 0).toDouble())}",
                      "₹${_formatCurrency((loan['Monthly_Payment'] ?? 0).toDouble())}",
                    )),
            ],
          ),
        ),
      );
    });
  }

  Widget _tableHeader(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _loanRow(String lender, String loanType, String totalAmount,
      String remaining, String monthly) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white24, width: 0.5))),
      child: Row(
        children: [
          Expanded(
            child: Text(
              lender,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              loanType,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              totalAmount,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.amber,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              remaining,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              monthly,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  final double width;
  final double height;
  final String heading;
  const BottomContainer(
      {required this.width,
      required this.height,
      required this.heading,
      super.key});
  @override
  Widget build(BuildContext context) {
    final fontSize = width * 0.038 > 13 ? 13 : width * 0.038;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Scolor.secondry),
        borderRadius: BorderRadius.circular(8),
        color: Scolor.primary,
      ),
      child: Center(
        child: Text(
          heading,
          style: TextStyle(
           // fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
