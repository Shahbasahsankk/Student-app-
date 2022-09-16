import 'package:flutter/material.dart';

SnackBar customSnackBar(String text, Color color) => SnackBar(
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      content: Text(text),
    );
const sizedBoxH20 =  SizedBox(height: 20);
const sizedBoxH40 =  SizedBox(height: 40);
const sizedBoxH10 =  SizedBox(height: 10);
