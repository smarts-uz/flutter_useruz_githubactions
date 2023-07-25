// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/active_session_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/profile/active_session_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/app_bar_title.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class ActiveSessionScreen extends StatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  bool loading = false;
  String deviceId = "";

  @override
  void initState() {
    getData();
    activeSessionBloc.allActiveSession(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        leading: const BackWidget(),
        title: AppBarTitle(
          text: translate("session.title"),
          textStyle: AppTypography.pSmallRegularDark33Bold,
        ),
      ),
      body: StreamBuilder<ActiveSessionModel>(
        stream: activeSessionBloc.getActiveSession,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ActiveSessionData> data = snapshot.data!.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Text(
                    translate("active_me"),
                    style: AppTypography.h3Small2.copyWith(
                      color: AppColors.dark00,
                    ),
                  ),
                ),
                for (int i = 0; i < data.length; i++)
                  if (deviceId == data[i].deviceId)
                    Container(
                      height: 84,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 15,
                              color: AppColors.dark00.withOpacity(.06),
                              offset: const Offset(1.0, 2))
                        ],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(
                        bottom: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            data[i].isMobile == 0
                                ? AppAssets.web
                                : data[i].platform == "IOS"
                                    ? AppAssets.apple1
                                    : AppAssets.android,
                            height: 26,
                            width: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data[i].isMobile == 1
                                      ? data[i].deviceName
                                      : data[i].userAgent,
                                  style: AppTypography.pSmall1SemiBold.copyWith(
                                    color: AppColors.dark00,
                                  ),
                                ),
                                Text(data[i].ipAddress),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                data.length < 2
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(
                          bottom: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Text(
                          translate("active_other"),
                          style: AppTypography.h3Small2.copyWith(
                            color: AppColors.dark00,
                          ),
                        ),
                      ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
                    itemBuilder: (context, index) {
                      return deviceId != data[index].deviceId
                          ? Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 15,
                                      color: AppColors.dark00.withOpacity(0.06),
                                      offset: const Offset(1.0, 2.0))
                                ],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(
                                bottom: 16,
                                left: 16,
                                right: 16,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    data[index].isMobile == 0
                                        ? AppAssets.web
                                        : data[index].platform == "IOS"
                                            ? AppAssets.apple1
                                            : AppAssets.android,
                                    height: 26,
                                    width: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[index].isMobile == 1
                                              ? data[index].deviceName
                                              : data[index].userAgent,
                                          style: AppTypography.pSmall1SemiBold
                                              .copyWith(
                                            color: AppColors.dark00,
                                          ),
                                        ),
                                        Text(data[index].ipAddress),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container();
                    },
                    itemCount: data.length,
                  ),
                ),
                YellowButton(
                  text: translate("session.delete"),
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  loading: loading,
                  onTap: () async {
                    String id = "";
                    for (int i = 0; i < data.length; i++) {
                      if (deviceId == data[i].deviceId) {
                        id = data[i].id;
                      }
                    }
                    loading = true;
                    setState(() {});
                    HttpResult response = await Repository().deleteSession(id);
                    loading = false;
                    setState(() {});
                    if (response.isSuccess &&
                        response.result["success"] == true) {
                      Navigator.pop(context);
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
                  },
                ),
                //: Container(),
                const SizedBox(
                  height: 32,
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceId = prefs.getString("deviceId") ?? "";
    setState(() {});
  }
}
