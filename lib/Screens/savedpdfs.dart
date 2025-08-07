import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shakti/Screens/pdf_viewer.dart' show PDFViewerScreen;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shakti/Utils/constants/colors.dart'; // Your custom colors

class MyLinksScreen extends StatefulWidget {
  const MyLinksScreen({super.key});

  @override
  State<MyLinksScreen> createState() => _MyLinksScreenState();
}

class _MyLinksScreenState extends State<MyLinksScreen> {
  late Future<List<PdfInsight>> _myLinksFuture;

  @override
  void initState() {
    super.initState();
    _myLinksFuture = fetchMyLinks();
  }

  Future<List<PdfInsight>> fetchMyLinks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://shaktinxt.me/api/my-results'),
      headers: {'Authorization': 'Bearer ${token ?? ''}'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((item) => PdfInsight.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load my links');
    }
  }

  void openPDF(BuildContext context, String pdfUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(pdfUrl: pdfUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Scolor.primary,
      appBar: AppBar(
        backgroundColor: Scolor.primary,
        elevation: 0,
        title: const Text("My Uploaded Documents",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Scolor.secondry),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<PdfInsight>>(
        future: _myLinksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Scolor.secondry),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No uploaded documents found',
                  style: TextStyle(color: Colors.white)),
            );
          }

          final myLinks = snapshot.data!;
          return ListView.builder(
            itemCount: myLinks.length,
            itemBuilder: (context, index) {
              final doc = myLinks[index];
              return ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.amber),
                title: Text(doc.title,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(doc.snippet,
                    style: const TextStyle(color: Colors.grey)),
                onTap: () => openPDF(context, doc.pdfUrl),
              );
            },
          );
        },
      ),
    );
  }
}

class PdfInsight {
  final String title;
  final String snippet;
  final String pdfUrl;

  PdfInsight({
    required this.title,
    required this.snippet,
    required this.pdfUrl,
  });

  factory PdfInsight.fromJson(Map<String, dynamic> json) {
    return PdfInsight(
      title: json['title'] ?? '',
      snippet: json['snippet'] ?? '',
      pdfUrl: json['link'] ?? '', // Adjust the key based on your API
    );
  }
}
