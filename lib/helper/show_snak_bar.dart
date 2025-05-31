
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, {int? duration }) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: duration ?? 4),
      content: Center(
        heightFactor: 1,
        child: Text(message),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 16,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  );
}