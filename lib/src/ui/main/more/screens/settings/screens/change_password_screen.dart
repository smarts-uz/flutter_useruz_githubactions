// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/app_bar_title.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/auth/auth_text_field_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final Repository repository = Repository();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? error1;
  String? error2;
  String? error3;

  bool view = false;
  bool loading = false;

  // final TextStyle _guideStyle = TextStyle(
  //   color: AppColors.dark33.withOpacity(.8),
  //   fontFamily: AppTypography.fontFamilyProduct,
  //   fontSize: 16,
  //   fontWeight: FontWeight.w400,
  // );

  @override
  void initState() {
    getData();
    _oldPasswordController.addListener(() {
      error1 = null;
      setState(() {});
    });
    _passwordController.addListener(() {
      error2 = null;
      setState(() {});
    });
    _passwordConfirmController.addListener(() {
      error3 = null;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        leading: const BackWidget(),
        title: AppBarTitle(
          text: translate("settings.change_password"),
          textStyle: AppTypography.pSmallRegularDark33Bold,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 24,
          ),
          view
              ? AuthTextFieldWidget(
                  controller: _oldPasswordController,
                  text: translate("settings.old_password"),
                  isPassword: true,
                  error: error1,
                  onSubmitted: () {
                    error1 = Utils.correct(_oldPasswordController.text);
                    setState(() {});
                  },
                )
              : Container(),
          AuthTextFieldWidget(
            controller: _passwordController,
            text: translate("settings.new_password"),
            isPassword: true,
            error: error2,
            onSubmitted: (value) {
              error2 = Utils.correct(value);
              setState(() {});
            },
          ),
          AuthTextFieldWidget(
            controller: _passwordConfirmController,
            text: translate("settings.confirm_password"),
            isPassword: true,
            error: error3,
            onSubmitted: (String value) {
              if (value != _passwordController.text) {
                error3 = translate("error_one");
                setState(() {});
              } else {
                error3 = null;
                setState(() {});
              }
            },
          ),
          const SizedBox(
            height: 24,
          ),
          // const SizedBox(
          //   height: 100,
          // ),

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
              ))
        ],
      ),
      floatingActionButton: YellowButton(
        margin: const EdgeInsets.only(right: 16, left: 48),
        loading: loading,
        text: translate("more.save"),
        color: _oldPasswordController.text.trim() == ""
            ? _passwordController.text.trim() == ""
                ? _passwordConfirmController.text.trim() == ""
                    ? AppColors.greyD6
                    : AppColors.yellow16
                : AppColors.yellow16
            : AppColors.yellow16,
        onTap: _oldPasswordController.text.trim() == ""
            ? _passwordController.text.trim() == ""
                ? _passwordConfirmController.text.trim() == ""
                    ? () {}
                    : updatePassword
                : updatePassword
            : updatePassword,
      ),
    );
  }

  updatePassword() async {
    Utils.close(context);
    error1 = Utils.correct(_oldPasswordController.text);
    error2 = Utils.correct(_passwordController.text);
    error3 = Utils.correct(_passwordConfirmController.text);
    if (_passwordController.text != _passwordConfirmController.text) {
      error3 = translate("error_one");
    }
    if (error2 == null && error3 == null) {
      setState(() {
        loading = true;
      });
      HttpResult response = await repository.changePassword(
        _oldPasswordController.text,
        _passwordController.text,
        _passwordConfirmController.text,
      );
      setState(() {
        loading = false;
      });
      if (response.isSuccess) {
        if (response.isSuccess && response.result["status"] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("password", true);
          CenterDialog.messageDialog(
            context,
            response.result["message"].toString(),
            () {
              Navigator.pop(context);
            },
          );
        } else {
          CenterDialog.messageDialog(
            context,
            response.result["message"].toString(),
            () {},
          );
        }
      } else {
        CenterDialog.messageDialog(
          context,
          response.result["message"].toString(),
          () {},
        );
      }
    } else {
      setState(() {});
    }
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    view = prefs.getBool("password") ?? false;
    setState(() {});
  }
}
