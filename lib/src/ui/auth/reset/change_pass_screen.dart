// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/auth/entrance_screen/entrance_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/app_bar_title.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/auth/auth_text_field_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class ChangePassScreen extends StatefulWidget {
  final String number;

  const ChangePassScreen({super.key, required this.number});

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final Repository repository = Repository();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool view = false;

  bool loading = false;

  String? error1;
  String? error2;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackWidget(),
        title: AppBarTitle(
          text: translate("settings.change_password"),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 24,
          ),
          AuthTextFieldWidget(
            controller: _passwordController,
            text: translate("settings.new_password"),
            isPassword: true,
            error: error1,
          ),
          AuthTextFieldWidget(
            controller: _passwordConfirmController,
            text: translate("settings.confirm_password"),
            isPassword: true,
            error: error2,
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate("settings.password_rules"),
                  style: AppTypography.h3,
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Colors.black,
                        size: 5,
                      ),
                      Text(
                        translate("settings.password_rule1"),
                        style: AppTypography.guideStyle,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Colors.black,
                        size: 5,
                      ),
                      Text(
                        translate("settings.password_rule2"),
                        style: AppTypography.guideStyle,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Colors.black,
                        size: 5,
                      ),
                      Text(
                        translate("settings.password_rule3"),
                        style: AppTypography.guideStyle,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Colors.black,
                        size: 5,
                      ),
                      Text(
                        translate("settings.password_rule4"),
                        style: AppTypography.guideStyle,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: YellowButton(
        margin: const EdgeInsets.only(right: 16, left: 48),
        loading: loading,
        text: translate("auth.save"),
        onTap: () async {
          Utils.close(context);
          error1 = Utils.correct(_passwordController.text);
          //error2 = Utils.correct(_passwordConfirmController.text);
          if (_passwordController.text != _passwordConfirmController.text) {
            error2 = translate("error_one");
          }
          if (error1 == null && error2 == null) {
            setState(() {
              loading = true;
            });
            HttpResult response = await repository.resetPassword(
              widget.number,
              _passwordController.text,
              _passwordConfirmController.text,
            );
            setState(() {
              loading = false;
            });
            if (response.isSuccess) {
              _passwordConfirmController.text = "";
              _passwordController.text = "";
              if (response.isSuccess && response.result["success"] == true) {
                // CenterDialog.messageDialog(
                //   context,
                //   response.result["data"]["message"].toString(),
                //   () {},
                // );
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntranceScreen(),
                  ),
                );
              } else {
                CenterDialog.errorDialog(
                  context,
                  response.result["message"].toString(),
                  response.result["message"].toString(),
                );
              }
            } else {
              CenterDialog.errorDialog(
                context,
                response.result["message"].toString(),
                response.result["message"].toString(),
              );
            }
          } else {
            setState(() {});
          }
        },
      ),
    );
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    view = prefs.getBool("password") ?? false;
    setState(() {});
  }
}
