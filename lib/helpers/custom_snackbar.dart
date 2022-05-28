import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showSnackBar(String content,BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(20.0))),
        content: Text(content)));
  }
}
