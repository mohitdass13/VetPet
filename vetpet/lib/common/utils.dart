import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class Utils {
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static String formatDateTime(DateTime dt) {
    return DateFormat('dd/mm/yy hh:mm:ss a').format(dt);
  }

  static String formatDate(DateTime dt) {
    return DateFormat('dd/mm/yy').format(dt);
  }
}
