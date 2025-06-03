import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shakti/Utils/constants/colors.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ShaktiProfileScreen extends StatefulWidget {
  @override
  _ShaktiProfileScreenState createState() => _ShaktiProfileScreenState();
}

class _ShaktiProfileScreenState extends State<ShaktiProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }
  
    static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchProfileData() async {
    try {
       final authToken = await _getAuthToken();
      if (authToken == null) {
        throw Exception('No auth token found');
      }
      final response = await http.get(
        Uri.parse('http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/shakti/shaktidetails'),
        headers: {
           'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          profileData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching profile data: $e');
      // Use static data as fallback
      setState(() {
        profileData = {
          "name": "vedu",
          "email": "vedanshi2213219@akgec.ac.in",
          "business": {
            "ideaDetails": {
              "Business_Name": "sugar ",
              "Business_Sector": "Beauty ",
              "Business_City": "ghaziabad ",
              "Buisness_Location": "uttar pradesh ",
              "Idea_Description": "organic ingredients ",
              "Target_Market": "teenager, female ",
              "Unique_Selling_Proposition": "Lipstick "
            },
            "financialPlan": {
              "Estimated_Startup_Cost": 450000,
              "Funding_Required": 68990,
              "Expected_Revenue_First_Year": 67899
            },
            "operationalPlan": {
              "Team_Size": 10,
              "Resources_Required": "infrastructure",
              "Timeline_To_Launch": "6 months"
            }
          },
          "financial": {
            "incomeDetails": {
              "Primary_Monthly_Income": 56,
              "Additional_Monthly_Income": 57
            },
            "assetDetails": {
              "Gold_Asset_amount": 67,
              "Gold_Asset_App_Value": 67,
              "Land_Asset_Area": 67,
              "Land_Asset_App_Value": 77
            },
            "existingloanDetails": [
              {
                "Monthly_Payment": 77,
                "Lender_Name": "hdfc",
                "Loan_Type": "home loan",
                "Total_Loan_Amount": 688
              }
            ]
          }
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Scolor.primary, // Dark blue background
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF0D47A1),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFFFC107)))
          : profileData == null
              ? Center(child: Text('Failed to load profile', style: TextStyle(color: Colors.white)))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Profile Header
                      _buildProfileHeader(),
                      SizedBox(height: 24),
                      
                      // Business Information
                      _buildSectionCard('Business Information', _buildBusinessDetails()),
                      SizedBox(height: 16),
                      
                      // Financial Information
                      _buildSectionCard('Financial Information', _buildFinancialDetails()),
                      SizedBox(height: 16),
                      
                      // Assets Information
                      _buildSectionCard('Assets', _buildAssetsDetails()),
                      SizedBox(height: 16),
                      
                      // Loans Information
                      _buildSectionCard('Existing Loans', _buildLoansDetails()),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3F51B5), Scolor.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFFFFC107), width: 3),
              color: Color(0xFFFFC107).withOpacity(0.2),
            ),
            child: Icon(
              Icons.person,
              size: 40,
              color: Color(0xFFFFC107),
            ),
          ),
          SizedBox(width: 20),
          
          // Name and Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileData!['name'] ?? 'N/A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  profileData!['email'] ?? 'N/A',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Edit Icon
          IconButton(
            onPressed: () {
              // Handle profile edit
            },
            icon: Icon(Icons.edit, color: Color(0xFFFFC107)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF283593),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF3F51B5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.edit, color: Color(0xFFFFC107), size: 20),
              ],
            ),
          ),
          
          // Section Content
          Padding(
            padding: EdgeInsets.all(16),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessDetails() {
    final business = profileData!['business'];
    if (business == null) return Text('No business information', style: TextStyle(color: Colors.white70));

    return Column(
      children: [
        if (business['ideaDetails'] != null) ...[
          _buildDetailRow('Business Name', business['ideaDetails']['Business_Name']),
          _buildDetailRow('Sector', business['ideaDetails']['Business_Sector']),
          _buildDetailRow('City', business['ideaDetails']['Business_City']),
          _buildDetailRow('Location', business['ideaDetails']['Buisness_Location']),
          _buildDetailRow('Description', business['ideaDetails']['Idea_Description']),
          _buildDetailRow('Target Market', business['ideaDetails']['Target_Market']),
          _buildDetailRow('USP', business['ideaDetails']['Unique_Selling_Proposition']),
        ],
        
        if (business['financialPlan'] != null) ...[
          SizedBox(height: 16),
          Text('Financial Plan', style: TextStyle(color: Color(0xFFFFC107), fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          _buildDetailRow('Startup Cost', '₹${business['financialPlan']['Estimated_Startup_Cost']}'),
          _buildDetailRow('Funding Required', '₹${business['financialPlan']['Funding_Required']}'),
          _buildDetailRow('Expected Revenue (Year 1)', '₹${business['financialPlan']['Expected_Revenue_First_Year']}'),
        ],
        
        if (business['operationalPlan'] != null) ...[
          SizedBox(height: 16),
          Text('Operational Plan', style: TextStyle(color: Color(0xFFFFC107), fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          _buildDetailRow('Team Size', business['operationalPlan']['Team_Size'].toString()),
          _buildDetailRow('Resources Required', business['operationalPlan']['Resources_Required']),
          _buildDetailRow('Timeline to Launch', business['operationalPlan']['Timeline_To_Launch']),
        ],
      ],
    );
  }

  Widget _buildFinancialDetails() {
    final financial = profileData!['financial'];
    if (financial == null || financial['incomeDetails'] == null) {
      return Text('No financial information', style: TextStyle(color: Colors.white70));
    }

    return Column(
      children: [
        _buildDetailRow('Primary Monthly Income', '₹${financial['incomeDetails']['Primary_Monthly_Income']}'),
        _buildDetailRow('Additional Monthly Income', '₹${financial['incomeDetails']['Additional_Monthly_Income']}'),
      ],
    );
  }

  Widget _buildAssetsDetails() {
    final financial = profileData!['financial'];
    if (financial == null || financial['assetDetails'] == null) {
      return Text('No asset information', style: TextStyle(color: Colors.white70));
    }

    final assets = financial['assetDetails'];
    return Column(
      children: [
        _buildDetailRow('Gold Amount', '${assets['Gold_Asset_amount']} grams'),
        _buildDetailRow('Gold Value', '₹${assets['Gold_Asset_App_Value']}'),
        _buildDetailRow('Land Area', '${assets['Land_Asset_Area']} sq ft'),
        _buildDetailRow('Land Value', '₹${assets['Land_Asset_App_Value']}'),
      ],
    );
  }

  Widget _buildLoansDetails() {
    final financial = profileData!['financial'];
    if (financial == null || financial['existingloanDetails'] == null || financial['existingloanDetails'].isEmpty) {
      return Text('No existing loans', style: TextStyle(color: Colors.white70));
    }

    return Column(
      children: financial['existingloanDetails'].map<Widget>((loan) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Scolor.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildDetailRow('Lender', loan['Lender_Name']),
              _buildDetailRow('Loan Type', loan['Loan_Type']),
              _buildDetailRow('Total Amount', '₹${loan['Total_Loan_Amount']}'),
              _buildDetailRow('Monthly Payment', '₹${loan['Monthly_Payment']}'),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Color(0xFFFFC107),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value?.toString() ?? 'N/A',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}