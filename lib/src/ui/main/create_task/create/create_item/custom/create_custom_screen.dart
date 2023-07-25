// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/create_task/create/create_item/custom/checkbox_widget.dart';
import 'package:youdu/src/ui/main/create_task/create/create_item/custom/select_widget.dart';
import 'package:youdu/src/ui/main/create_task/create/create_item/custom/radio_widget.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/app_custom_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class CreateCustomScreen extends StatefulWidget {
  final TaskModel? taskModel;
  final Function(String _route, int address) nextPage;

  const CreateCustomScreen({super.key, required this.nextPage, this.taskModel});

  @override
  State<CreateCustomScreen> createState() => _CreateCustomScreenState();
}

class _CreateCustomScreenState extends State<CreateCustomScreen>
    with AutomaticKeepAliveClientMixin<CreateCustomScreen> {
  @override
  bool get wantKeepAlive => true;
  bool first = false;
  int taskId = 0;
  String language = "uz";
  List<CreateRouteCustomField> customFields = [];
  bool loading = false;
  List<String?> error = [];

  @override
  void initState() {
    _initBus();
    language = LanguagePerformers.getLanguage();
    setState(() {});
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        customFields[index].title,
                        style: AppTypography.pSmall3H,
                      ),
                      SizedBox(
                        child: customFields[index].type == "checkbox"
                            ? CheckBoxWidget(
                                options: customFields[index].options,
                                choose: (List<CustomFieldType> _options) {
                                  customFields[index].options = _options;
                                },
                              )
                            : customFields[index].type == "select"
                                ? SelectWidget(
                                    options: customFields[index].options,
                                    choose: (String _options) {
                                      customFields[index].userValue = _options;
                                    },
                                  )
                                : customFields[index].type == "radio"
                                    ? RadioWidget(
                                        options: customFields[index].options,
                                        choose: (String _options) {
                                          customFields[index].userValue =
                                              _options;
                                        },
                                      )
                                    : TextFormField(
                                        initialValue:
                                            customFields[index].taskValue,
                                        maxLength:
                                            customFields[index].dataType ==
                                                    "int"
                                                ? 9
                                                : 200,
                                        style: AppTypography.pSmall1P,
                                        onTapOutside: (event) {
                                          FocusScope.of(context).unfocus();
                                        },
                                        decoration: InputDecoration(
                                          counterText: "",
                                          labelText: customFields[index].label,
                                          errorText: error[index],
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: error[index] != null
                                                  ? AppColors.red5B
                                                  : AppColors.greyAD,
                                            ),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.yellow16,
                                            ),
                                          ),
                                          border: const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.green),
                                          ),
                                        ),
                                        onChanged: (_value) {
                                          error[index] = null;
                                          setState(() {});
                                          customFields[index].userValue =
                                              _value;
                                        },
                                        inputFormatters: customFields[index]
                                                    .regax !=
                                                ""
                                            ? [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        customFields[index]
                                                            .regax)),
                                              ]
                                            : customFields[index].dataType ==
                                                    "int"
                                                ? [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9]')),
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ]
                                                : [],
                                        keyboardType:
                                            customFields[index].dataType ==
                                                    "int"
                                                ? const TextInputType
                                                        .numberWithOptions(
                                                    decimal: true)
                                                : TextInputType.text,
                                      ),
                        width: MediaQuery.of(context).size.width - 32,
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
                itemCount: customFields.length,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom != 0 ? 120 : 0,
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: AppCustomButton(
          loading: loading,
          title: translate("next"),
          margin: EdgeInsets.only(
              top: 12, bottom: Platform.isIOS ? 32 : 24, left: 16),
          onTap: () async {
            bool required = true;
            for (int i = 0; i < customFields.length; i++) {
              if (customFields[i].required == 1) {
                if (customFields[i].userValue.isEmpty) {
                  required = false;
                  error[i] = LanguagePerformers.getLanguage() == "uz"
                      ? ("${customFields[i].label} ${translate("error_empty")}")
                      : ("${translate("error_empty")} ${customFields[i].name}");
                }
              }
              if (customFields[i].min != -1) {
                if (customFields[i].dataType == "int" &&
                    customFields[i].userValue.isNotEmpty) {
                  if (int.parse(customFields[i].userValue) <
                      customFields[i].min) {
                    required = false;
                    error[i] = LanguagePerformers.getLanguage() == "uz"
                        ? ("${customFields[i].label} ${customFields[i].min}${translate("min_msg")}")
                        : ("${customFields[i].label} ${translate("min_msg")} ${customFields[i].min}");
                  }
                } else {
                  if (customFields[i].userValue.length < customFields[i].min) {
                    required = false;
                    error[i] = LanguagePerformers.getLanguage() == "uz"
                        ? ("${customFields[i].label} ${customFields[i].min}${translate("min_msg")}")
                        : ("${customFields[i].label} ${translate("min_msg")} ${customFields[i].min}");
                  }
                }
              }
              if (customFields[i].max != -1) {
                if (customFields[i].dataType == "int" &&
                    customFields[i].userValue.isNotEmpty) {
                  if (int.parse(customFields[i].userValue) >
                      customFields[i].max) {
                    required = false;
                    error[i] = LanguagePerformers.getLanguage() == "uz"
                        ? ("${customFields[i].label} ${customFields[i].max}${translate("max_msg")}")
                        : ("${customFields[i].label} ${translate("max_msg")} ${customFields[i].max}");
                  }
                } else {
                  if (customFields[i].userValue.length > customFields[i].max) {
                    required = false;
                    error[i] = LanguagePerformers.getLanguage() == "uz"
                        ? ("${customFields[i].label} ${customFields[i].max}${translate("max_msg")}")
                        : ("${customFields[i].label} ${translate("max_msg")} ${customFields[i].max}");
                  }
                }
              }
            }

            if (required) {
              setState(() {
                loading = true;
              });
              HttpResult response = await createBloc.createCustom(
                customFields,
                taskId,
                widget.taskModel,
              );
              if (response.isSuccess) {
                CreateRouteModel data =
                    CreateRouteModel.fromJson(response.result);
                if (data.success) {
                  widget.nextPage(data.data.route, data.data.address);
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
            } else {
              // error = true;
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    RxBus.destroy(tag: "CREATE_CUSTOM_TASK_ID");
    RxBus.destroy(tag: "CREATE_CUSTOM");
    super.dispose();
  }

  void _initBus() {
    if (widget.taskModel != null) {
      for (int i = 0; i < widget.taskModel!.customFields.length; i++) {
        error.add(null);
      }
      setState(() {});
    }
    RxBus.register<int>(tag: "CREATE_CUSTOM_TASK_ID").listen(
      (event) {
        taskId = event;
      },
    );
    RxBus.register<List<CreateRouteCustomField>>(tag: "CREATE_CUSTOM").listen(
      (event) {
        if (widget.taskModel != null) {
          if (!first) {
            customFields = widget.taskModel!.customFields;
            first = true;
          }
        } else {
          if (!first) {
            customFields = event;
            first = true;
          }
          for (int i = 0; i < customFields.length; i++) {
            error.add(null);
          }
        }
        if (mounted) {
          setState(() {});
        }
      },
    );
  }
}
