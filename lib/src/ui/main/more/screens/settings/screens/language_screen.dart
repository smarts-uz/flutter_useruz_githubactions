// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/app_bar_title.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int click = 1;
  bool loading = false;
  int oldClick = 1;

  @override
  void initState() {
    super.initState();
    getLanguage();
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
          text: translate("language.title"),
          textStyle: AppTypography.pSmallRegularDark33Bold,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              for (int i = 1; i <= 2; i++)
                GestureDetector(
                  onTap: () {
                    click = i;
                    setState(() {});
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              i == 1 ? "Русский" : "O'zbekcha",
                              style: AppTypography.pSmallRegularDark33,
                            ),
                            const Spacer(),
                            Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                color: click == i
                                    ? AppColors.yellow00
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  width: 2,
                                  color: click == i
                                      ? AppColors.yellow00
                                      : AppColors.greyD6,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: AppColors.white,
                                size: 16,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: AppColors.greyE9,
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
          !loading
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
      floatingActionButton: YellowButton(
        text: translate("more.save"),
        color: oldClick == click ? AppColors.greyD6 : AppColors.yellow16,
        onTap: oldClick == click
            ? () {}
            : () async {
                loading = true;
                setState(() {});
                HttpResult response = await Repository().changeLanguage(
                    click == 1 ? "ru" : "uz", Utils.currentVersion);
                loading = false;
                setState(() {});
                if (response.isSuccess) {
                  var localizationDelegate = LocalizedApp.of(context).delegate;
                  localizationDelegate
                      .changeLocale(Locale(click == 1 ? "ru" : "uz"));
                  LanguagePerformers.saveLanguage(click == 1 ? "ru" : "uz");
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                  );
                } else {
                  CenterDialog.errorDialog(
                    context,
                    Utils.serverErrorText(response),
                    response.result.toString(),
                  );
                }
              },
        margin: EdgeInsets.only(
          left: 48,
          right: 16,
          bottom: Platform.isIOS ? 24 : 16,
        ),
      ),
    );
  }

  getLanguage() async {
    String lang = LanguagePerformers.getLanguage();
    if (lang == "ru") {
      click = 1;
    } else {
      click = 2;
    }
    oldClick = click;
    setState(() {});
  }
}
