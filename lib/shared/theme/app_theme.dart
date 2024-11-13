import 'package:flutter/material.dart';
import 'package:online_shop/shared/theme/app_colors.dart';

class AppTheme {
  /// Light theme data of the app
  static ThemeData get defaultTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.black,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        floatingLabelAlignment: FloatingLabelAlignment.start,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
