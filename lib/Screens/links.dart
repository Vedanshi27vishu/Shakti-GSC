import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/Widgets/AppWidgets/ScreenHeadings.dart'
    show ScreenHeadings;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FinancialLinkInsights extends StatefulWidget {
  const FinancialLinkInsights({super.key});

  @override
  State<FinancialLinkInsights> createState() => _FinancialInsightsScreenState();
}

class _FinancialInsightsScreenState extends State<FinancialLinkInsights> {
  late Future<List<LinkInsight>> _insightsFuture;

  @override
  void initState() {
    super.initState();
    _insightsFuture = fetchLinks();
  }

  Future<List<LinkInsight>> fetchLinks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
          'http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/search'),
      headers: {'Authorization': 'Bearer ${token ?? ''}'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> results = jsonData['results'];
      final String businessSector = jsonData['businessSector'] ?? 'Finance';

      return results
          .map((item) => LinkInsight.fromJson(item, businessSector))
          .toList();
    } else {
      throw Exception('Failed to load insights');
    }
  }

  void _launchUrl(String url) async {
    if (!url.startsWith('http')) url = 'https://$url';
    final uri = Uri.parse(url);

    try {
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // Fallback to in-app browser view
        launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      }

      if (!launched) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open the link: $url'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Scolor.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Scolor.secondry),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Scolor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<LinkInsight>>(
          future: _insightsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No insights available.'));
            }

            final insights = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScreenHeadings(
                    text: "Experts insights for financial business-"),
                const Divider(color: Colors.amber),
                Expanded(
                  child: ListView.builder(
                    itemCount: insights.length,
                    itemBuilder: (context, index) {
                      final item = insights[index];
                      return GestureDetector(
                        onTap: () => _launchUrl(item.link),
                        child: Card(
                          color: Scolor.primary,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.amber),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.link,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.amberAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.snippet,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LinkInsight {
  final String title;
  final String link;
  final String snippet;
  final String businessSector;

  LinkInsight({
    required this.title,
    required this.link,
    required this.snippet,
    required this.businessSector,
  });

  factory LinkInsight.fromJson(Map<String, dynamic> json, String sector) {
    return LinkInsight(
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      snippet: json['snippet'] ?? '',
      businessSector: sector,
    );
  }
}
