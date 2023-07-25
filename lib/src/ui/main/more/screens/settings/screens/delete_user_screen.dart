// ignore_for_file: use_build_context_synchronously

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/widget/button/border_button.dart';

import '../../../../../../utils/utils.dart';
import '../../../../../../widget/app/app_bar_title.dart';
import '../../../../../../widget/app/back_widget.dart';
import '../../../../../../widget/dialog/center_dialog.dart';
import '../../../../../auth/reset/check_screen.dart';

class DeleteUser extends StatefulWidget {
  const DeleteUser({super.key});

  @override
  State<DeleteUser> createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  bool tap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackWidget(),
        title: AppBarTitle(
          text: translate("delete_user"),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 24),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: DottedBorder(
                    color: Colors.black.withOpacity(0.3),
                    strokeWidth: 4,
                    dashPattern: const [10, 5],
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate("delete_user_title"),
                          style: AppTypography.pSmallMedium.copyWith(
                            color: AppColors.dark00,
                          ),
                        ),
                        const SizedBox(
                          height: 36,
                        ),
                        Text(
                          "${translate("delete_user")}?",
                          style: AppTypography.pSmallMedium.copyWith(
                            color: AppColors.dark00,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              BorderButton(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        content: Text(
                          translate("delete_user"),
                          style: AppTypography.h3Small2,
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () async {
                              await Future.delayed(
                                const Duration(milliseconds: 500),
                                () async {
                                  tap = true;
                                  setState(() {});
                                  HttpResult response =
                                      await Repository().deleteUSer();

                                  tap = false;
                                  setState(() {});
                                  if (response.isSuccess) {
                                    Navigator.pop(context);
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) {
                                        return CheckScreen(
                                          number:
                                              response.result["phone_number"],
                                          delete: true,
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
                                },
                              );
                            },
                            child: Container(
                              height: 44,
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  translate("delete"),
                                  textAlign: TextAlign.center,
                                  style: AppTypography.pSmallRedBold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 44,
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  translate("cancel"),
                                  textAlign: TextAlign.center,
                                  style: AppTypography.pSmallBlueBold,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                text: translate("delete"),
                txtColor: AppColors.red5B,
              ),
              const SizedBox(
                height: 32,
              )
            ],
          ),
          tap
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.dark00.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 72,
                        width: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.white,
                        ),
                        child: const CircularProgressIndicator.adaptive(
                          strokeWidth: 65,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
