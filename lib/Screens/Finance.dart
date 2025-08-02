import 'package:flutter/material.dart';
import 'package:shakti/Screens/BusinessTracker.dart';
import 'package:shakti/Screens/taskcreate.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Utils/constants/sizes.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Finance extends StatefulWidget {
  const Finance({super.key});

  @override
  State<Finance> createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  List<dynamic> tasks = [];
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  Map<String, dynamic>? profitData;
  bool isProfitLoading = false;
  String? profitError;

  @override
  void initState() {
    super.initState();
    // Add error handling for init methods
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await fetchTasks(selectedDate);
      await fetchProfitPrediction();
    } catch (e) {
      print('Initialization error: $e');
      // Handle initialization errors gracefully
      if (mounted) {
        setState(() {
          isLoading = false;
          isProfitLoading = false;
        });
      }
    }
  }

  Future<void> fetchTasks(DateTime date) async {
    if (!mounted) return;
    
    setState(() => isLoading = true);
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final url = Uri.parse('http://13.233.25.114:5000/tasks/filter?date=$formattedDate');

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10)); // Add timeout

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            tasks = data['tasks'] ?? []; // Handle null case
          });
        }
      } else {
        print('Error fetching tasks: ${response.statusCode} - ${response.body}');
        if (mounted) {
          setState(() {
            tasks = []; // Set empty list on error
          });
        }
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          tasks = []; // Set empty list on error
        });
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> fetchProfitPrediction() async {
    if (!mounted) return;
    
    setState(() {
      isProfitLoading = true;
      profitError = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse('http://13.233.25.114:5000/predict-profit');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10)); // Add timeout

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            profitData = data;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            profitError = 'Error fetching profit prediction: ${response.statusCode}';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          profitError = 'Error: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() => isProfitLoading = false);
      }
    }
  }

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate && mounted) {
      setState(() {
        selectedDate = picked;
      });
      fetchTasks(picked);
    }
  }

  // Helper method to format the predicted profit amount
  String getFormattedAmount() {
    try {
      if (profitData != null && profitData!['curr'] != null) {
        // Handle both int and double types
        dynamic amount = profitData!['curr'];
        int amountInt = amount is int ? amount : (amount as double).round();
        return '₹ ${NumberFormat('#,##,###').format(amountInt)}';
      }
    } catch (e) {
      print('Error formatting amount: $e');
    }
    return '₹ 1,50,000'; // Default fallback
  }

  // Helper method to get percentage change with sign
  String getPercentageChange() {
    try {
      if (profitData != null && profitData!['percentageChange'] != null) {
        String percentage = profitData!['percentageChange'].toString();
        // Remove the negative sign and add appropriate prefix
        percentage = percentage.replaceAll('-', '');
        return '$percentage% vs Last Month';
      }
    } catch (e) {
      print('Error formatting percentage: $e');
    }
    return '0% vs Last Month'; // Default fallback
  }

  @override
  Widget build(BuildContext context) {
    // Add null check for MediaQuery
    final mediaQuery = MediaQuery.of(context);
    if (mediaQuery.size.width == 0 || mediaQuery.size.height == 0) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // ===========================
      // RESPONSIVE APPBAR WITH BREAKPOINTS
      // ===========================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenHeight = mediaQuery.size.height;

            double titleFontSize, iconSize, horizontalPad;

            if (screenWidth < 600) {
              titleFontSize = screenHeight * 0.033;
              iconSize = 26;
              horizontalPad = 0;
            } else if (screenWidth < 1000) {
              titleFontSize = 22;
              iconSize = 30;
              horizontalPad = 10;
            } else {
              titleFontSize = 26;
              iconSize = 36;
              horizontalPad = 30;
            }

            return AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Scolor.primary,
              elevation: 0,
              titleSpacing: 0,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                child: Text(
                  "   Hi, Entrepreneur!",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: horizontalPad + 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComparativeTrackerScreen(),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: iconSize,
                      width: iconSize,
                      child: Image.asset(
                        "assets/images/newwallet.png",
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.wallet, size: iconSize, color: Colors.white);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      // ===========================
      // RESPONSIVE BODY WITH CENTERING AND MAX WIDTH
      // ===========================
      body: Container(
        color: Scolor.primary, // Add background color
        child: Center(
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                double screenHeight = mediaQuery.size.height;

                // Responsive max width for the content container
                double maxContentWidth;
                if (screenWidth < 600) {
                  maxContentWidth = double.infinity; // Full width for phones
                } else if (screenWidth < 1000) {
                  maxContentWidth = 600; // Tablet max width
                } else {
                  maxContentWidth = 700; // Desktop max width
                }

                // Responsive paddings and font sizes
                double greetingFontSize, scoreFontSize, sectionPadding;
                if (screenWidth < 600) {
                  greetingFontSize = screenHeight * 0.032;
                  scoreFontSize = screenHeight * 0.02;
                  sectionPadding = 0;
                } else if (screenWidth < 1000) {
                  greetingFontSize = 24;
                  scoreFontSize = 15;
                  sectionPadding = 5;
                } else {
                  greetingFontSize = 28;
                  scoreFontSize = 17;
                  sectionPadding = 10;
                }

                // Suggestion container responsive width
                double suggestionWidth;
                if (screenWidth < 600) {
                  suggestionWidth = (screenWidth - 48) / 2; // Account for padding
                } else if (screenWidth < 1000) {
                  suggestionWidth = 280; // Fixed width for tablet
                } else {
                  suggestionWidth = 300; // Slightly larger for desktop
                }

                return Container(
                  width: maxContentWidth,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Section
                      Padding(
                        padding: EdgeInsets.only(top: sectionPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   "Hi, Entrepreneur!",
                            //   style: TextStyle(
                            //     fontSize: greetingFontSize,
                            //     fontWeight: FontWeight.w600,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            //SizedBox(height: sectionPadding),
                            Text(
                              "Your Business Score is 74/100",
                              style: TextStyle(
                                fontSize: scoreFontSize,
                                color: Scolor.secondry,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                          ],
                        ),
                      ),

                      // Disha AI Assistant Card
                      Container(
                        height: screenHeight * 0.12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Scolor.secondry,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.015,
                          ),
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
                                        fontSize: greetingFontSize * 0.6,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      "Ask me anything about your Business",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: greetingFontSize * 0.55,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.06,
                                width: screenHeight * 0.06,
                                child: Image.asset(
                                  "assets/images/dishablack.png",
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.smart_toy, 
                                        size: screenHeight * 0.06, 
                                        color: Scolor.primary);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Suggestions Row (Monthly Revenue & Customers)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: SuggestionContainer(
                              image: "assets/images/rupees.png",
                              heading: "Monthly Revenue",
                              suggestion1: getFormattedAmount(),
                              suggestion2: getPercentageChange(),
                              height: screenHeight,
                              width: suggestionWidth,
                            ),
                          ),
                          SizedBox(width: 16),
                          Flexible(
                            child: SuggestionContainer(
                              image: "assets/images/yellowcommunity.png",
                              heading: "Customers",
                              suggestion1: "148",
                              suggestion2: "8 new this week",
                              height: screenHeight,
                              width: suggestionWidth,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Priority Tasks Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Scolor.primary,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Scolor.secondry, width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and Date Picker
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Today's Priority Tasks",
                                      style: TextStyle(
                                        color: Scolor.white,
                                        fontSize: scoreFontSize,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.calendar_today,
                                          size: scoreFontSize + 6,
                                          color: Scolor.secondry,
                                        ),
                                        onPressed: () => _pickDate(context),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TaskCreateScreen()),
                                          );
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.yellow.shade700,
                                          size: scoreFontSize + 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.015),

                              // Task list / loading UI
                              if (isLoading)
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Scolor.secondry,
                                  ),
                                )
                              else if (tasks.isEmpty)
                                Text(
                                  "No tasks for this date.",
                                  style: TextStyle(
                                    color: Scolor.secondry,
                                    fontSize: scoreFontSize,
                                  ),
                                )
                              else
                                ...tasks.map((task) => Padding(
                                  padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                                  child: TaskRow(
                                    icon: "assets/images/mdi_circle-double.png",
                                    title: task['title']?.toString() ?? 'Untitled',
                                    subtitle: task['description']?.toString() ?? 'No description',
                                    height: screenHeight,
                                  ),
                                )).toList(),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Learning Progress Card
                      Container(
                        height: screenHeight * 0.13,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Scolor.secondry),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ComparativeTrackerScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Learning Progress",
                                  style: TextStyle(
                                    fontSize: ESizes.fontSizeSm,
                                    color: Scolor.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: screenHeight * 0.03,
                                      decoration: BoxDecoration(
                                        color: Scolor.secondry.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "FINANCIAL PLANNING",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Scolor.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "74%",
                                    style: TextStyle(
                                      fontSize: ESizes.fontSizeSm,
                                      color: Scolor.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              LinearProgressIndicator(
                                value: 0.74,
                                minHeight: screenHeight * 0.008,
                                backgroundColor: Colors.grey.shade700,
                                valueColor: AlwaysStoppedAnimation<Color>(Scolor.secondry),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Suggestion Container now takes responsive width
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
      width: width,
      padding: EdgeInsets.all(12),
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
            child: Image.asset(
              image,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: height * 0.04, color: Colors.white);
              },
            ),
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
              color: const Color(0xFF41836B),
              fontSize: height * 0.016,
            ),
          ),
        ],
      ),
    );
  }
}

/// TaskRow remains mostly the same but font sizes scalable
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
          child: Image.asset(
            icon,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.task, size: height * 0.03, color: Colors.white);
            },
          ),
        ),
        SizedBox(width: height * 0.02),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Scolor.white,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Scolor.secondry,
                  fontSize: height * 0.016,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}