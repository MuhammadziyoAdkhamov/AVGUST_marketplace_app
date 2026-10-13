import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();
  static const title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    height: 1.2,
  );
  static const heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    letterSpacing: -.4,
  );
  static const homeHeading = heading;
  static const body = TextStyle(fontSize: 14, color: AppColors.text);
  static const caption = TextStyle(fontSize: 12, color: AppColors.muted);
  static const brand = TextStyle(
    color: AppColors.brandDark,
    fontSize: 27,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.5,
  );
}
