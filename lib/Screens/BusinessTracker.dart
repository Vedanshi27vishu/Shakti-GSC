import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shakti/Screens/Budget_insights.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExpenditureData {
  final double cogs;
  final double salaries;
  final double maintenance;
  final double marketing;
  final double investment;

  ExpenditureData({
    required this.cogs,
    required this.salaries,
    required this.maintenance,
    required this.marketing,
    required this.investment,
  });

  factory ExpenditureData.fromJson(Map<String, dynamic> json) {
    return ExpenditureData(
      cogs: json['COGs'].toDouble(),
      salaries: json['Salaries'].toDouble(),
      maintenance: json['Maintenance'].toDouble(),
      marketing: json['Marketing'].toDouble(),
      investment: json['Investment'].toDouble(),
    );
  }

  double get total => cogs + salaries + maintenance + marketing + investment;
}

class BusinessExpenditure {
  final String businessType;
  final List<ExpenditureData> lastTwoExpenditures;

  BusinessExpenditure({
    required this.businessType,
    required this.lastTwoExpenditures,
  });

  factory BusinessExpenditure.fromJson(Map<String, dynamic> json) {
    var expendituresList = json['lastTwoExpenditures'] as List;
    List<ExpenditureData> expenditures =
        expendituresList.map((e) => ExpenditureData.fromJson(e)).toList();

    return BusinessExpenditure(
      businessType: json['businessType'],
      lastTwoExpenditures: expenditures,
    );
  }
}

class ApiResponse {
  final List<BusinessExpenditure> expenditures;

  ApiResponse({required this.expenditures});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var expendituresList = json['expenditures'] as List;
    List<BusinessExpenditure> expenditures =
        expendituresList.map((e) => BusinessExpenditure.fromJson(e)).toList();

    return ApiResponse(expenditures: expenditures);
  }
}

class ComparativeTrackerScreen extends StatefulWidget {
  const ComparativeTrackerScreen({Key? key}) : super(key: key);

  @override
  State<ComparativeTrackerScreen> createState() =>
      _ComparativeTrackerScreenState();
}

class _ComparativeTrackerScreenState extends State<ComparativeTrackerScreen> {
  // Data variables
  List<double> currentMonthData = [];
  List<double> nextMonthData = [];
  List<String> monthLabels = [
    'COGs',
    'Salaries',
    'Maintenance',
    'Marketing',
    'Investment'
  ];

  // Business metrics
  String currentMonthValue = '0';
  String currentMonthGrowth = '0%';
  String projectedValue = '0';
  String projectedGrowth = '0%';
  String businessType = 'Business';

  bool isLoading = true;

  // New variables for profit input
  final TextEditingController _profitController = TextEditingController();
  bool _isPredictingBudget = false;
  String _predictedBudget = '';
  Map<String, dynamic>? insights;

  @override
  void initState() {
    super.initState();
    fetchInsights();
    loadExpenditureData();
  }

  Future<void> fetchInsights() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(
          'https://shaktinxt.me/api/business/insights',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Assuming your API directly returns the insights JSON like:
        // { "point1": "...", "point2": "...", ... }
        setState(() {
          insights = jsonData;
          // List of all insight strings// insights should be a Map<String, dynamic> in your class
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading insights data: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> loadExpenditureData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.get(
        Uri.parse('https://shaktinxt.me/api/last-two-expenditures'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse.fromJson(json.decode(response.body));
        if (apiResponse.expenditures.isNotEmpty) {
          processExpenditureData(apiResponse.expenditures.first);
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading expenditure data: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      useFallbackData();
    }

    setState(() {
      isLoading = false;
    });
  }

  // New method to predict budget
  Future<void> _predictBudget() async {
    if (_profitController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter current month profit'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isPredictingBudget = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Convert business type to lowercase for query parameter
      String sector = businessType.toLowerCase();

      final response = await http.post(
        Uri.parse('https://shaktinxt.me/api/predict-budget/$sector'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'newProfit': double.parse(_profitController.text),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _predictedBudget =
              responseData['predictedBudget']?.toString() ?? 'N/A';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Budget uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to predict budget: ${response.statusCode}');
      }
    } catch (e) {
      print('Error predicting budget: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to predict budget: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isPredictingBudget = false;
    });
  }

  void processExpenditureData(BusinessExpenditure businessExpenditure) {
    // Extract data from the two expenditure periods
    if (businessExpenditure.lastTwoExpenditures.length >= 2) {
      ExpenditureData period1 = businessExpenditure.lastTwoExpenditures[0];
      ExpenditureData period2 = businessExpenditure.lastTwoExpenditures[1];

      // Set chart data
      currentMonthData = [
        period1.cogs,
        period1.salaries,
        period1.maintenance,
        period1.marketing,
        period1.investment,
      ];

      nextMonthData = [
        period2.cogs,
        period2.salaries,
        period2.maintenance,
        period2.marketing,
        period2.investment,
      ];

      // Calculate metrics
      double currentTotal = period1.total;
      double nextTotal = period2.total;
      double growthPercentage =
          ((nextTotal - currentTotal) / currentTotal) * 100;

      // Update business metrics
      businessType = businessExpenditure.businessType.toUpperCase();
      currentMonthValue = currentTotal.toInt().toString();
      projectedValue = nextTotal.toInt().toString();
      currentMonthGrowth = '${growthPercentage.toStringAsFixed(1)}%';
      projectedGrowth =
          '${(growthPercentage + 2).toStringAsFixed(1)}%'; // Slight projection increase
    }
  }

  void useFallbackData() {
    currentMonthData = [2000, 1500, 1200, 800, 1800, 1000];
    nextMonthData = [2200, 1600, 1300, 900, 1900, 1200];
    monthLabels = [
      'COGs',
      'Salaries',
      'Maintenance',
      'Marketing',
      'Investment'
    ];
    currentMonthValue = '727500';
    currentMonthGrowth = '6.2%';
    projectedValue = '940000';
    projectedGrowth = '9.6%';
    businessType = 'BUSINESS';
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await loadExpenditureData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Scolor.primary,
      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Scolor.secondry,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildComparativeChart(),
                    const SizedBox(height: 24),
                    _buildBusinessMetricsSection(),
                    const SizedBox(height: 24),
                    _buildProfitInputSection(), // New section added
                    const SizedBox(height: 24),
                    _buildKeyFeaturesSection(context, insights),
                  ],
                ),
              ),
            ),
    );
  }

