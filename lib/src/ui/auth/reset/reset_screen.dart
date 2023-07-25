// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/auth/reset/check_screen.dart';
import 'package:youdu/src/utils/phone_number_formatter.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool loading = false;
  Repository repository = Repository();
  final PhoneNumberTextInputFormatter _phoneNumber =
      PhoneNumberTextInputFormatter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        leading: const BackWidget(),
        centerTitle: true,
        title: Text(
          translate("pass_title"),
          style: AppTypography.pDark33SemiBold,
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child: Text(
              translate("auth.reset_title"),
              style: AppTypography.h2SmallDark33SemiBold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate("create_task.number_info"),
                  style: AppTypography.pSmall3.copyWith(height: 1.3),
                ),
                Row(
                  children: [
                    const Text(
                      "+ 998 ",
                      style: AppTypography.pSmallRegular,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.send,
                        maxLength: 12,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _phoneNumber,
                        ],
                        style: AppTypography.pSmallRegular,
                        decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 1,
                  color: AppColors.greyE9,
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: YellowButton(
        text: translate("auth.send_msg"),
        loading: loading,
        onTap: () async {
          String number =
              _emailController.text.replaceAll(" ", "").replaceAll("+", "");
          loading = true;
          setState(() {});
          HttpResult response = await repository.reset("998$number");
          loading = false;
          setState(() {});
          if (response.isSuccess && response.result["success"] == true) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return CheckScreen(
                  number: "+998${_emailController.text.replaceAll(" ", "")}",
                  end: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
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
        },
        margin: const EdgeInsets.only(
          left: 48,
        ),
      ),
    );
  }
}
