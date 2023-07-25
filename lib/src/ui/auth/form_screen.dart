// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/database/security_storage.dart';
import 'package:youdu/src/model/api_model/auth/login_model.dart';
import 'package:youdu/src/model/api_model/auth/registration_error_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/security/set_new_pin_code_screen.dart';
import 'package:youdu/src/utils/phone_number_formatter.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/auth/auth_text_field_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final PhoneNumberTextInputFormatter _phoneNumber =
      PhoneNumberTextInputFormatter();
  Repository repository = Repository();
  List<String?> error = [
    null,
    null,
    null,
  ];
  String? error1, error2, errorName, errorPhone, errorEmail;
  bool circle = false;

  @override
  void initState() {
    _fullNameController.addListener(() {
      errorName = null;
      setState(() {});
    });
    _passwordConfirmController.addListener(() {
      error[0] = null;
      error[1] = null;
      error[2] = null;
      error2 = null;
      error1 = null;
      setState(() {});
    });
    _passwordController.addListener(() {
      error[0] = null;
      error[1] = null;
      error[2] = null;
      error1 = null;
      error2 = null;
      setState(() {});
    });
    _emailController.addListener(() {
      error[0] = null;
      error[1] = null;
      error[2] = null;
      errorEmail = null;
      setState(() {});
    });
    _numberController.addListener(() {
      error[0] = null;
      error[1] = null;
      error[2] = null;
      errorPhone = null;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: SvgPicture.asset(AppAssets.back),
            ),
          ),
        ),
        title: Text(
          translate("auth.registration"),
          style: AppTypography.pSmall1,
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColors.greyE9,
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Text(
                    translate("auth.form"),
                    style: AppTypography.h2Small,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: TextField(
                    controller: _fullNameController,
                    maxLength: 70,
                    keyboardType: TextInputType.text,
                    style: AppTypography.pSmall3Dark33,
                    cursorColor: AppColors.greyAD,
                    decoration: InputDecoration(
                      counterText: "",
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.dark33,
                        ),
                      ),
                      errorText: errorName,
                      labelText: translate("auth.full_name"),
                      labelStyle: AppTypography.pSmall3,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: TextField(
                    controller: _numberController,
                    maxLength: 12,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _phoneNumber,
                    ],
                    style: AppTypography.pSmall3Dark33,
                    cursorColor: AppColors.greyAD,
                    decoration: InputDecoration(
                      counterText: "",
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.dark33,
                        ),
                      ),
                      prefixText: "+998 ",
                      errorText: errorPhone,
                      errorStyle: AppTypography.pSmallRedB5,
                      labelText: translate("auth.form_number"),
                      labelStyle: AppTypography.pSmall3,
                    ),
                  ),
                ),
                AuthTextFieldWidget(
                  controller: _emailController,
                  text: translate("auth.form_email"),
                  error: errorEmail,
                ),
                AuthTextFieldWidget(
                  controller: _passwordController,
                  text: translate("auth.password"),
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  isPassword: true,
                  error: error1,
                ),
                AuthTextFieldWidget(
                  controller: _passwordConfirmController,
                  text: translate("auth.confirm_password"),
                  isPassword: true,
                  error: error2,
                ),
                SizedBox(
                  height: Platform.isIOS ? 24 : 16,
                ),
              ],
            ),
          ),
          YellowButton(
            loading: circle,
            onTap: () async {
              error2 = Utils.correct(_passwordConfirmController.text);
              error1 = Utils.correct(_passwordController.text);
              if (_passwordController.text != _passwordConfirmController.text) {
                error2 = translate("error_one");
              }
              if (_fullNameController.text.isEmpty) {
                errorName = translate("empty_text");
              }
              if (_numberController.text.length != 12) {
                errorPhone = translate("empty_text");
              }
              if (!EmailValidator.validate(_emailController.text.trim())) {
                errorEmail = translate("email_msg");
              }
              if (error1 == null &&
                  error2 == null &&
                  errorName == null &&
                  errorEmail == null &&
                  errorPhone == null) {
                circle = true;
                setState(() {});
                HttpResult response = await repository.register(
                  _fullNameController.text,
                  _emailController.text.trim(),
                  "+998" + _numberController.text.replaceAll(" ", ""),
                  _passwordController.text,
                  _passwordConfirmController.text,
                );
                if (response.isSuccess) {
                  LoginModel data = LoginModel.fromJson(
                    response.result,
                  );
                  if (data.accessToken != "") {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("accessToken", data.accessToken);
                    prefs.setString("number", _numberController.text);
                    prefs.setBool("login_main", true);
                    prefs.setString("name", data.user.name);
                    prefs.setInt("balance", 0);
                    prefs.setInt("id", data.user.id);
                    prefs.setInt("roleId", 5);
                    prefs.setString("number", data.user.phoneNumber);
                    prefs.setString("email", data.user.email);
                    prefs.setBool("login_main", true);
                    prefs.setBool("password", data.socialpas);
                    prefs.setBool("email_verified", false);
                    prefs.setBool("phone_verified", false);
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SecurityStorage.instance.isFirstTime
                              ? const SetNewPincodeScreen()
                              : const MainScreen();
                        },
                      ),
                    );
                  } else {
                    RegistrationErrorModel errorData =
                        RegistrationErrorModel.fromJson(
                      response.result,
                    );
                    error[0] = errorData.errors.phoneNumber;
                    error[1] = errorData.errors.email;
                    error[2] = errorData.errors.password;
                    setState(() {});
                    CenterDialog.errorDialog(
                      context,
                      response.result["messages"].toString(),
                      response.result.toString(),
                    );
                  }
                } else if (response.status == -1) {
                  CenterDialog.networkErrorDialog(context);
                } else {
                  CenterDialog.errorDialog(
                    context,
                    Utils.serverErrorText(response),
                    response.result.toString(),
                  );
                }
                setState(() {
                  circle = false;
                });
              } else {
                setState(() {});
              }
            },
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: Platform.isIOS ? 24 : 16,
            ),
            text: translate("auth.save"),
          ),
        ],
      ),
    );
  }
}
