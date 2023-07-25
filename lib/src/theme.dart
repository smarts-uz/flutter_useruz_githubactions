import 'package:flutter/material.dart';

import 'constants/constants.dart';

class UserUzTheme {
  static ThemeData theme() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.white,
      fontFamily: 'ProximaNova',
      canvasColor: Colors.transparent,
      // primarySwatch: Colors.red,
      primaryColor: AppColors.yellow00,
      platform: TargetPlatform.iOS,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
    );
  }
}
