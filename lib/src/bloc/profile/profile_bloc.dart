// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/model/api_model/profile/profile_model.dart';
import 'package:youdu/src/model/api_model/profile/settings_data_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../utils/rx_bus.dart';
import '../../widget/dialog/center_dialog.dart';

class ProfileBloc {
  final Repository repository = Repository();

  final _profileFetch = PublishSubject<ProfileModel>();
  final _profileUserFetch = PublishSubject<ProfileModel>();
  final _settingsFetch = PublishSubject<SettingsDataModel>();

  Stream<ProfileModel> get profileInfo => _profileFetch.stream;

  Stream<ProfileModel> get profileInfoUser => _profileUserFetch.stream;

  Stream<SettingsDataModel> get settingsData => _settingsFetch.stream;

  Future<bool> getProfile(int id, BuildContext context) async {
    // try {
    HttpResult response = await repository.getProfile(id);
    HttpResult responseC = await Repository().allCategory();
    List<CategoryModel> categoryGlobal = [];
    if (responseC.isSuccess) {
      List<CategoryModel> data =
          AllCategoryModel.fromJson(responseC.result).data;
      categoryGlobal = data;
      for (int i = 0; i < categoryGlobal.length; i++) {
        categoryGlobal[i].selectedItem = false;
      }
    }

    if (response.isSuccess) {
      ProfileModel data = ProfileModel.fromJson(
        response.result,
      );
      if (id == -1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString("number") == "" ||
            prefs.getString("number") != data.data.phoneNumber) {
          prefs.setString("number", data.data.phoneNumber);
        }
      }
      List<CategoryModel> category = data.data.categories;
      for (int i = 0; i < category.length; i++) {
        for (int j = 0; j < categoryGlobal.length; j++) {
          if (categoryGlobal[j].id == category[i].parentId) {
            categoryGlobal[j].chooseItem.add(category[i]);
          }
        }
      }
      data.data.categories = categoryGlobal;
      if (id == -1) {
        postData(data.data.avatar, data.data.name, data.data.walletBalance);
        _profileFetch.sink.add(data);
      } else {
        _profileUserFetch.sink.add(data);
      }
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getProfile(id, context);
        });
      }
    }
    return true;
    // } catch (e) {
    //   if (kDebugMode) {
    //     print(e);
    //   }
    // }
  }

  postData(String image, String name, int balance) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("image", image);
    preferences.setString("name", name);
    preferences.setInt("balance", balance);
    RxBus.post("_controller.text", tag: "CHANGE_IMAGE_NAME");
  }

  getSettingsData(BuildContext context) async {
    HttpResult response = await repository.getSettingsData();
    if (response.isSuccess) {
      SettingsDataModel data = SettingsDataModel.fromJson(
        response.result,
      );
      _settingsFetch.sink.add(data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getSettingsData(context);
        });
      }
    }
  }
}

final profileBloc = ProfileBloc();
