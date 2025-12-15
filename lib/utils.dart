// ignore_for_file: prefer_final_fields

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static GlobalKey<NavigatorState> sideMenuNavigationKey = GlobalKey();
  var _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  Random _rnd = Random();

  String formatCurrency({double? amount = 1, int? decimalPoints = 2}) {
    final formatCurrency = NumberFormat.decimalPatternDigits(
      locale: 'en_us', // Replace with your desired currency symbol
      decimalDigits: decimalPoints, // Number of decimal places
    );
    return formatCurrency.format(amount);
  }

  String timeAgo(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} weeks ago";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} months ago";
    } else {
      return "${(difference.inDays / 365).floor()} years ago";
    }
  }

  String convertTo12HourFormat(String time24) {
    // Parse the string into a DateTime object
    final DateTime dateTime = DateFormat("HH:mm").parse(time24);

    // Format it to 12-hour time format with AM/PM
    return DateFormat('h:mm a').format(dateTime);
  }

  convertTimeToMinutes(String time) {
    String hour = time.substring(0, 2);
    String min = time.substring(3, 5);

    return (int.parse(hour) * 60) + int.parse(min);
  }

  double convertFromPesewasToCedi(double amount) {
    return amount / 100;
  }

  String truncateText(String text, int limit) {
    return (text.length > limit) ? '${text.substring(0, limit)}...' : text;
  }

  double convertFromCediToPesewas(double amount) {
    return amount * 100;
  }

  String formatImageUrl(String imageUrl) {
    return imageUrl.replaceAll(
        "localhost", const String.fromEnvironment('PROJECT_HOST'));
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  bool isNumeric(String entry) {
    if (double.tryParse(entry) != null) {
      return true;
    } else {
      return false;
    }
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text; // Return empty if string is empty
    return text[0].toUpperCase() + text.substring(1);
  }

  bool isDateToday(String dateString) {
    try {
      DateTime inputDate = DateTime.parse(dateString);
      DateTime today = DateTime.now();

      return inputDate.day == today.day &&
          inputDate.month == today.month &&
          inputDate.year == today.year;
    } catch (e) {
      // Handle invalid date format
      return false;
    }
  }

  String toTitleCase(String input) {
    List<String> words = input.split('_');
    // Remove the last word if it's 'id'
    if (words.isNotEmpty && words.last.toLowerCase() == 'id') {
      words.removeLast();
    }
    // Capitalize each word
    words = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).toList();
    return words.join(' ');
  }

  static slideRightTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
