import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shakti/Screens/links.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlowChartScreen extends StatefulWidget {
  const FlowChartScreen({Key? key}) : super(key: key);

  @override
  _FlowChartScreenState createState() => _FlowChartScreenState();
}

class _FlowChartScreenState extends State<FlowChartScreen> {
  List<LoanSuggestion> suggestions = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSuggestions();
  }

  Future<void> fetchSuggestions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print('JWT Token: ${token != null ? "Found" : "Not found"}');
    if (token != null) {
      print(
          'Token starts with: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
    }

    if (token == null || token.isEmpty) {
      setState(() {
        errorMessage = 'Authentication token not found. Please login again.';
        isLoading = false;
      });
      return;
    }

    try {
      print('Making API call to: https://shaktinxt.me/api/flow-chart');

      final response = await http.post(
        Uri.parse('https://shaktinxt.me/api/flow-chart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body length: ${response.body.length}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          print('Parsed data type: ${data.runtimeType}');
          print('Parsed data keys: ${data.keys}');

          if (data['recommendedLoans'] != null &&
              data['recommendedLoans'] is List) {
            final List<dynamic> list = data['recommendedLoans'];
            print('Number of suggestions: ${list.length}');

            if (list.isNotEmpty) {
              print('First suggestion structure: ${list[0]}');

              setState(() {
                suggestions =
                    list.map((json) => LoanSuggestion.fromJson(json)).toList();
                isLoading = false;
              });
            } else {
              setState(() {
                errorMessage = 'No loan suggestions found in the response.';
                isLoading = false;
              });
            }
          } else {
            setState(() {
              errorMessage =
                  'Invalid response format. Expected "recommendedLoans" array.';
              isLoading = false;
            });
          }
        } catch (jsonError) {
          print('JSON parsing error: $jsonError');
          setState(() {
            errorMessage = 'Failed to parse server response: $jsonError';
            isLoading = false;
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Authentication failed. Please login again.';
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          errorMessage = 'API endpoint not found. Please contact support.';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Server error (${response.statusCode}): ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Network error: $e');
      setState(() {
        errorMessage =
            'Network error: Please check your internet connection.\n\nDetails: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void showDetailDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[100],
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Text(description),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Scolor.secondry, // background
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Scolor.primary, // text color
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildFlowNode(LoanSuggestion suggestion, bool isLast, int index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () =>
              showDetailDialog(suggestion.suggestion, suggestion.description),
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.yellow[400]!, Colors.yellow[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Scolor.primary,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Scolor.darkcontainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    suggestion.suggestion,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Scolor.textprimary,
                    ),
                  ),
                ),
                const Icon(Icons.info_outline, color: Colors.white),
              ],
            ),
          ),
        ),
        if (!isLast)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const Icon(
              Icons.arrow_downward,
              size: 32,
              color: Scolor.secondry,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business Flow Chart"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.link, color: Scolor.secondry),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FinancialLinkInsights(),
                ),
              );
            }, // ← You missed this closing brace
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchSuggestions,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading loan suggestions...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: fetchSuggestions,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (suggestions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No loan suggestions available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return buildFlowNode(
          suggestions[index],
          index == suggestions.length - 1,
          index,
        );
      },
    );
  }
}

class LoanSuggestion {
  final String suggestion;
  final String description;

  LoanSuggestion({required this.suggestion, required this.description});

  factory LoanSuggestion.fromJson(Map<String, dynamic> json) {
    return LoanSuggestion(
      suggestion: json['Suggestion'] ?? 'No suggestion available',
      description: json['description'] ?? 'No description available',
    );
  }
}
