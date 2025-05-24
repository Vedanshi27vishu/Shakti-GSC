import 'package:flutter/material.dart';
import 'package:get/get.dart';

class THelperFunctions {
  /// Get color based on string value
  static Color? getColor(String value) {
    switch (value.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'pink':
        return Colors.pink;
      case 'grey':
        return Colors.grey;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'indigo':
        return Colors.indigo;
      default:
        return null;
    }
  }

  /// Show a snack bar message
  static void showSnackBar(String message) {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  /// Show an alert dialog
  static void showAlert(String title, String message) {
    if (Get.context != null) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  /// Navigate to a new screen
  static void navigateToScreen(Widget screen) {
    if (Get.context != null) {
      Navigator.push(
        Get.context!,
        MaterialPageRoute(builder: (_) => screen),
      );
    }
  }

  /// Truncate text if it exceeds a given length
  static String truncateText(String text, int maxLength) {
    return text.length <= maxLength ? text : '${text.substring(0, maxLength)}...';
  }

  /// Check if the current theme mode is dark
  static bool isDarkMode() {
    return Get.context != null && Theme.of(Get.context!).brightness == Brightness.dark;
  }

  /// Get screen size using GetX context
  static Size screenSize() {
    return Get.context != null ? MediaQuery.of(Get.context!).size : const Size(0, 0);
  }

  /// Get screen width using GetX
  static double screenWidth() {
    return screenSize().width;
  }

  /// Get screen height using GetX
  static double screenHeight() {
    return screenSize().height;
  }

  /// Remove duplicates from a list
  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }
}
