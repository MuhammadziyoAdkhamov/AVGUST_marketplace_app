import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const title = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    height: 1.3,
  );

  static const heading = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
  );

  static const body = TextStyle(fontSize: 14, color: AppColors.text);

  static const caption = TextStyle(fontSize: 12, color: AppColors.muted);

  static const brand = TextStyle(
    color: AppColors.brandDark,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );
}
