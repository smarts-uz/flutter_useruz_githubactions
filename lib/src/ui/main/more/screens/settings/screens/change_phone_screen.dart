// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/verify_screen.dart';
import 'package:youdu/src/utils/phone_number_formatter.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/app_bar_title.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class ChangePhoneScreen extends StatefulWidget {
  final String phone;

  const ChangePhoneScreen({super.key, required this.phone});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final TextEditingController _controller = TextEditingController();
  Repository repository = Repository();
  final PhoneNumberTextInputFormatter _phoneNumber =
      PhoneNumberTextInputFormatter();
  bool loading = false, color = false;

  @override
  void initState() {
    super.initState();

    _controller.text = widget.phone.length > 10
        ? widget.phone
            .substring(widget.phone.length == 13 ? 4 : 3, widget.phone.length)
        : "";
    if (widget.phone.length > 10) {
      _controller.text = _controller.text.substring(0, 2) +
          " " +
          _controller.text.substring(2, 5) +
          " " +
          _controller.text.substring(5, 7) +
          " " +
          _controller.text.substring(7, 9);
    }
    if (_controller.text.length >= 12) {
      color = true;
      setState(() {});
    }
    _controller.addListener(() {
      if (_controller.text.length >= 12) {
        color = true;
        setState(() {});
      } else {
        color = false;
        setState(() {});
      }
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
          text: translate("more.number_phone"),
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
              translate("more.phone_title"),
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
                errorStyle: AppTypography.pSmallRedB5,
                labelText: translate("auth.form_number"),
                labelStyle: AppTypography.pSmall3,
              ),
            ),
          ),
          const Spacer(),
          YellowButton(
            margin: const EdgeInsets.only(right: 16, left: 16),
            loading: loading,
            color:
                color ? AppColors.yellow16 : AppColors.dark00.withOpacity(0.5),
            text: translate("more.save"),
            onTap: () async {
              if (_controller.text.length >= 12) {
                setState(() {
                  loading = true;
                });
                HttpResult response = await repository.getVerify(
                  "phone_number",
                  "+998" + _controller.text.replaceAll(" ", ""),
                );
                setState(() {
                  loading = false;
                });
                if (response.isSuccess && response.result["success"]) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return VerifyScreen(
                        number: "+998" + _controller.text.replaceAll(" ", ""),
                        end: () async {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        retry: () async {
                          HttpResult response = await repository.getVerify(
                            "phone_number",
                            "+998" + _controller.text.replaceAll(" ", ""),
                          );
                          if (!response.isSuccess) {
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
          ),
          const SizedBox(
            height: 56,
          ),
        ],
      ),
    );
  }
}
