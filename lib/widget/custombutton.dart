import 'package:flutter/material.dart';

import '../constants.dart';
// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({super.key, this.text,this.onTap});
  VoidCallback? onTap;
  String? text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: KPrimaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        text??'Sign in',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
