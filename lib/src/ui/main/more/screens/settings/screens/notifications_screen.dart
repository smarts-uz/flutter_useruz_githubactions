// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/api_provider.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/profile_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/profile/profile_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/ui/main/performers/filter/filter_provider/performers_provider.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/lib/flutter_datetime_picker.dart';
import 'package:youdu/src/utils/lib/src/i18n_model.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/app_bar_title.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/more/settings/settings.dart';

class NotificationsScreens extends StatefulWidget {
  const NotificationsScreens({super.key, required this.data});
  final ProfileModel data;

  @override
  State<NotificationsScreens> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreens> {
  bool loading = false;
  String deviceId = "";
  bool value = false;
  bool timeValue = false;
  bool newsValue = false;
  bool tap = false;
  DateTime startTime = DateTime.parse("2023-02-27T23:00:00Z");
  DateTime endTime = DateTime.parse("2023-02-27T08:00:00Z");
  String language = "";

  @override
  void initState() {
    profileBloc.getProfile(-1, context);
    value = widget.data.data.notificationOff == "1" ? true : false;
    timeValue = widget.data.data.notificationFrom != "" ? true : false;
    newsValue = widget.data.data.newsNotification == "1" ? true : false;
    if (widget.data.data.notificationFrom != "") {
      startTime =
          DateTime.parse("2023-02-27T${widget.data.data.notificationFrom}Z");
      endTime =
          DateTime.parse("2023-02-27T${widget.data.data.notificationTo}Z");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PerformersFilterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        leading: const BackWidget(),
        title: AppBarTitle(
          text: translate("settings.notifications"),
          textStyle: AppTypography.pSmallRegularDark33Bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsWidget(
                  title: translate("settings.notification"),
                  icCheck: true,
                  value: newsValue,
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool("notification_settings", !newsValue);
                    tap = true;
                    setState(() {});
                    HttpResult response =
                        await Repository().notification(newsValue ? 0 : 1);
                    tap = false;
                    setState(() {});
                    if (response.isSuccess &&
                        response.result["success"] == true) {
                      newsValue = !newsValue;
                      setState(() {});
                      CenterDialog.messageDialog(
                        context,
                        response.result['data']["message"].toString(),
                        () {},
                      );
                    }
                    if (response.status == -1) {
                      CenterDialog.networkErrorDialog(context);
                    } else if (response.result["success"] == false) {
                      CenterDialog.errorDialog(
                        context,
                        Utils.serverErrorText(response),
                        response.result.toString(),
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    translate("settings.dont_disturb"),
                    style: AppTypography.h2SmallDark33SemiBold.copyWith(
                      color: AppColors.dark00,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    translate("settings.dont_disturb_text"),
                    style: const TextStyle(
                      color: AppColors.grey84,
                      fontFamily: AppTypography.fontFamilyProxima,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SettingsWidget(
              title: translate("settings.dont_disturb"),
              icCheck: true,
              value: value,
              onTap: () async {
                value = !value;
                setState(() {});
              },
            ),
            const SizedBox(
              height: 24,
            ),
            SettingsWidget(
              title: translate("settings.dont_disturb_time"),
              icCheck: true,
              value: timeValue,
              onTap: !value
                  ? () {}
                  : () async {
                      timeValue = !timeValue;
                      setState(() {});
                    },
            ),
            const SizedBox(
              height: 16,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              child: Visibility(
                visible: timeValue,
                child: SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            DatePicker.showTimePicker(
                              context,
                              showTitleActions: true,
                              showSecondsColumn: false,
                              onConfirm: (date) {
                                startTime = date;
                                setState(() {});
                              },
                              currentTime: startTime,
                              locale: (LanguagePerformers.getLanguage() == "ru")
                                  ? LocaleType.ru
                                  : LocaleType.uz,
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            translate("profile.from"),
                                            style: AppTypography.pSmall3Grey84_,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            Utils.notificationTimeFormat(
                                                startTime),
                                            style: AppTypography.pDark33H,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(left: 16),
                                color: AppColors.greyE9,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            DatePicker.showTimePicker(
                              context,
                              showTitleActions: true,
                              showSecondsColumn: false,
                              onConfirm: (date) {
                                endTime = date;
                                setState(() {});
                              },
                              currentTime: endTime,
                              locale: (LanguagePerformers.getLanguage() == "ru")
                                  ? LocaleType.ru
                                  : LocaleType.uz,
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          translate("profile.to"),
                                          style: AppTypography.h1,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          Utils.notificationTimeFormat(endTime),
                                          style: AppTypography.pDark33H,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(right: 16),
                                color: AppColors.greyE9,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 20,
              color: AppColors.greyFB,
              width: double.infinity,
            ),
            SettingsWidget(
              icon: AppAssets.allTask,
              title: translate("profile.change_to_dev"),
              icCheck: true,
              value: provider.devServer,
              onTap: () async {
                CenterDialog.selectDialog(
                  context,
                  translate("profile.change_to_dev_dialog"),
                  (callBack) async {
                    if (callBack) {
                      loading = true;
                      setState(() {});
                      HttpResult response =
                          await ApiProvider().testRequest().then((value) {
                        loading = false;
                        setState(() {});
                        return value;
                      });
                      if (response.status != -1) {
                        provider.updateDevServer(!provider.devServer);
                        ApiProvider.setToDev(provider.devServer);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const MainScreen(),
                          ),
                        );
                      } else {
                        CenterDialog.networkErrorDialog(context);
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: YellowButton(
        loading: loading,
        text: translate("profile.save"),
        margin: const EdgeInsets.fromLTRB(32, 16, 0, 16),
        onTap: () async {
          tap = true;
          loading = true;
          setState(() {});
          HttpResult response = await Repository().setNotification(
            !value ? "0" : "1",
            timeValue,
            startTime,
            endTime,
          );
          tap = false;
          loading = false;
          setState(() {});
          if (response.isSuccess && response.result["success"] == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool("notification_settings", !value);
            profileBloc.getProfile(-1, context).then((value) {});
            setState(() {});
            CenterDialog.messageDialog(
              context,
              response.result["message"].toString(),
              () {},
            );
          }
          if (response.status == -1) {
            CenterDialog.networkErrorDialog(context);
          } else if (response.result["success"] == false) {
            CenterDialog.errorDialog(
              context,
              Utils.serverErrorText(response),
              response.result.toString(),
            );
          }
        },
      ),
    );
  }
}
