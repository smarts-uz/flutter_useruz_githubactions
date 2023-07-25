// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/dialog/bottom_dialog.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/lib/flutter_datetime_picker.dart';
import 'package:youdu/src/utils/lib/src/i18n_model.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/app_custom_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class CreateDateScreen extends StatefulWidget {
  final int taskId;
  final TaskModel? taskModel;
  final Function(String _route, int price) nextPage;

  const CreateDateScreen({
    super.key,
    required this.taskId,
    required this.nextPage,
    required this.taskModel,
  });

  @override
  State<CreateDateScreen> createState() => _CreateDateScreenState();
}

class _CreateDateScreenState extends State<CreateDateScreen>
    with AutomaticKeepAliveClientMixin<CreateDateScreen> {
  @override
  bool get wantKeepAlive => true;
  bool loading = false, isNext = false;
  int type = 3;
  String language = "";
  DateTime? startTime, endTime;

  @override
  void initState() {
    _insertData();
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("create_task.date_title"),
              style: AppTypography.h2SmallSemiBold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("create_task.date_label"),
              style: AppTypography.pTiny215GreyAD,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 12,
            width: double.infinity,
            color: const Color(0xFFFBFBFB),
          ),
          GestureDetector(
            onTap: () {
              BottomDialog.showBottomCalendarTypeDialog(
                context,
                type,
                (_type) {
                  type = _type;
                  _update();
                },
              );
            },
            child: Container(
              height: 56,
              color: Colors.transparent,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SvgPicture.asset(AppAssets.createCalendar),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      type == 1
                          ? translate("create_task.date_type_1")
                          : type == 2
                              ? translate("create_task.date_type_2")
                              : type == 3
                                  ? translate("create_task.date_type_3")
                                  : translate("create_task.date_type"),
                      style: AppTypography.pSmall3Dark33Medium,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SvgPicture.asset(AppAssets.arrowRight),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 12,
            width: double.infinity,
            color: const Color(0xFFFBFBFB),
          ),
          type == 0 || type == 2
              ? Container()
              : GestureDetector(
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now().add(const Duration(hours: 1)),
                      maxTime: DateTime(2119, 02, 16),
                      onConfirm: (date) {
                        startTime = date;
                        _update();
                      },
                      currentTime: startTime ??
                          DateTime.now().add(const Duration(hours: 1)),
                      locale:
                          (language == "ru") ? LocaleType.ru : LocaleType.uz,
                    );
                  },
                  child: Container(
                    height: 70,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                translate("create_task.date_start"),
                                style: AppTypography.pTiny215GreyADnh,
                              ),
                              const SizedBox(height: 5),
                              startTime == null
                                  ? Container()
                                  : Text(
                                      Utils.dateNameFormatCreateDate(
                                          startTime!),
                                      style: AppTypography.pSmallDark33Medium,
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        startTime == null
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  startTime = null;
                                  _update();
                                },
                                child: SvgPicture.asset(
                                  AppAssets.clearTextField,
                                ),
                              ),
                        startTime == null
                            ? Container()
                            : const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
          type == 0 || type == 2
              ? Container()
              : Container(
                  height: 1,
                  color: AppColors.greyE9,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
          type == 0 || type == 1
              ? Container()
              : GestureDetector(
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now().add(const Duration(hours: 3)),
                      maxTime: DateTime(2119, 02, 16),
                      onConfirm: (date) {
                        if (startTime == null || startTime!.isBefore(date)) {
                          endTime = date;
                          _update();
                        } else {
                          CenterDialog.errorDialog(
                            context,
                            translate("create_task.title"),
                            translate("create_task.title"),
                          );
                        }
                      },
                      currentTime: endTime ??
                          (startTime == null
                              ? DateTime.now().add(const Duration(hours: 3))
                              : startTime!.add(const Duration(hours: 3))),
                      locale: (LanguagePerformers.getLanguage() == "ru")
                          ? LocaleType.ru
                          : LocaleType.uz,
                    );
                  },
                  child: Container(
                    height: 70,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                translate("create_task.date_end"),
                                style: AppTypography.pSmall3,
                              ),
                              const SizedBox(height: 5),
                              endTime == null
                                  ? Container()
                                  : Text(
                                      Utils.dateNameFormatCreateDate(endTime!),
                                      style: AppTypography.pSmallDark33Medium,
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        endTime == null
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  endTime = null;
                                  _update();
                                },
                                child: SvgPicture.asset(
                                  AppAssets.clearTextField,
                                ),
                              ),
                        endTime == null
                            ? Container()
                            : const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
          type == 0 || type == 1
              ? Container()
              : Container(
                  height: 1,
                  color: AppColors.greyE9,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
          const Spacer(),
        ],
      ),
      floatingActionButton: AppCustomButton(
        loading: loading,
        color: isNext ? AppColors.yellow16 : AppColors.greyD6,
        margin: EdgeInsets.only(
          bottom: Platform.isIOS ? 32 : 24,
          left: 32,
        ),
        onTap: () {
          if (isNext) {
            String start =
                startTime == null ? "" : Utils.sendServerDataFormat(startTime!);
            String end =
                endTime == null ? "" : Utils.sendServerDataFormat(endTime!);
            sendData(start, end);
          }
        },
        title: translate("next"),
      ),
    );
  }

  _update() {
    if (type > 0) {
      if (type == 3) {
        if (startTime != null && endTime != null) {
          setState(() {
            isNext = true;
          });
        } else {
          setState(() {
            isNext = false;
          });
        }
      } else if (type == 1) {
        if (startTime != null) {
          setState(() {
            isNext = true;
          });
        } else {
          setState(() {
            isNext = false;
          });
        }
      } else if (type == 2) {
        if (endTime != null) {
          setState(() {
            isNext = true;
          });
        } else {
          setState(() {
            isNext = false;
          });
        }
      } else {
        setState(() {
          isNext = false;
        });
      }
    } else {
      setState(() {
        isNext = false;
      });
    }
  }

  Future<void> sendData(String start, String end) async {
    setState(() {
      loading = true;
    });
    HttpResult response = await createBloc.createDate(
      start,
      end,
      type,
      widget.taskId,
      widget.taskModel,
    );
    if (response.isSuccess) {
      CreateRouteModel data = CreateRouteModel.fromJson(response.result);
      if (data.success) {
        widget.nextPage(
          data.data.route,
          data.data.price,
        );
      } else {
        CenterDialog.errorDialog(
          context,
          Utils.serverErrorText(response),
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
      loading = false;
    });
  }

  void _insertData() {
    language = LanguagePerformers.getLanguage();
    setState(() {});
    if (widget.taskModel != null) {
      type = widget.taskModel!.dateType;
      startTime = widget.taskModel!.startDate;
      endTime = widget.taskModel!.endDate;
      isNext = true;
      setState(() {});
    }
  }
}
