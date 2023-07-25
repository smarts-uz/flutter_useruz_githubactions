// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/auth/reset/check_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/app_bar_title.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class ChangeEmailScreen extends StatefulWidget {
  final String email;

  const ChangeEmailScreen({super.key, required this.email});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final TextEditingController _controller = TextEditingController();
  Repository repository = Repository();
  bool loading = false;
  String? error;
  bool isConfirmed = false;

  @override
  void initState() {
    super.initState();

    _controller.text = widget.email;

    _controller.addListener(() {
      error = null;
      setState(() {});
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackWidget(),
        title: AppBarTitle(
          text: translate("more.email"),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("more.email_question"),
              style: AppTypography.h2SmallDark00Medium,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("more.email_title"),
              style: const TextStyle(
                fontFamily: AppTypography.fontFamilyProduct,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                fontSize: 13,
                height: 18 / 13,
                color: AppColors.dark00,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.text,
              style: AppTypography.pSmall3Dark33,
              cursorColor: AppColors.greyAD,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.dark33),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.dark33,
                  ),
                ),
                errorText: error,
                errorStyle: AppTypography.pSmallRedB5,
                labelText: translate("more.email"),
                labelStyle: AppTypography.pSmall3,
              ),
            ),
          ),
          const Spacer(),
          YellowButton(
            margin: const EdgeInsets.only(right: 16, left: 16),
            loading: loading,
            text: translate("more.save"),
            color: widget.email == _controller.text
                ? AppColors.greyD6
                : AppColors.yellow16,
            onTap: widget.email == _controller.text
                ? () {}
                : () async {
                    if (EmailValidator.validate(_controller.text)) {
                      setState(() {
                        loading = true;
                      });
                      HttpResult response = await repository.getVerify(
                        "email",
                        _controller.text,
                      );
                      setState(() {
                        loading = false;
                      });
                      if (response.isSuccess && response.result["success"]) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          isDismissible: false,
                          builder: (context) {
                            return CheckScreen(
                              number: _controller.text.replaceAll(" ", ""),
                              isEmail: true,
                              end: () {
                                // Navigator.pop(context);
                                // Navigator.pop(context);
                              },
                            );
                          },
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
                    } else {
                      error = translate("email_msg");
                      setState(() {});
                    }
                  },
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
