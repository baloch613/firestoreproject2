import 'package:flutter/material.dart';

void showMySnackbar(BuildContext context, String message,
    {Color backgroundColor = Colors.blue,
    Color textColor = Colors.white,
    int durationInSeconds = 2}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: Duration(seconds: durationInSeconds),
    ),
  );
}
