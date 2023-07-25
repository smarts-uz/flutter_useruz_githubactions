// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/profile_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/database/clear_storage.dart';
import 'package:youdu/src/model/api_model/profile/profile_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/auth/entrance_screen/entrance_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/active_session_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/change_password_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/delete_user_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/language_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/notifications_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/security_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/settings_data_screen.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/more/settings/settings.dart';
import 'package:youdu/src/widget/shimmer/settings_screen_shimmer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool value = true;
  bool tap = false;
  String phone = "";
  Repository repository = Repository();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bool _loading = false;

  @override
  void initState() {
    super.initState();
    profileBloc.getProfile(-1, context);
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.transparent,
            child: SvgPicture.asset(AppAssets.back),
          ),
        ),
        title: Container(
          color: Colors.transparent,
          child: Text(
            translate("settings.setting"),
            style: AppTypography.pSmallRegularDark33Bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              CenterDialog.selectDialog(
                context,
                translate("settings.logout"),
                (value) async {
                  if (value) {
                    if (mounted) {
                      setState(() {
                        tap = true;
                      });
                    }
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String deviceId = prefs.getString("deviceId") ?? "";
                    if (deviceId == "") {
                      deviceId = await FlutterUdid.udid;
                      prefs.setString("deviceId", deviceId);
                    }
                    HttpResult response = await repository.logout(deviceId);
                    if (mounted) {
                      setState(() {
                        tap = false;
                      });
                    }
                    if (response.isSuccess) {
                      String lang = LanguagePerformers.getLanguage();
                      prefs.clear();
                      ClearStorage.instance.clearStorage();
                      LanguagePerformers.saveLanguage(lang);
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const EntranceScreen();
                          },
                        ),
                      );
                    } else {
                      if (response.status == -1) {
                        CenterDialog.networkErrorDialog(context);
                      } else {
                        CenterDialog.errorDialog(
                          context,
                          Utils.serverErrorText(response),
                          response.result.toString(),
                        );
                      }
                    }
                  }
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              color: Colors.transparent,
              child: SvgPicture.asset(AppAssets.exit),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          StreamBuilder<ProfileModel>(
            stream: profileBloc.profileInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ProfileModel data = snapshot.data!;
                return Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 22,
                        ),
                        SettingsWidget(
                          icon: AppAssets.profileIcon,
                          title: translate("more.personal_info"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SettingsDataScreens(),
                              ),
                            );
                          },
                        ),
                        SettingsWidget(
                          icon: AppAssets.security,
                          title: translate("settings.security"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SecurityScreen(),
                              ),
                            );
                          },
                        ),
                        SettingsWidget(
                          icon: AppAssets.close,
                          title: translate("settings.change_password"),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const ChangePasswordScreen(),
                              ),
                            );
                          },
                        ),
                        SettingsWidget(
                          icon: AppAssets.seans,
                          title: translate("session.title"),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const ActiveSessionScreen(),
                              ),
                            );
                          },
                        ),
                        SettingsWidget(
                          icon: AppAssets.globus,
                          title: translate("settings.change_language"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LanguageScreen(),
                              ),
                            );
                          },
                        ),
                        SettingsWidget(
                            icon: AppAssets.notification,
                            title: translate("settings.notifications"),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NotificationsScreens(
                                        data: data,
                                      )));
                            }),
                        const SizedBox(height: 8),
                        phone == ""
                            ? Container()
                            : SettingsWidget(
                                icon: AppAssets.deleteUser,
                                title: translate("delete_user"),
                                color: AppColors.red5B,
                                txtColor: AppColors.red5B,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DeleteUser(),
                                    ),
                                  );
                                },
                              ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Platform.isAndroid
                                  ? Utils.androidVersion
                                  : Utils.iosVersion,
                              style: AppTypography.pSmall3Dark00,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        )
                      ],
                    ),
                    tap
                        ? Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: AppColors.dark00.withOpacity(0.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 72,
                                  width: 72,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: AppColors.white,
                                  ),
                                  child:
                                      const CircularProgressIndicator.adaptive(
                                    strokeWidth: 65,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                );
              } else {
                return const SettingsScreenShimmer();
              }
            },
          ),
          !_loading
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.dark00.withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 56,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator.adaptive(
                              backgroundColor: AppColors.dark00,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              translate("loading"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    value = prefs.getBool("notification_settings") ?? true;
    phone = prefs.getString("number") ?? "";
    setState(() {});
  }
}
