import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/ScreenHeadings.dart';
import 'package:shakti/Widgets/AppWidgets/YellowLine.dart';
import 'package:shakti/helpers/helper_functions.dart';

class FinancialRecordsScreen extends StatefulWidget {
  const FinancialRecordsScreen({super.key});

  @override
  State<FinancialRecordsScreen> createState() => _FinancialRecordsScreenState();
}

class _FinancialRecordsScreenState extends State<FinancialRecordsScreen> {
  late Future<List<PdfInsight>> _insightsFuture;

  @override
  void initState() {
    super.initState();
    _insightsFuture = fetchLinks();
  }

  Future<List<PdfInsight>> fetchLinks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
          'http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/pdfsearch'),
      headers: {'Authorization': 'Bearer ${token ?? ''}'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((item) => PdfInsight.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load insights');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = THelperFunctions.screenWidth();
    double screenHeight = THelperFunctions.screenHeight();

    return Scaffold(
      backgroundColor: Scolor.primary,
      appBar: AppBar(
        backgroundColor: Scolor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Scolor.secondry),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenHeadings(text: "Financial Documents -"),
            SizedBox(height: screenHeight * 0.01),
            Yellowline(screenWidth: screenWidth),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: FutureBuilder<List<PdfInsight>>(
                future: _insightsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            CircularProgressIndicator(color: Scolor.secondry));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No records found',
                          style: TextStyle(color: Colors.white)),
                    );
                  }

                  final insights = snapshot.data!;
                  return ListView.builder(
                    itemCount: insights.length,
                    itemBuilder: (context, index) {
                      final doc = insights[index];
                      return Card(
                        color: Scolor.primary,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Scolor.secondry, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.insert_drive_file,
                              color: Scolor.secondry, size: 30),
                          title: Text(
                            doc.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                doc.snippet,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.open_in_new,
                                color: Colors.white),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Link: ${doc.link}'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // You can open the link using url_launcher if needed
                              // launchUrl(Uri.parse(doc.link));
                            },
                          ),
                        ),
                      );
                    },
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

class PdfInsight {
  final String title;
  final String link;
  final String snippet;

  PdfInsight({
    required this.title,
    required this.link,
    required this.snippet,
  });

  factory PdfInsight.fromJson(Map<String, dynamic> json) {
    return PdfInsight(
      title: json['title'] ?? '',
      snippet: json['snippet'] ?? '',
      link: json['link'] ?? '',
    );
  }
}
