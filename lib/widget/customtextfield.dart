import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  CustomTextField({super.key, this.obscureText, this.suffixIcon,this.color,this.hintText,this.onChanged,this.validator,this.backgroundColor,this.textcolor});
  bool? obscureText = true;
  Function(String)? onChanged;
  String? Function(String?)? validator;
  IconButton? suffixIcon;
  Color? color, backgroundColor,textcolor;
  String? hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(

      onChanged: onChanged,
      validator: validator,
      style: TextStyle(color: textcolor?? Colors.black),
      obscureText: obscureText ?? true,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor ?? Colors.white,
        hintText: hintText??'',
        hintStyle: TextStyle(color: textcolor?? Colors.grey ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: suffixIcon ,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color?? KPrimaryColor),
        ),
      ),
    );
  }
}
