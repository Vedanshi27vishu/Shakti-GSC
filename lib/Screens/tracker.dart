import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shakti/Screens/Invest.dart';
import 'package:shakti/Utils/constants/colors.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  // Sample data - replace this with your database integration
  List<FlSpot> chartData = [
    const FlSpot(0, 650), // Jan
    const FlSpot(1, 1300), // Feb
    const FlSpot(2, 1550), // Mar
    const FlSpot(3, 1750), // Apr
    const FlSpot(4, 2100), // May
    const FlSpot(5, 2600), // June
  ];

  List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Scolor.primary, // Dark blue background
      appBar: AppBar(
        backgroundColor: Scolor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Scolor.secondry,
            size: 24,
          ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>Invest())),
        ),
        title: const Text(
          'Tracker-',
          style: TextStyle(
            color: Scolor.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Title Section
          const Text(
            'Track Your Growth',
            style: TextStyle(
              color: Scolor.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 245, 194, 7), Scolor.secondry],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 40),

          // Chart Section
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF34495E).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF34495E),
                  width: 1,
                ),
              ),
              child: LineChart(
                LineChartData(
                    backgroundColor: Colors.transparent,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      horizontalInterval: 650,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return const FlLine(
                          color: Color(0xFF34495E),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return const FlLine(
                          color: Color(0xFF34495E),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() < months.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  months[value.toInt()],
                                  style: const TextStyle(
                                    color: Scolor.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 650,
                          reservedSize: 60,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Scolor.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    minX: 0,
                    maxX: 5,
                    minY: 0,
                    maxY: 3000,
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartData,
                        isCurved: true,
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 245, 194, 7),
                            Scolor.secondry,
                          ],
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Scolor.secondry,
                              strokeWidth: 2,
                              strokeColor: Scolor.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color.fromARGB(255, 245, 194, 7)
                                  .withOpacity(0.3),
                              const Color.fromARGB(255, 245, 194, 7)
                                  .withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// Usage Example - Add this to your main app
class TrackerApp extends StatelessWidget {
  const TrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Growth Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TrackerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
