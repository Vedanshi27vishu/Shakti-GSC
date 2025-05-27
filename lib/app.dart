import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shakti/Screens/BusinessTracker.dart';
import 'package:shakti/Screens/CreatePost.dart';
import 'package:shakti/Screens/ExpertsInsights.dart';
import 'package:shakti/Screens/FinancialRecords.dart';
import 'package:shakti/Screens/Financialflowchart.dart';
import 'package:shakti/Screens/InvestScreen.dart';
import 'package:shakti/Screens/InvestmentGroup.dart';
import 'package:shakti/Screens/Start.dart';
import 'package:shakti/Screens/YourProgress.dart';
import 'package:shakti/Screens/taskcreate.dart';
import 'package:shakti/Screens/tracker.dart';
import 'package:shakti/Utils/constants/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Scolor.primary),
        debugShowCheckedModeBanner: false,
        home: 
    StartScreen());
  }
}
