// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import '../../../../../model/api/create/create_route_model.dart';
import '../../../../../utils/phone_number_formatter.dart';
import '../../../../../widget/app/app_custom_button.dart';

class CreateNumberScreen extends StatefulWidget {
  final int taskId;
  final TaskModel? taskModel;
  final Function(String _route, String nuber) nextPage;

  const CreateNumberScreen({
    super.key,
    required this.taskId,
    required this.nextPage,
    required this.taskModel,
  });

  @override
  State<CreateNumberScreen> createState() => _CreateNumberScreenState();
}

class _CreateNumberScreenState extends State<CreateNumberScreen>
    with AutomaticKeepAliveClientMixin<CreateNumberScreen> {
  @override
  bool get wantKeepAlive => true;
  bool loading = false, isNext = true;
  bool _value = false;
  String userNumber = "";
  final TextEditingController _controller = TextEditingController();
  final PhoneNumberTextInputFormatter _phoneNumber =
      PhoneNumberTextInputFormatter();

  @override
  void initState() {
    _controller.addListener(() {
      _updateData();
    });
    _getNumber();
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("create_task.number_title"),
              style: AppTypography.h2SmallSemiBold,
            ),
          ),
          userNumber.trim() == '' && widget.taskModel == null
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    !_value
                        ? Container(
                            margin: const EdgeInsets.only(left: 16, bottom: 20),
                            child: Text(
                              userNumber,
                              style: AppTypography.pSmall1Dark00,
                            ),
                          )
                        : Container(),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            translate("create_task.number_user"),
                            style: AppTypography.pSmallDark33,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch.adaptive(
                          value: _value,
                          activeColor: AppColors.yellow16,
                          onChanged: (newValue) {
                            _value = newValue;
                            if (!_value) {
                              _controller.text = "";
                            }
                            _updateData();
                          },
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    Container(
                      height: 16,
                      color: const Color(0xFFFBFBFB),
                    ),
                  ],
                ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate("create_task.number_info"),
                  style: AppTypography.pSmall3H,
                ),
                Row(
                  children: [
                    Text(
                      "+ 998 ",
                      style: AppTypography.pSmallRegular.copyWith(
                        color:
                            userNumber.trim() == '' && widget.taskModel == null
                                ? AppColors.dark00
                                : _value
                                    ? AppColors.dark00
                                    : AppColors.greyAD,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        readOnly: userNumber == '' && widget.taskModel == null
                            ? false
                            : !_value,
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        maxLength: 12,
                        keyboardType: TextInputType.phone,
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _phoneNumber,
                        ],
                        style: AppTypography.h1.copyWith(
                          color: userNumber == '' && widget.taskModel == null
                              ? AppColors.dark00
                              : _value
                                  ? AppColors.dark00
                                  : AppColors.greyAD,
                        ),
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
      floatingActionButton: AppCustomButton(
        loading: loading,
        margin: EdgeInsets.only(
          bottom: Platform.isIOS ? 32 : 24,
          left: 32,
        ),
        color: userNumber.trim() == '' && widget.taskModel == null
            ? _controller.text.length < 12
                ? AppColors.greyD6
                : AppColors.yellow16
            : isNext
                ? AppColors.yellow16
                : AppColors.greyD6,
        onTap: userNumber.trim() == '' && widget.taskModel == null
            ? _controller.text.length < 12
                ? () {}
                : () async {
                    String _num = "+998" + _controller.text.replaceAll(" ", "");
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String dt = prefs.getString("dateTime+$_num") ?? "";
                    setState(() {
                      loading = true;
                    });
                    DateTime date =
                        dt != "" ? DateTime.parse(dt) : DateTime.now();
                    DateTime n = DateTime.now();

                    if (!(dt != "") ||
                        (n.day > date.day ||
                            n.hour > date.hour ||
                            n.minute > date.minute + 3)) {
                      String numberCurrent =
                          "+998" + _controller.text.replaceAll(" ", "");
                      prefs.setString(
                          "dateTime$numberCurrent", DateTime.now().toString());
                      HttpResult response = await createBloc.createNumber(
                        numberCurrent,
                        widget.taskId,
                        widget.taskModel,
                      );
                      if (response.isSuccess &&
                          response.result["success"] == true) {
                        CreateRouteModel data =
                            CreateRouteModel.fromJson(response.result);
                        if (userNumber == "") {
                          // prefs.setString("number",
                          //     "+998" + _controller.text.replaceAll(" ", ""));
                        }
                        if (data.success) {
                          widget.nextPage(
                            data.data.route,
                            numberCurrent,
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
                    } else {
                      String numberCurrent =
                          "+998" + _controller.text.replaceAll(" ", "");
                      if (userNumber == "") {
                        prefs.setString("number",
                            "+998" + _controller.text.replaceAll(" ", ""));
                      }
                      widget.nextPage(
                        "verify",
                        numberCurrent,
                      );
                    }
                    setState(() {
                      loading = false;
                    });
                  }
            : () async {
                String number =
                    userNumber.replaceAll(" ", "").replaceAll("+", "");
                String _num = _value
                    ? "+998" + _controller.text.replaceAll(" ", "")
                    : userNumber.replaceAll(" ", "");

                SharedPreferences prefs = await SharedPreferences.getInstance();
                String dt = prefs.getString("dateTime+$_num") ?? "";
                if (!_value && number.length != 12) {
                  setState(() {
                    _value = true;
                  });
                  CenterDialog.errorDialog(
                    context,
                    translate("number"),
                    translate("number"),
                  );
                } else if ((_controller.text.length == 12 || !_value) &&
                    !loading) {
                  setState(() {
                    loading = true;
                  });
                  DateTime date =
                      dt != "" ? DateTime.parse(dt) : DateTime.now();
                  DateTime n = DateTime.now();

                  if (!(dt != "") ||
                      (n.day > date.day ||
                          n.hour > date.hour ||
                          n.minute > date.minute + 3)) {
                    String numberCurrent = _value
                        ? "+998" + _controller.text.replaceAll(" ", "")
                        : userNumber.replaceAll(" ", "");
                    prefs.setString(
                        "dateTime$numberCurrent", DateTime.now().toString());
                    HttpResult response = await createBloc.createNumber(
                      numberCurrent,
                      widget.taskId,
                      widget.taskModel,
                    );
                    if (response.isSuccess &&
                        response.result["success"] == true) {
                      CreateRouteModel data =
                          CreateRouteModel.fromJson(response.result);
                      if (userNumber == "") {
                        // prefs.setString("number",
                        //     "+998" + _controller.text.replaceAll(" ", ""));
                      }
                      if (data.success) {
                        widget.nextPage(
                          data.data.route,
                          numberCurrent,
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
                  } else {
                    String numberCurrent = _value
                        ? "+998" + _controller.text.replaceAll(" ", "")
                        : userNumber.replaceAll(" ", "");
                    if (userNumber == "") {
                      prefs.setString("number",
                          "+998" + _controller.text.replaceAll(" ", ""));
                    }
                    widget.nextPage(
                      "verify",
                      numberCurrent,
                    );
                  }
                  setState(() {
                    loading = false;
                  });
                }
              },
        title: translate("next"),
      ),
    );
  }

  Future<void> _getNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userNumber = prefs.getString("number") ?? "";
    // _controller.text = userNumber;
    if (widget.taskModel != null) {
      userNumber = widget.taskModel!.phone;
    }
    setState(() {});
  }

  void _updateData() {
    if (_controller.text.length == 12 || !_value) {
      setState(() {
        isNext = true;
      });
    } else {
      setState(() {
        isNext = false;
      });
    }
  }
}
