import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/auth/entrance_screen/entrance_screen_view_model.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/save_data.dart';
import 'package:youdu/src/widget/button/border_button.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';

class EntranceScreen extends StatefulWidget {
  final bool main;

  const EntranceScreen({super.key, this.main = false});

  @override
  State<EntranceScreen> createState() => _EntranceScreenState();
}

class _EntranceScreenState extends State<EntranceScreen> {
  final EntranceScreenViewModel viewModel = EntranceScreenViewModel();
  bool value = false;

  @override
  void initState() {
    SaveData.clearData(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLanguage(context);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          widget.main
              ? Container()
              : GestureDetector(
                  onTap: () => viewModel.skipEntranceScreen(context),
                  child: Text(translate("auth.skip"), style: AppTypography.p),
                ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        children: [
          widget.main
              ? Container()
              : SizedBox(
                  height: 8,
                  width: MediaQuery.of(context).size.width,
                ),
          Image.asset(
            AppAssets.appImage,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.main
                    ? Text(
                        translate("auth.login_skip"),
                        textAlign: TextAlign.center,
                        style: AppTypography.h2,
                      )
                    : LanguagePerformers.getLanguage() == 'ru'
                        ? viewModel.myWidget(
                            context,
                            translate("auth.entrance_title"),
                            " User.uz",
                          )
                        : viewModel.myWidget(
                            context,
                            " User.uz",
                            translate("auth.entrance_title"),
                          ),
                widget.main ? Container() : const SizedBox(height: 32),
                widget.main
                    ? Container()
                    : Text(
                        translate("auth.entrance_message"),
                        textAlign: TextAlign.center,
                        style: AppTypography.pSmall,
                      )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 32),
        child: Column(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Checkbox(
                  value: value,
                  checkColor: AppColors.white,
                  activeColor: AppColors.yellow00,
                  onChanged: (e) {
                    value = !value;
                    setState(() {});
                  },
                ),
                const SizedBox(width: 1),
                GestureDetector(
                  onTap: () => viewModel.openUZTermsWebScreen(context),
                  child: Text(
                    translate("privacy"),
                    style: AppTypography.p.copyWith(
                      color: LanguagePerformers.getLanguage() == "uz"
                          ? AppColors.blueFF
                          : AppColors.dark00,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => viewModel.openRUTermsWebScreen(context),
                  child: Text(
                    translate("privacy1"),
                    style: AppTypography.p.copyWith(
                      color: LanguagePerformers.getLanguage() == "ru"
                          ? AppColors.blueFF
                          : AppColors.dark00,
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 16),
            YellowButton(
              text: translate("auth.sign_up"),
              color: !value ? AppColors.greyD6 : AppColors.yellow16,
              onTap: () => viewModel.navigateToRegisterScreen(value, context),
            ),
            BorderButton(
              onTap: () => viewModel.navigateToLoginScreen(context),
              text: translate("auth.sign_in"),
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: Platform.isIOS ? 24 : 16,
              ),
              txtColor: AppColors.dark33,
            ),
          ],
        ),
      ),
    );
  }
}
