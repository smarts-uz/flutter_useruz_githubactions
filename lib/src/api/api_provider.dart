// ignore_for_file: prefer_interpolation_to_compose_strings, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/utils/utils.dart';
import '../model/api/create/send_address_model.dart';
import '../model/api_model/guest/performers/performers_filter_model.dart';

class ApiProvider {
  static Duration durationTimeout = const Duration(seconds: 30);

  static String baseUrl = "https://user.uz/api/";
  static String devUrl = "https://dev.user.uz/api/";

  static void setToDev(bool toDev) {
    baseUrl = toDev ? "https://dev.user.uz/api/" : "https://user.uz/api/";
  }

  static final log = Logger('ApiProviderLog');

  ///http POST Request
  static Future<HttpResult> _postRequest(url, body) async {
    final Map<String, String> headers = await _header();

    log.info(
        "Post Request\nUrl : $url,\nHeaders : $headers,\nBody : ${json.encode(body)}");

    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: json.encode(body),
          )
          .timeout(durationTimeout);

      return _result(response);
    } on TimeoutException catch (_) {
      log.severe(
          "Error!!!\nPost Request\nUrl : $url,\nHeaders : $headers,\nBody : ${json.encode(body)}");
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: translate("time_out"),
      );
    } on SocketException catch (_) {
      log.severe(
          "Error!!!\nPost Request\nUrl : $url,\nHeaders : $headers,\nBody : ${json.encode(body)}");
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: await Utils.checkConnection(),
      );
    } on Exception catch (e) {
      log.severe(
          "Error!!!\nPost Request\nUrl : $url,\nHeaders : $headers,\nBody : ${json.encode(body)} \nError : $e");
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: e.toString(),
      );
    }
  }

  ///http GET Request
  static Future<HttpResult> _getRequest(url) async {
    final Map<String, String> headers = await _header();
    log.info("Get Request\nUrl : $url,\nHeaders : $headers");
    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(durationTimeout);
      log.info(
          "Data\nGet Request\nUrl : $url,\nHeaders : $headers,\nBody : ${response.body}");
      return _result(response);
    } on TimeoutException catch (_) {
      log.severe("Error!!!\nGet Request\nUrl : $url,\nHeaders : $headers");
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: translate("time_out"),
      );
    } on SocketException catch (_) {
      log.severe("Error!!!\nGet Request\nUrl : $url,\nHeaders : $headers");
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: await Utils.checkConnection(),
      );
    } on Exception catch (e) {
      log.severe(
          "Error!!!\nGet Request\nUrl : $url,\nHeaders : $headers, \nError : $e");
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: e.toString(),
      );
    }
  }

  ///http DELETE Request
  static Future<HttpResult> _delete(url) async {
    final Map<String, String> headers = await _header();
    log.info("Delete Request\nUrl : $url,\nHeaders : $headers");
    try {
      http.Response response = await http
          .delete(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(durationTimeout);
      return _result(response);
    } on TimeoutException catch (_) {
      log.severe("Error!!!\nDelete Request\nUrl : $url,\nHeaders : $headers");
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: translate("time_out"),
      );
    } on SocketException catch (_) {
      log.severe("Error!!!\nDelete Request\nUrl : $url,\nHeaders : $headers");
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: await Utils.checkConnection(),
      );
    }
  }

  ///http Result
  static HttpResult _result(http.Response response) {
    log.info(
        "Response Result\nStatus Code : ${response.request},\nStatus Code : ${response.statusCode},\nBody : ${response.body}");
    int status = response.statusCode;
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return HttpResult(
        isSuccess: true,
        status: status,
        result: json.decode(utf8.decode(response.bodyBytes)),
      );
    } else if (response.statusCode == 401) {
      RxBus.post("", tag: "CLOSED_USER");
      return HttpResult(
        isSuccess: false,
        status: status,
        result: "Server error",
      );
    } else if (response.statusCode == 500 || response.statusCode == 404) {
      return HttpResult(
        isSuccess: false,
        status: status,
        result: json.decode(utf8.decode(response.bodyBytes)),
      );
    } else {
      try {
        var result = json.decode(utf8.decode(response.bodyBytes));
        return HttpResult(
          isSuccess: false,
          status: status,
          result: result,
        );
      } catch (_) {
        return HttpResult(
          isSuccess: false,
          status: status,
          result: json.decode(utf8.decode(response.bodyBytes)),
        );
      }
    }
  }

  ///Header
  static Future<Map<String, String>> _header() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    if (token == null) {
      return {
        "Accept": "application/json",
        'content-type': 'application/json; charset=utf-8',
      };
    } else {
      return {
        "Accept": "application/json",
        'content-type': 'application/json; charset=utf-8',
        "Authorization": "Bearer $token"
      };
    }
  }

  ///yandex
  Future<HttpResult> addressToLocation(String address) async {
    String key = Utils.yandexSearchKey;
    return _getRequest(
      "https://search-maps.yandex.ru/v1/?text=$address&type=geo&lang=uz&apikey=$key",
    );
  }

  Future<HttpResult> sendFirebaseToken(
    String token,
    String deviceId,
    String deviceName,
  ) async {
    var data = {
      "token": token,
      "device_id": deviceId,
      "device_name": deviceName,
      "platform": Platform.isIOS ? "IOS" : "Android",
    };
    return _postRequest(
      "${baseUrl}profile/firebase-token",
      data,
    );
  }

  ///login post request email va password bodyda yuboriladi
  Future<HttpResult> login(String email, String password) async {
    var data = {
      "email": email,
      "password": password,
    };
    return _postRequest(
      baseUrl + "login",
      data,
    );
  }

  ///reset password post request phone number va sms code bodyda yuboriladi
  Future<HttpResult> resetCode(String number, String code) async {
    var data = {
      "phone_number": number,
      "code": code,
    };
    return _postRequest(
      "${baseUrl}code",
      data,
    );
  }

  Future<HttpResult> verifyEmail(String code) async {
    var data = {
      "code": code,
    };
    return _postRequest(
      "${baseUrl}account/verification/email",
      data,
    );
  }

  ///register email name phone number pass va pass confirm bodyda yuboriladi
  Future<HttpResult> register(String name, String email, String phoneNumber,
      String password, String confirm) async {
    var data = {
      "name": name,
      "email": email,
      "phone_number": phoneNumber,
      "password": password,
      "password_confirmation": confirm,
    };
    return _postRequest(
      "${baseUrl}register",
      data,
    );
  }

  ///hamma categorylarni olish
  Future<HttpResult> allCategory() async {
    return _getRequest(
      baseUrl + "categories-parent",
    );
  }

  ///hamma categorylarni olish
  Future<HttpResult> getUserTasks(int userId, int status) async {
    return _getRequest(
      baseUrl + "performer-tasks?user_id=$userId&status=$status",
    );
  }

  ///hamma notificationlarni olish
  Future<HttpResult> allNotification() async {
    return _getRequest(
      baseUrl + "notifications",
    );
  }

  Future<HttpResult> getNotificationsCount() async {
    return _getRequest(
      baseUrl + "count/notifications",
    );
  }

  /// review  qoldirish
  Future<HttpResult> sendReview(
      int status, int like, String description, int id) async {
    var data = {
      "status": status,
      "good": like,
      "comment": description,
    };
    return _postRequest(
      baseUrl + "send-review-user/$id",
      data,
    );
  }

  ///reset passwordda passwordni yangilash
  Future<HttpResult> resetPassword(
      String number, String pass1, String pass2) async {
    var data = {
      "phone_number": number,
      "password": pass1,
      "password_confirmation": pass2,
    };
    return await _postRequest(
      baseUrl + "reset/password",
      data,
    );
  }

  ///notificationni oqilgan deb belgilash
  Future<HttpResult> allNotificationId(int id) async {
    return _postRequest(baseUrl + "read-notification/$id", []);
  }

  ///barcha notificationni oqilgan deb belgilash
  Future<HttpResult> readAllNotifications() async {
    return _postRequest(baseUrl + "read-all-notification", []);
  }

  ///chat malumotlarini olish
  Future<HttpResult> allChat() async {
    return _getRequest(
      baseUrl + "chat/getContacts",
    );
  }

  ///select peformer
  Future<HttpResult> selectPerform(int id) {
    var data = {};
    return _postRequest(
      baseUrl + "select-performer/$id",
      data,
    );
  }

  ///all chat search
  Future<HttpResult> allChatSearch(String search) async {
    return _getRequest(
      baseUrl + "chat/search?name=$search",
    );
  }

  ///all chat message
  Future<HttpResult> allChatMessage(int id) async {
    var data = {"id": id.toString()};
    return _postRequest(
      baseUrl + "chat/fetchMessages",
      data,
    );
  }

  ///send chat message
  Future<HttpResult> allChatSendMessage(int id, String msg) async {
    var data = {
      "id": id.toString(),
      "message": msg,
    };
    return _postRequest(
      baseUrl + "chat/sendMessage",
      data,
    );
  }

  ///change language
  Future<HttpResult> changeLanguage(String lang, String version) async {
    String url = baseUrl + "profile/settings/change-lang";
    var body = {
      "lang": lang,
      "version": version,
    };
    return await _postRequest(url, body);
  }

  ///send chat image
  Future<HttpResult> allChatSendImage(int id, String file) async {
    String url = baseUrl + 'chat/sendMessage';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(await _header());
    request.fields['id'] = id.toString();
    request.files.add(
      await http.MultipartFile.fromPath("file", file),
    );

    var response = await request.send();
    http.Response responseData = await http.Response.fromStream(response);
    return _result(responseData);
  }

  ///all sub category
  Future<HttpResult> allSubCategory(int id) async {
    return _getRequest(
      baseUrl + "category/search?parent_id=$id",
    );
  }

  ///reset password
  Future<HttpResult> reset(String number) async {
    var data = {
      "phone_number": number,
    };
    return await _postRequest(
      baseUrl + "reset",
      data,
    );
  }

  ///reset password
  Future<HttpResult> blockUser(int id) async {
    var data = {
      "blocked_user_id": id,
    };
    return await _postRequest(
      baseUrl + "profile/block-user",
      data,
    );
  }

  ///delete chat
  Future<HttpResult> chatDelete(int id) async {
    var data = {
      "deleted": 1,
    };
    return await _postRequest(
      baseUrl + "chat/deleteConversation?id=$id",
      data,
    );
  }

  ///all performers
  Future<HttpResult> allPerformers(bool online, int page) async {
    return await _getRequest(
      baseUrl +
          (online
              ? "performers/?online=1&page=$page"
              : "performers/?page=$page"),
    );
  }

  Future<HttpResult> getPerformers(String search, String category,
      PerformersFilterModel filter, bool online, int page) async {
    return await _getRequest(baseUrl +
        "performers-filter?" +
        getFilterUrl(search, filter, category) +
        "page=$page");
  }

  String getFilterUrl(
      String search, PerformersFilterModel filter, String category) {
    String url = "";
    if (search.trim() != "") {
      url += "search=$search&";
    }
    if (category.trim() != "") {
      url += "child_categories=$category&";
    }
    if (filter.online) {
      url += "online=true&";
    }
    if (filter.alphabet) {
      url += "alphabet=true&";
    }
    if (filter.review) {
      url += "review=true&";
    }
    if (filter.desc) {
      url += "desc=true&";
    }
    if (filter.asc) {
      url += "asc=true&";
    }
    url.replaceRange(url.length - 1, url.length - 1, "");
    return url;
  }

  ///get  performers count
  Future<HttpResult> getPerformCount(int id) async {
    return await _getRequest(baseUrl + "performers-count/$id");
  }

  Future<HttpResult> getPerformImage(int id) async {
    return await _getRequest(baseUrl + "performers-image/$id");
  }

  ///get all tasks
  Future<HttpResult> getTask(
    String category,
    String categoryChild,
    String budget,
    String isRemote,
    String withoutResponse,
    String long,
    String lat,
    String difference,
    String search,
    int page,
  ) async {
    if (difference == "150") {
      difference = "0";
    }
    String categoryParam = category == "" ? "" : "&categories=$category";
    String categoryChildParam =
        categoryChild == "" ? "" : "&categories=$categoryChild";
    String budgetParam = budget == "" ? "" : "&budget=$budget";
    String isRemoteParam = isRemote == "" ? "" : "&is_remote=true";
    String longParam = long == "" || long == "0.0" ? "" : "&long=$long";
    String latParam = lat == "" || lat == "0.0" ? "" : "&lat=$lat";
    String differenceParam =
        difference == "0" || difference == "" ? "" : "&difference=$difference";
    String searchParam = search == "" ? "" : "&s=$search";
    String withoutResponseParam =
        withoutResponse == "" ? "" : "&without_response=true";
    return _getRequest(
      baseUrl +
          "tasks-filter?"
              "page=$page"
              "$categoryParam"
              "$categoryChildParam"
              "$budgetParam"
              "$isRemoteParam"
              "$longParam"
              "$latParam"
              "$differenceParam"
              "$searchParam"
              "$withoutResponseParam",
    );
  }

  ///get info task
  Future<HttpResult> getInfoTask(int id) async {
    return _getRequest(
      baseUrl + "task/$id",
    );
  }

  ///get all categories childs
  Future<HttpResult> getAllCategoriesChilds() async {
    return _getRequest(
      baseUrl + "all-categories-childs",
    );
  }

  ///get support number
  Future<HttpResult> getSupportNumber() async {
    return _getRequest(
      baseUrl + "settings/admin.support_number",
    );
  }

  ///get all settings
  Future<HttpResult> getAllSettings() async {
    return _getRequest(
      baseUrl + "settings/get-all",
    );
  }

  ///get app version
  Future<HttpResult> getAppVersion() async {
    return _getRequest(
      baseUrl + "settings/admin.last_version",
    );
  }

  ///get same tasks
  Future<HttpResult> getSameTasks(int id) async {
    return _getRequest(
      baseUrl + "same-tasks/$id",
    );
  }

  ///get otklik By Id
  Future<HttpResult> getOtklikById(int id, String filter, int page) async {
    return _getRequest(
      baseUrl + "responses/$id?page=$page&filter=$filter",
    );
  }

  ///get my task count
  Future<HttpResult> getMyTaskCount(int id) async {
    return _getRequest(
      baseUrl + "my-tasks-count?is_performer=$id",
    );
  }

  ///get my tasks
  Future<HttpResult> getMyTasks(int status, int performer, int page) async {
    return _getRequest(
      baseUrl + "my-tasks?is_performer=$performer&status=$status&page=$page",
    );
  }

  Future<HttpResult> getAllTasksById(int id) async {
    return _getRequest(
      baseUrl + "all-tasks?user_id=$id",
    );
  }

  Future<HttpResult> getCategoryById(int id) async {
    return _getRequest(baseUrl + "categories/$id");
  }

  ///get my tasks
  Future<HttpResult> getProfile(int id) async {
    return _getRequest(
      baseUrl + (id == -1 ? "profile" : "profile/$id"),
    );
  }

  Future<HttpResult> testRequest() async {
    return _getRequest(
      devUrl + "profile/1",
    );
  }

  ///get my tasks
  Future<HttpResult> getStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("accessToken") ?? "";
    if (token != "") {
      return _getRequest(
        baseUrl + "complain/types",
      );
    } else {
      return HttpResult(
        isSuccess: true,
        result: "result",
        status: 1,
      );
    }
  }

  ///jaloba bildirish
  Future<HttpResult> jaloba(int typeId, int taskId, String text) async {
    var data = {
      "compliance_type_id": typeId,
      "text": text,
    };
    return _postRequest(
      baseUrl + "task/$taskId/complain",
      data,
    );
  }

  ///get settings data
  Future<HttpResult> getSettingsData() async {
    return _getRequest(
      baseUrl + "profile/settings",
    );
  }

  ///get settings data
  Future<HttpResult> getVerify(String type, String number) async {
    return _getRequest(
      baseUrl + "account/verify?type=$type&data=$number",
    );
  }

  ///sms code
  Future<HttpResult> verifySms(String sms) async {
    var data = {
      "code": sms,
    };
    return _postRequest(
      baseUrl + "account/verification/phone",
      data,
    );
  }

  ///change photo
  Future<HttpResult> changeImage(XFile image, String url) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          baseUrl + url,
        ),
      );
      request.headers.addAll(await _header());
      request.files.add(
        await http.MultipartFile.fromPath("avatar", image.path),
      );
      var response = await request.send();
      http.Response responseData =
          await http.Response.fromStream(response).timeout(durationTimeout);

      return _result(responseData);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: "Internet error",
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: "Internet error",
      );
    }
  }

  ///update settings data
  Future<HttpResult> updateSettings(String email, int age, String location,
      int gender, DateTime bornDate, String name) async {
    var data = {
      "email": email,
      "age": age,
      "location": location,
      "gender": gender,
      "born_date": "${bornDate.year}-${bornDate.month}-${bornDate.day}",
      "name": name,
    };

    return _postRequest(
      baseUrl + "profile/settings/update",
      data,
    );
  }

  ///change password
  Future<HttpResult> changePassword(
      String oldPassword, String password, String passwordConfirmation) {
    var data = {
      "old_password": oldPassword,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
    return _postRequest(
      baseUrl + "profile/settings/password/change",
      data,
    );
  }

  ///change status
  Future<HttpResult> changeStatus(int id) {
    var data = {
      "task_id": id,
    };
    return _postRequest(
      baseUrl + "task-status-update/$id",
      data,
    );
  }

  ///change status task
  Future<HttpResult> changeTaskStatus(int id) {
    var data = {};
    return _postRequest(
      baseUrl + "user/$id",
      data,
    );
  }

  ///otklik api
  Future<HttpResult> otklik(
      int id, String price, String description, int free) {
    var data = {
      "description": description,
      "price": price,
      "not_free": free,
    };

    return _postRequest(
      baseUrl + "task/$id/response",
      data,
    );
  }

  ///otklik api
  Future<HttpResult> getTaskInfo(int id) {
    return _getRequest(
      baseUrl + "task/$id",
    );
  }

  ///give tasks
  Future<HttpResult> giveTask(int perform, int task) async {
    var data = {
      "task_id": task,
      "performer_id": perform,
    };

    return _postRequest(
      baseUrl + "give-task",
      data,
    );
  }

  ///logout api
  Future<HttpResult> logout(String device) async {
    var data = {
      "device_id": device,
    };
    return _postRequest(
      baseUrl + "logout",
      data,
    );
  }

  /// create name
  Future<HttpResult> createName(
    String name,
    int categoryId,
    TaskModel? taskModel,
  ) {
    var data = {
      "name": name,
      "category_id": categoryId.toString(),
    };
    String url = taskModel == null
        ? baseUrl + "create-task/name"
        : baseUrl + "update-task/${taskModel.id}/name";
    return _postRequest(
      url,
      data,
    );
  }

  /// create custom
  Future<HttpResult> createCustom(
    List<CreateRouteCustomField> customFields,
    int taskId,
    TaskModel? taskModel,
  ) {
    Map<String, dynamic> data = {
      "task_id": taskId.toString(),
    };
    for (int i = 0; i < customFields.length; i++) {
      if (customFields[i].type == "number") {
        try {
          int number = int.parse(customFields[i].userValue);
          List<int> info = [number];
          data[customFields[i].name] = info;
        } catch (_) {
          List<String> stringList = [customFields[i].userValue];
          data[customFields[i].name] = stringList;
        }
      } else {
        List<String> stringList = [];
        if (customFields[i].type == "checkbox") {
          for (int j = 0; j < customFields[i].options.length; j++) {
            if (customFields[i].options[j].selected) {
              stringList.add(customFields[i].options[j].id.toString());
            }
          }
        } else {
          if (customFields[i].type == "select" ||
              customFields[i].type == "radio") {
            for (int j = 0; j < customFields[i].options.length; j++) {
              if (customFields[i].options[j].value.toString() ==
                  customFields[i].userValue.toString()) {
                customFields[i].userValue =
                    customFields[i].options[j].id.toString();
              }
            }
          }

          stringList = [customFields[i].userValue];
        }

        data[customFields[i].name] = stringList;
      }
    }
    String url = taskModel == null
        ? baseUrl + "create-task/custom"
        : baseUrl + "update-task/${taskModel.id}/custom";
    return _postRequest(
      url,
      data,
    );
  }

  /// create remote
  Future<HttpResult> createRemote(
    String radio,
    int taskId,
    TaskModel? taskModel,
  ) {
    var data = {
      "radio": radio,
      "task_id": taskId.toString(),
    };
    String url = taskModel == null
        ? baseUrl + "create-task/remote"
        : baseUrl + 'update-task/${taskModel.id}/remote';
    return _postRequest(
      url,
      data,
    );
  }

  ///news api
  Future<HttpResult> getNews() async {
    return _getRequest(
      baseUrl + "blog-news",
    );
  }

  ///get news detail
  Future<HttpResult> getNewsDt(int id) async {
    return _getRequest(
      baseUrl + "blog-news/$id",
    );
  }

  ///get support admin
  Future<HttpResult> getSupport() async {
    return _getRequest(
      baseUrl + "support-admin",
    );
  }

  ///active session
  Future<HttpResult> activeSession() async {
    return _getRequest(
      baseUrl + "profile/sessions",
    );
  }

  ///delete session
  Future<HttpResult> deleteSession(String session) async {
    var body = {
      "session_id": session,
    };
    return _postRequest(baseUrl + "profile/clear-sessions", body);
  }

  /// create address
  Future<HttpResult> createAddress(
    SendAddressModel data,
    TaskModel? taskModel,
  ) async {
    String url = taskModel == null
        ? baseUrl + "create-task/address"
        : baseUrl + 'update-task/${taskModel.id}/address';
    return await _postRequest(
      url,
      data,
    );
  }

  ///not complete
  Future<HttpResult> notComplete(String reason, int id) async {
    var data = {
      "reason": reason,
    };
    return await _postRequest(baseUrl + "tasks/$id/not-complete", data);
  }

  /// create date
  Future<HttpResult> createDate(
    String startDate,
    String endDate,
    int dateType,
    int taskId,
    TaskModel? taskModel,
  ) {
    var data = {
      "start_date": startDate,
      "end_date": endDate,
      "date_type": dateType.toString(),
      "task_id": taskId.toString(),
    };
    String url = taskModel == null
        ? baseUrl + "create-task/date"
        : baseUrl + 'update-task/${taskModel.id}/date';
    return _postRequest(
      url,
      data,
    );
  }

  /// create budget
  Future<HttpResult> createBudget(
    int amount,
    int budgetType,
    int taskId,
    TaskModel? taskModel,
  ) {
    var data = {
      "amount": amount.toString(),
      "budget_type": budgetType.toString(),
      "task_id": taskId.toString(),
    };
    String url = taskModel == null
        ? baseUrl + "create-task/budget"
        : baseUrl + "update-task/${taskModel.id}/budget";
    return _postRequest(
      url,
      data,
    );
  }

  /// create notes
  Future<HttpResult> createNotes(
    String description,
    String docs,
    int taskId,
    List<String> images,
    TaskModel? taskModel,
  ) async {
    var data = {
      "description": description,
      "docs": docs,
      "task_id": taskId.toString(),
    };
    if (images.isNotEmpty) {
      await uploadImage(
        images,
        taskId,
        taskModel,
      );
    }
    String url = taskModel == null
        ? baseUrl + "create-task/note"
        : baseUrl + 'update-task/${taskModel.id}/note';
    return _postRequest(
      url,
      data,
    );
  }

  ///create taskda image upload qilish
  Future<HttpResult> uploadImage(
    List<String> images,
    int taskId,
    TaskModel? taskModel,
  ) async {
    String url = taskModel == null
        ? baseUrl + 'create-task/images'
        : baseUrl + "update-task/${taskModel.id}/images";

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(await _header());
    request.fields['task_id'] = taskId.toString();
    for (int i = 0; i < images.length; i++) {
      request.files.add(
        await http.MultipartFile.fromPath("images[]", images[i]),
      );
    }
    var response = await request.send();
    http.Response responseData = await http.Response.fromStream(response);
    return _result(responseData);
  }

  /// create number
  Future<HttpResult> createNumber(
    String phoneNumber,
    int taskId,
    TaskModel? taskModel,
  ) {
    var data = {
      "phone_number": phoneNumber,
      "task_id": taskModel == null ? taskId.toString() : taskModel.id,
    };
    String url = taskModel == null
        ? baseUrl + "create-task/contacts"
        : baseUrl + 'update-task/${taskModel.id}/contacts';
    return _postRequest(
      url,
      data,
    );
  }

  /// create number verification
  Future<HttpResult> createNumberVerification(
    String phoneNumber,
    String smsOtp,
    String taskId, {
    bool update = false,
  }) async {
    var data = {
      "phone_number": phoneNumber,
      "task_id": taskId,
      "sms_otp": smsOtp,
    };
    return await _postRequest(
      baseUrl + (update ? "update-task/$taskId/verify" : "create-task/verify"),
      data,
    );
  }

  /// delete task
  Future<HttpResult> deleteTask(int id, int userId) {
    return _delete(baseUrl + "delete-task/$id/$userId");
  }

  ///delete portfolio
  Future<HttpResult> deletePortfolio(int id) {
    return _delete(
      baseUrl + "profile/portfolio/$id/delete",
    );
  }

  Future<HttpResult> deleteTemplate(int id) {
    return _delete(
      baseUrl + "profile/response-template/delete/$id",
    );
  }

  ///set view task
  Future<HttpResult> setView(int id) {
    return _getRequest(baseUrl + "task/$id");
  }

  ///delete user
  Future<HttpResult> deleteUSer() {
    return _getRequest(baseUrl + "profile/self-delete");
  }

  Future<HttpResult> popularCategory(String search) {
    return _getRequest(baseUrl + "popular-categories?category=$search");
  }

  ///get balance
  Future<HttpResult> getBalance(
      int type, int page, DateTime startTime, DateTime endTime) {
    return _getRequest(baseUrl +
        "profile/balance?type=${type == 0 ? "" : type == 1 ? "in" : "out"}&"
            "&from=${Utils.balanceDateForServerFormat(startTime)}&to=${Utils.balanceDateForServerFormat(endTime)}"
            "page=$page");
  }

  ///initial data
  Future<HttpResult> initialData(String name, String location, String born) {
    var data = {
      "name": name,
      "location": location,
      "born_date": born,
    };
    return _postRequest(
      baseUrl + "become-performer",
      data,
    );
  }

  ///post email and phone
  Future<HttpResult> postEmail(String email, String phone) {
    var data = {
      "email": email,
      "phone_number": phone,
    };
    return _postRequest(
      baseUrl + "become-performer-phone",
      data,
    );
  }

  ///change category
  Future<HttpResult> changeCategory(
    int sms,
    int email,
    List<int> category,
  ) async {
    var data = {
      "sms_notification": sms,
      "email_notification": email,
      "category": category,
    };
    return _postRequest(
      baseUrl + "profile/categories-subscribe",
      data,
    );
  }

  ///post category id
  Future<HttpResult> postCategoryId(String id) {
    var data = {
      "category_id": id,
    };
    return _postRequest(
      baseUrl + "become-performer-category",
      data,
    );
  }

  ///notification turn on and off
  Future<HttpResult> notification(int change) {
    var data = {
      "notification": change,
    };
    return _postRequest(
      baseUrl + "profile/settings/notifications",
      data,
    );
  }

  Future<HttpResult> setNotification(String notificationOff, bool notifTime,
      DateTime notificationFrom, DateTime notificationTo) {
    var data = {
      "notification_off": notificationOff,
      "notification_from": notifTime != false
          ? Utils.notificationForServerFormat(notificationFrom)
          : null,
      "notification_to": notifTime != false
          ? Utils.notificationForServerFormat(notificationTo)
          : null,
    };
    return _postRequest(
      baseUrl + "profile/notification-off",
      data,
    );
  }

  ///get all portfolio
  Future<HttpResult> getPortfolio(int user) async {
    return _getRequest(
      baseUrl +
          (user == -1 ? "profile/portfolios" : "profile/$user/portfolios"),
    );
  }

  Future<HttpResult> getResponseTemplate() async {
    return _getRequest(
      baseUrl + "profile/response-template",
    );
  }

  Future<HttpResult> getBlockedUsersList() async {
    return _getRequest(
      baseUrl + "profile/block-user-list",
    );
  }

  Future<HttpResult> getFaqGuides() async {
    return _getRequest(
      baseUrl + "faq",
    );
  }

  Future<HttpResult> getFaqGuideById(int id) async {
    return _getRequest(
      baseUrl + "faq/$id",
    );
  }

  ///edit description
  Future<HttpResult> editDescription(String text) async {
    var data = {
      "description": text,
    };
    return _postRequest(
      baseUrl + "profile/description/edit",
      data,
    );
  }

  Future<HttpResult> createTemplate(String title, String text) async {
    var data = {
      "title": title,
      "text": text,
    };
    return _postRequest(
      baseUrl + "profile/response-template/create",
      data,
    );
  }

  Future<HttpResult> editTemplate(int id, String title, String text) async {
    var data = {
      "title": title,
      "text": text,
    };
    return _postRequest(
      baseUrl + "profile/response-template/edit/$id",
      data,
    );
  }

  Future<HttpResult> editExparience(int text) async {
    var data = {
      "work_experience": text,
    };
    return _postRequest(
      baseUrl + "profile/work-experience",
      data,
    );
  }

  ///edit description
  Future<HttpResult> addLink(String text) async {
    var data = {
      "link": text,
    };
    return _postRequest(
      baseUrl + "profile/video",
      data,
    );
  }

  ///google and facebook login and register
  Future<HttpResult> loginSocial(String type, String token) async {
    var data = {
      "type": type,
      "access_token": token,
    };

    return _postRequest(
      baseUrl + "social-login",
      data,
    );
  }

  ///edit phone number
  Future<HttpResult> editPhone(String text) async {
    var data = {
      "phone_number": text,
    };
    return _postRequest(
      baseUrl + "profile/settings/phone/edit",
      data,
    );
  }

  ///edit phone number
  Future<HttpResult> getReviews(int perform, int user, String review) async {
    String link = "";

    if (user == -1) {
      if (review == "") {
        link = "profile/reviews?performer=$perform";
      } else {
        link = "profile/reviews?performer=$perform&review=$review";
      }
    } else {
      if (review == "") {
        link = "profile/$user/reviews?performer=$perform";
      } else {
        link = "profile/$user/reviews?performer=$perform&review=$review";
      }
    }
    return _getRequest(baseUrl + link);
  }

  ///otemit task
  Future<HttpResult> otmenitTask(int id) async {
    var data = {};
    String url = baseUrl + "cancel-task/$id";
    return _postRequest(url, data);
  }

  ///delete video
  Future<HttpResult> deleteVideo() async {
    return _delete(baseUrl + "profile/video/delete");
  }

  ///delete post code
  Future<HttpResult> deletePostCode(String code) async {
    var body = {
      "code": code,
    };
    return _postRequest(baseUrl + "profile/confirmation-self-delete", body);
  }

  ///report user
  Future<HttpResult> reportUser(int id, String msg) async {
    var body = {
      "reported_user_id": id,
      "message": msg,
    };
    return _postRequest(baseUrl + "profile/report-user", body);
  }

  ///portfolio image delete
  Future<HttpResult> deleteImage(int id, String name) async {
    var data = {
      "image": name,
    };
    return _postRequest(baseUrl + "update-task/$id/delete-image", data);
  }

  Future<HttpResult> deletePortImg(int id, String name) async {
    var data = {
      "image": name,
    };
    return _postRequest(baseUrl + "profile/portfolio/$id/delete-image", data);
  }

  ///create portfolio
  Future<HttpResult> createPortfolio(
      List<XFile> image, String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    Dio dio = Dio();
    List<MultipartFile> ins = [];

    for (int i = 0; i < image.length; i++) {
      var mini =
          lookupMimeType(image[i].path, headerBytes: [0xFF, 0xD8])!.split('/');
      ins.add(await MultipartFile.fromFile(image[i].path,
          contentType: MediaType(mini[0], mini[1])));
    }

    FormData formData = FormData.fromMap({
      "images[]": ins,
      "comment": title,
      "description": content,
    });
    try {
      var response = await dio.post(
        baseUrl + "profile/portfolio/create",
        data: formData,
        options: Options(
          method: 'POST',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'content-Type': 'application/json'
          },
        ),
      );

      int status = response.statusCode!;
      HttpResult data = HttpResult(
        isSuccess: true,
        result: response.data,
        status: status,
      );
      return data;
    } catch (_) {}
    return HttpResult(isSuccess: false, result: formData, status: 1);
  }

  ///update portfolio
  Future<HttpResult> updatePortfolio(
      int id, List<XFile> image, String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    Dio dio = Dio();
    List<MultipartFile> ins = [];

    for (int i = 0; i < image.length; i++) {
      var mini =
          lookupMimeType(image[i].path, headerBytes: [0xFF, 0xD8])!.split('/');
      ins.add(await MultipartFile.fromFile(image[i].path,
          contentType: MediaType(mini[0], mini[1])));
    }
    FormData formData = FormData.fromMap(
      {
        "images[]": ins,
        "comment": title,
        "description": content,
      },
    );

    var response = await dio.post(
      baseUrl + "profile/portfolio/$id/update",
      data: formData,
      options: Options(
        method: 'POST',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'content-Type': 'application/json'
        },
      ),
    );

    int status = response.statusCode!;
    HttpResult data = HttpResult(
      isSuccess: true,
      result: response.data,
      status: status,
    );
    return data;
  }

  Future<HttpResult> createFavoriteTask(int id) async {
    String url = baseUrl + "favorite-task/create?task_id=$id";
    return await _postRequest(url, null);
  }

  Future<HttpResult> deleteFavoriteTask(int id) async {
    return _delete(baseUrl + "favorite-task/delete/$id");
  }

  Future<HttpResult> getAllFavoriteTask(int page) async {
    return _getRequest(baseUrl + "favorite-task?page=$page");
  }
}
