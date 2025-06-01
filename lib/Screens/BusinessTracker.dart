import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shakti/Screens/Finance.dart';
import 'package:shakti/Utils/constants/colors.dart';

class ComparativeTrackerScreen extends StatefulWidget {
  const ComparativeTrackerScreen({Key? key}) : super(key: key);

  @override
  State<ComparativeTrackerScreen> createState() =>
      _ComparativeTrackerScreenState();
}

class _ComparativeTrackerScreenState extends State<ComparativeTrackerScreen> {
  // DATABASE INTEGRATION POINTS - Replace with your database calls

  // Comparative data for current vs next month
  List<double> currentMonthData = [2000, 1500, 1200, 800, 1800, 1000];
  List<double> nextMonthData = [2200, 1600, 1300, 900, 1900, 1200];
  List<String> monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  // Business metrics
  String currentMonthValue = '727500';
  String currentMonthGrowth = '6.2%';
  String projectedValue = '940000';
  String projectedGrowth = '9.6%';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Scolor.primary,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildComparativeChart(),
              const SizedBox(height: 24),
              _buildBusinessMetricsSection(),
              const SizedBox(height: 24),
              _buildKeyFeaturesSection(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Scolor.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Scolor.secondry, size: 24),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Finance())),
      ),
      actions: [
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
              _buildLegend('Current Month', Scolor.secondry),
              const SizedBox(width: 20),
              _buildLegend('Next Month', const Color(0xFF95A5A6)),
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
                      String monthName = monthLabels[group.x];
                      String dataType = rodIndex == 0 ? 'Current' : 'Next';
                      return BarTooltipItem(
                        '$dataType Month\n$monthName: ${rod.toY.round()}',
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
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) =>
                          _buildBottomTitle(value.toInt()),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 500,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) => _buildLeftTitle(value),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  drawHorizontalLine: true,
                  horizontalInterval: 500,
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
        const Text(
          'Food Service',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Current Month Card (Yellow)
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
                    'Current Month',
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
        // Best Month Prediction Card (Dark)
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
                    'Best Month Prediction',
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

  Widget _buildKeyFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Features',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildFeatureItem(Icons.info_outline, 'Raw material prices stable'),
        const SizedBox(height: 12),
        _buildFeatureItem(Icons.trending_up, 'Regular customer base growing'),
        const SizedBox(height: 12),
        _buildFeatureItem(
            Icons.school_outlined, 'Staff training costs expected'),
      ],
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
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLeftTitle(double value) {
    return Text(
      value.toInt().toString(),
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
          // Current Month Bar (Yellow)
          BarChartRodData(
            toY: currentMonthData[index],
            color: Scolor.secondry,
            width: 16,
            borderRadius: BorderRadius.circular(0),
          ),
          // Next Month Bar (Gray)
          BarChartRodData(
            toY: nextMonthData[index],
            color: const Color(0xFF95A5A6),
            width: 16,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: 0,
      );
    });
  }

  double _getMaxValue() {
    List<double> allValues = [...currentMonthData, ...nextMonthData];
    return allValues.reduce((a, b) => a > b ? a : b);
  }

  // DATABASE INTEGRATION METHODS
  void updateComparativeData({
    required List<double> current,
    required List<double> next,
    required List<String> labels,
  }) {
    setState(() {
      currentMonthData = current;
      nextMonthData = next;
      monthLabels = labels;
    });
  }

  void updateMetrics({
    required String currentValue,
    required String currentGrowth,
    required String projectedVal,
    required String projectedGrowthVal,
  }) {
    setState(() {
      currentMonthValue = currentValue;
      currentMonthGrowth = currentGrowth;
      projectedValue = projectedVal;
      projectedGrowth = projectedGrowthVal;
    });
  }
}

// Main App
class ComparativeTrackerApp extends StatelessWidget {
  const ComparativeTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comparative Business Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ComparativeTrackerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