  // New method for profit input section
  Widget _buildProfitInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF34495E).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF34495E), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget Prediction',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _profitController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Current Month Profit',
              labelStyle: const TextStyle(color: Colors.white70),
              hintText: 'Enter profit amount',
              hintStyle: const TextStyle(color: Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white54),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Scolor.secondry),
              ),
              filled: true,
              fillColor: const Color(0xFF34495E).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isPredictingBudget ? null : _predictBudget,
              style: ElevatedButton.styleFrom(
                backgroundColor: Scolor.secondry,
                foregroundColor: Scolor.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isPredictingBudget
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Scolor.primary,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Predict Budget',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Scolor.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Scolor.secondry, size: 24),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: refreshData,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildComparativeChart() {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF34495E).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF34495E), width: 1),
      ),
      child: Column(
        children: [
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend('Previous Month', const Color(0xFF95A5A6)),
              const SizedBox(width: 20),
              _buildLegend('Current Month', Scolor.secondry),
            ],
          ),
          const SizedBox(height: 20),
          // Chart
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxValue() * 1.2,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => const Color(0xFF34495E),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String categoryName = monthLabels[group.x];
                      String dataType = rodIndex == 0 ? 'Current' : 'Next';
                      return BarTooltipItem(
                        '$dataType Period\n$categoryName: ${rod.toY.round()}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) =>
                          _buildBottomTitle(value.toInt()),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _getMaxValue() / 5,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => _buildLeftTitle(value),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  drawHorizontalLine: true,
                  horizontalInterval: _getMaxValue() / 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFF34495E).withOpacity(0.5),
                    strokeWidth: 1,
                  ),
                ),
                barGroups: _buildComparativeBarGroups(),
                groupsSpace: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          businessType,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Current Period Card (Yellow)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Scolor.secondry,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Current Month Profit',
                    style: TextStyle(
                      color: Scolor.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    currentMonthGrowth,
                    style: const TextStyle(
                      color: Scolor.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                currentMonthValue,
                style: const TextStyle(
                  color: Scolor.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF34495E).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF34495E), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Previous Month Profit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    projectedGrowth,
                    style: const TextStyle(
                      color: Color(0xFFF1C40F),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                projectedValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyFeaturesSection(
      BuildContext context, Map<String, dynamic>? insights) {
    final insightValues = insights?.values.toList() ?? [];

    final formattedInsightData = List.generate(insightValues.length, (index) {
      final value = insightValues[index];
      // If the value is a Map, extract the 'description' or convert to string
      String description = value is Map && value.containsKey('description')
          ? value['description'].toString()
          : value.toString();

      return {
        'title': 'Insight ${index + 1}',
        'description': description,
      };
    });

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BudgetInsights(
              budgetData: formattedInsightData,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureItem(
            Icons.info_outline,
            formattedInsightData.isNotEmpty
                ? formattedInsightData[0]['description'] ?? 'Loading...'
                : 'Loading...',
          ),
          const SizedBox(height: 12),
          _buildFeatureItem(
            Icons.trending_up,
            formattedInsightData.length > 1
                ? formattedInsightData[1]['description'] ?? 'Loading...'
                : 'Loading...',
          ),
          const SizedBox(height: 12),
          _buildFeatureItem(
            Icons.school_outlined,
            formattedInsightData.length > 2
                ? formattedInsightData[2]['description'] ?? 'Loading...'
                : 'Loading...',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF34495E).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF34495E), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Scolor.secondry,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Scolor.primary, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomTitle(int index) {
    if (index >= 0 && index < monthLabels.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          monthLabels[index],
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLeftTitle(double value) {
    String formattedValue;
    if (value >= 1000000) {
      formattedValue = '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      formattedValue = '${(value / 1000).toStringAsFixed(0)}K';
    } else {
      formattedValue = value.toInt().toString();
    }

    return Text(
      formattedValue,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  List<BarChartGroupData> _buildComparativeBarGroups() {
    return List.generate(monthLabels.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          // Current Period Bar (Yellow)
          BarChartRodData(
            toY: currentMonthData.isNotEmpty ? currentMonthData[index] : 0,
            color: const Color(0xFF95A5A6),
            width: 16,
            borderRadius: BorderRadius.circular(0),
          ),
          // Next Period Bar (Gray)
          BarChartRodData(
            toY: nextMonthData.isNotEmpty ? nextMonthData[index] : 0,
            color: Scolor.secondry,
            width: 16,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: 1,
      );
    });
  }

  double _getMaxValue() {
    if (currentMonthData.isEmpty && nextMonthData.isEmpty) return 3000;

    List<double> allValues = [...currentMonthData, ...nextMonthData];
    return allValues.reduce((a, b) => a > b ? a : b);
  }

  @override
  void dispose() {
    _profitController.dispose();
    super.dispose();
  }
}
