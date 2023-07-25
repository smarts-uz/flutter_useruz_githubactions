// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/database/security_storage.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/security/set_new_pin_code_screen.dart';

import '../model/api_model/auth/login_model.dart';
import '../ui/main/main_screen.dart';

class SaveData {
  ///login malumotlarini saqlash
  ///
  static void clearData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static void saveData(BuildContext context, LoginModel data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", data.accessToken);
    prefs.setString("name", data.user.name);
    prefs.setString("image", data.user.avatar);
    prefs.setInt("balance", data.user.balance);
    prefs.setInt("id", data.user.id);
    prefs.setInt("roleId", data.user.roleId);
    prefs.setBool("login_main", true);
    prefs.setString("number", data.user.phoneNumber);
    prefs.setString("email", data.user.email);
    prefs.setBool("password", data.socialpas);

    prefs.setBool("email_verified", data.user.emailVerified);
    prefs.setBool("phone_verified", data.user.phoneVerified);
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          /// if first time open set new pincode screen
          return SecurityStorage.instance.isFirstTime
              ? const SetNewPincodeScreen()

              /// else open main screen
              : const MainScreen();
        },
      ),
    );
  }
}
