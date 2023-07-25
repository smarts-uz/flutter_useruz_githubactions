// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/model/http_result.dart';

class Utils {
  static String serverErrorText(HttpResult response) {
    String s = translate("server_error");
    if (response.status == 500 || response.status == 404) {
      return s;
    } else {
      try {
        return response.result["message"] ??
            response.result["messages"] ??
            response.result["data"]["message"] ??
            s;
      } catch (_) {
        return s;
      }
    }
  }

  static bool selectedCategory(
    CategoryModel data,
    List<CategoryModel> selectedData,
  ) {
    bool selected = false;
    for (int i = 0; i < selectedData.length; i++) {
      if (selectedData[i].id == data.id && selectedData[i].selectedItem) {
        selected = true;
        break;
      }
    }
    return selected;
  }

  static bool selectedSubCategory(
    CategoryModel data,
    List<CategoryModel> selectedData,
  ) {
    bool selected = false;
    for (int i = 0; i < selectedData.length; i++) {
      if (selectedData[i].id == data.id && selectedData[i].selectedItem) {
        selected = true;
        break;
      }
    }
    return selected;
  }

  static String fullDateChatFormat(DateTime dateTime) {
    return numberFormat(dateTime.day) +
        "." +
        numberFormat(dateTime.month) +
        "." +
        numberFormat(dateTime.year) +
        ", " +
        numberFormat(dateTime.hour) +
        ":" +
        numberFormat(dateTime.minute);
  }

  static String dateNameFormatCreateDate(DateTime dateTime) {
    DateTime _now = DateTime.now();
    if (_now.day == dateTime.day &&
        _now.month == dateTime.month &&
        _now.year == dateTime.year) {
      return translate("today") +
          ", " +
          numberFormat(dateTime.hour) +
          ":" +
          numberFormat(dateTime.minute);
    } else {
      return weekFormat(dateTime.weekday) +
          ", " +
          numberFormat(dateTime.day) +
          " " +
          monthFormat(dateTime.month) +
          " " +
          dateTime.year.toString() +
          ", " +
          numberFormat(dateTime.hour) +
          ":" +
          numberFormat(dateTime.minute);
    }
  }

  static String dataBalanceFormat(DateTime dateTime) {
    return numberFormat(dateTime.day) +
        " " +
        monthFormat(dateTime.month) +
        " " +
        dateTime.year.toString();
  }

  static String notificationTimeFormat(DateTime dateTime) {
    return numberFormat(dateTime.hour) + " : " + numberFormat(dateTime.minute);
  }

  static String weekFormat(int week) {
    switch (week) {
      case 1:
        {
          return translate("week.1");
        }
      case 2:
        {
          return translate("week.2");
        }
      case 3:
        {
          return translate("week.3");
        }
      case 4:
        {
          return translate("week.4");
        }
      case 5:
        {
          return translate("week.5");
        }
      case 6:
        {
          return translate("week.6");
        }
      default:
        {
          return translate("week.7");
        }
    }
  }

  static String monthFormat(int mont) {
    switch (mont) {
      case 1:
        {
          return translate("month.1");
        }
      case 2:
        {
          return translate("month.2");
        }
      case 3:
        {
          return translate("month.3");
        }
      case 4:
        {
          return translate("month.4");
        }
      case 5:
        {
          return translate("month.5");
        }
      case 6:
        {
          return translate("month.6");
        }
      case 7:
        {
          return translate("month.7");
        }
      case 8:
        {
          return translate("month.8");
        }
      case 9:
        {
          return translate("month.9");
        }
      case 10:
        {
          return translate("month.10");
        }
      case 11:
        {
          return translate("month.11");
        }
      default:
        {
          return translate("month.12");
        }
    }
  }

  static String sendServerDataFormat(DateTime dateTime) {
    return dateTime.year.toString() +
        "-" +
        numberFormat(dateTime.month) +
        "-" +
        numberFormat(dateTime.day) +
        " " +
        numberFormat(dateTime.hour) +
        ":" +
        numberFormat(dateTime.minute);
  }

  static String balanceDateForServerFormat(DateTime dateTime) {
    return dateTime.year.toString() +
        "-" +
        numberFormat(dateTime.month) +
        "-" +
        numberFormat(dateTime.day);
  }

  static String notificationForServerFormat(DateTime dateTime) {
    return numberFormat(dateTime.hour) +
        ":" +
        numberFormat(dateTime.minute) +
        ":" +
        numberFormat(dateTime.second);
  }

  static Future<String> checkConnection() async {
    var g = await InternetConnectionChecker().connectionStatus;
    if (kDebugMode) {
      print(g.name);
      print(g.index);
      print(g.runtimeType);
    }
    String error = "";
    if ((g.index == 1)) {
      error = translate("network_title");
    } else {
      error = translate("server_error");
    }
    return error;
  }

  static String numberFormat(int number) {
    if (number > 9) {
      return number.toString();
    } else {
      return "0" + number.toString();
    }
  }

  static close(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  static String? correct(String text) {
    bool number = false;
    for (int i = 0; i < text.length; i++) {
      try {
        int.parse(text[i]);
        number = true;
      } catch (_) {}
    }
    if (text.length < 8) {
      return translate("error_two");
    } else if (text.toLowerCase() == text) {
      return translate("error_three");
    } else if (text.trim() != text) {
      return translate("error_four");
    } else if (!number) {
      return translate("error_five");
    }

    return null;
  }

  static const String google = 'google';
  static const String facebook = 'facebook';
  static const String apple = 'apple';

  static const String androidVersion = "App version: $currentVersion";
  static const String iosVersion = "App version: $currentVersion";
  static const String currentVersion = "1.3.1";
  static const String yandexApiKey = "4002b007-e1d4-47c3-9b0a-315b23c755ac";
  static const String yandexSearchKey = "7763ee2d-0e36-4f6a-9532-944ed173aab3";
  static const int priceValidator = 10000;
  static const String supportPhoneNumber = '+998 99 123 45 67';
  static const String newsLink = 'https://user.uz/news/';

  static const String telegramUrl = 'https://t.me/dartlang_jobs';
  static const String facebookUrl = '';
  static const String instagramUrl = '';
  static const String webUrl = 'https://user.uz';
}
