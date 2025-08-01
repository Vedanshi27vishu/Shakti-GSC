import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shakti/Screens/splash_Screen.dart';
import 'package:shakti/Utils/constants/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Scolor.primary),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}
