import 'package:flutter/material.dart';
import 'package:food_recognizer/style/colors.dart';
import 'package:food_recognizer/style/typography.dart';

class FoodTheme {
  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: FoodTextStyles.displayLarge,
      displayMedium: FoodTextStyles.displayMedium,
      displaySmall: FoodTextStyles.displaySmall,
      headlineLarge: FoodTextStyles.headlineLarge,
      headlineMedium: FoodTextStyles.headlineMedium,
      headlineSmall: FoodTextStyles.headlineSmall,
      titleLarge: FoodTextStyles.titleLarge,
      titleMedium: FoodTextStyles.titleMedium,
      titleSmall: FoodTextStyles.titleSmall,
      bodyLarge: FoodTextStyles.bodyLargeBold,
      bodyMedium: FoodTextStyles.bodyLargeMedium,
      bodySmall: FoodTextStyles.bodyLargeRegular,
      labelLarge: FoodTextStyles.labelLarge,
      labelMedium: FoodTextStyles.labelMedium,
      labelSmall: FoodTextStyles.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textTheme.titleLarge,
      // actionsPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: FoodColors.green.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: FoodColors.green.color,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }
}
