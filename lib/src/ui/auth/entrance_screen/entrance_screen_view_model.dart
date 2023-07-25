import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/auth/login_screen.dart';
import 'package:youdu/src/ui/auth/register_screen.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/widget/web_page.dart';

class EntranceScreenViewModel {
  EntranceScreenViewModel();

  /// saves login main locally
  Future<void> saveLoginMain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("login_main", true);
  }

  /// skips auth
  void skipEntranceScreen(BuildContext context) {
    saveLoginMain();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MainScreen();
        },
      ),
    );
  }

  /// opens terms web screen in uz language
  void openUZTermsWebScreen(BuildContext context) {
    if (LanguagePerformers.getLanguage() == "uz") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WebViewPage(
            url: "https://user.uz/terms/uz",
          ),
        ),
      );
    }
  }

  /// opens terms web screen in ru language
  void openRUTermsWebScreen(BuildContext context) {
    if (LanguagePerformers.getLanguage() == "ru") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WebViewPage(
            url: "https://user.uz/terms/ru",
          ),
        ),
      );
    }
  }

  /// navigates to register screen
  void navigateToRegisterScreen(bool value, BuildContext context) {
    value
        ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const RegisterScreen();
              },
            ),
          )
        : null;
  }

  /// navigates to login screen
  void navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ),
    );
  }

  /// custom rich text widget
  Widget myWidget(
    BuildContext context,
    String drug,
    String subWord,
  ) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: drug,
            style: AppTypography.h2ExtraLarge.copyWith(
              color: LanguagePerformers.getLanguage() == 'ru'
                  ? AppColors.dark33
                  : AppColors.yellow16,
            ),
          ),
          TextSpan(
            text: subWord,
            style: AppTypography.h2ExtraLarge.copyWith(
              color: LanguagePerformers.getLanguage() == 'ru'
                  ? AppColors.yellow16
                  : AppColors.dark33,
            ),
          )
        ],
      ),
    );
  }

  /// sets local language
  Future<void> setLanguage(BuildContext context) async {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    localizationDelegate.changeLocale(
      Locale(LanguagePerformers.getLanguage()),
    );
  }
}
