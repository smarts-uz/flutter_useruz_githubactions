// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/verify_screen.dart';
import 'package:youdu/src/utils/phone_number_formatter.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/auth/auth_text_field_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class PageTwo extends StatefulWidget {
  final Function() onTap;

  const PageTwo({super.key, required this.onTap});

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Repository repository = Repository();
  final PhoneNumberTextInputFormatter _phoneNumber =
      PhoneNumberTextInputFormatter();
  bool loading = false, color = false;
  String? error, errorMsg;

  @override
  void initState() {
    super.initState();
    getData();
    emailController.addListener(() {
      errorMsg = null;
      setState(() {});
    });
    phoneController.addListener(() {
      error = null;
      if (phoneController.text.length >= 12) {
        color = true;
        setState(() {});
      } else {
        color = false;
        setState(() {});
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("performers.two.title1"),
              style: AppTypography.pSmallRegularDark33SemiBold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("performers.two.title2"),
              style: AppTypography.pTiny215ProDark33,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: TextField(
              controller: phoneController,
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
                  borderSide: BorderSide(color: AppColors.dark33),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.dark33,
                  ),
                ),
                prefixText: "+998 ",
                errorText: error,
                labelText: translate("auth.form_number"),
                labelStyle: AppTypography.pSmall3,
              ),
            ),
          ),
          AuthTextFieldWidget(
            controller: emailController,
            text: translate("more.email"),
            error: errorMsg,
          ),
        ],
      ),
      floatingActionButton: YellowButton(
        text: translate("profile.next"),
        color: color ? AppColors.yellow16 : AppColors.dark00.withOpacity(0.5),
        onTap: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          if (EmailValidator.validate(emailController.text) &&
              phoneController.text.replaceAll(" ", "").length == 9) {
            loading = true;
            setState(() {});

            HttpResult response = await repository.postEmail(
              emailController.text,
              "+998" + phoneController.text.replaceAll(" ", ""),
            );

            if (response.isSuccess) {
              if (response.result["success"] == "true") {
                await repository.getVerify(
                  "phone_number",
                  "+998" + phoneController.text.replaceAll(" ", ""),
                );
                loading = false;
                setState(() {});
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return VerifyScreen(
                      number: "+998" + phoneController.text.replaceAll(" ", ""),
                      scope: true,
                      end: () async {
                        Navigator.pop(context);
                        widget.onTap();
                      },
                      retry: () async {
                        HttpResult response = await repository.postEmail(
                          emailController.text,
                          "+998" + phoneController.text.replaceAll(" ", ""),
                        );
                        if (response.status == -1) {
                          CenterDialog.networkErrorDialog(context);
                        } else {
                          CenterDialog.errorDialog(
                            context,
                            Utils.serverErrorText(response),
                            response.result.toString(),
                          );
                        }
                      },
                    );
                  },
                );
              } else {
                loading = false;
                setState(() {});
                CenterDialog.errorDialog(
                  context,
                  Utils.serverErrorText(response),
                  response.result.toString(),
                );
              }
              loading = false;
              setState(() {});
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
          } else {
            if (phoneController.text.replaceAll(" ", "").length == 9) {
              errorMsg = translate("email_msg");
            } else {
              error = "";
            }
            setState(() {});
          }
        },
        loading: loading,
        margin: EdgeInsets.only(
          left: 48,
          right: 16,
          bottom: Platform.isIOS ? 24 : 16,
        ),
      ),
    );
  }

  getData() async {
    String ph = "";
    SharedPreferences pref = await SharedPreferences.getInstance();
    emailController.text = pref.getString("email") ?? "";
    if (pref.getString('number')!.trim() != "") {
      ph = pref
          .getString("number")!
          .substring(4, pref.getString("number")!.length);
      phoneController.text = ph.substring(0, 2) +
          " " +
          ph.substring(2, 5) +
          " " +
          ph.substring(5, 7) +
          " " +
          ph.substring(7, 9);
    }

    if (phoneController.text.length >= 12) {
      color = true;
    }
    setState(() {});
  }
}
