// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/create_task/create/create_main_screen.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class CancelProductWidget extends StatelessWidget {
  final TaskModel data;

  const CancelProductWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: Platform.isIOS ? 24 : 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (data.responsesCount == 0) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        content: Text(
                          translate("delete_title"),
                          style: AppTypography.h3Small2,
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () async {
                              HttpResult response =
                                  await Repository().otmenitTask(data.id);
                              if (response.isSuccess) {
                                Navigator.pop(context);
                                RxBus.post("", tag: "SEARCH_TASK_EVENT");
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              } else {
                                Navigator.pop(context);
                                CenterDialog.errorDialog(
                                  context,
                                  Utils.serverErrorText(response),
                                  response.result.toString(),
                                );
                              }
                            },
                            child: Container(
                              height: 44,
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  translate("delete"),
                                  style: AppTypography.pTiny2BoldRed,
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
                                  style: AppTypography.pTiny2BoldBlue,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(
                    color: AppColors.greyD6,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    translate("my_task.cancel"),
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamilyProxima,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.red5B,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              if (data.responsesCount == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateMainScreen(
                      categoryId: data.categoryId,
                      categoryName: data.categoryName,
                      taskModel: data,
                      name: data.categoryName,
                      edit: true,
                    ),
                  ),
                );
              }
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.blue91,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: SvgPicture.asset(AppAssets.edit),
              ),
            ),
          )
        ],
      ),
    );
  }
}
