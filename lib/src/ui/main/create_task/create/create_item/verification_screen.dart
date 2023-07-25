// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/pipput/pin_put.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

import '../../../../../model/api/create/create_route_model.dart';
import '../../../../../model/api_model/tasks/product_model.dart';

class VerificationScreen extends StatefulWidget {
  final String number;
  final String taskId;
  final Function() end;
  final bool update;
  final TaskModel? taskModel;

  const VerificationScreen({
    super.key,
    required this.number,
    required this.taskId,
    required this.end,
    required this.update,
    this.taskModel,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: AppColors.greyE9,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        width: 1,
        color: error ? AppColors.red5B : AppColors.greyE9,
      ),
    );
  }

  bool loading = false, error = false;
  final scaffoldKey = GlobalKey();
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;
  TextEditingController controller1 = TextEditingController();
  String errorText = "";

  Timer? _timer;
  int _start = 180;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    _otpInteractor = OTPInteractor();
    _otpInteractor
        .getAppSignature()
        //ignore: avoid_print
        .then((value) => print('signature - $value'));

    controller = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          controller1.text = exp.stringMatch(code ?? '') ?? '';
          setState(() {});
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [
          // SampleStrategy(),
        ],
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: MediaQuery.of(context).size.height - 120,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 56,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          AppAssets.closeX,
                          color: AppColors.yellow00,
                          width: 24,
                          height: 24,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            translate("create_task.verify_number"),
                            style: AppTypography.pSmall1.copyWith(height: null),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40)
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: AppColors.greyE9,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        translate("create_task.verify_title"),
                        style: AppTypography.h2SmallDarkSBoldH,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${translate("create_task.verify_message")}\n+${widget.number.replaceAll(" ", "").replaceAll("+", "")}",
                        textAlign: TextAlign.center,
                        style: AppTypography.pTiny2GreyAD,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        height: 56,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: PinPut(
                          controller: controller1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          fieldsCount: 6,
                          keyboardType: TextInputType.number,
                          onSubmit: (String value) async {
                            error = false;
                            errorText = "";
                            setState(() {});
                            if (value.length == 6) {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus &&
                                  currentFocus.focusedChild != null) {
                                currentFocus.focusedChild!.unfocus();
                              }
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              loading = true;
                              setState(() {});
                              HttpResult response =
                                  await createBloc.createNumberVerification(
                                "+${widget.number.replaceAll(" ", "").replaceAll("+", "")}",
                                value,
                                widget.taskId,
                                update: widget.update,
                              );
                              loading = false;
                              setState(() {});
                              if (response.isSuccess) {
                                prefs.setString(
                                  "dateTime+${widget.number.replaceAll(" ", "").replaceAll("+", "")}",
                                  DateTime(2000).toString(),
                                );
                                CreateRouteModel data =
                                    CreateRouteModel.fromJson(response.result);
                                if (data.data.route == "end") {
                                  Navigator.pop(context);
                                  widget.end();
                                } else {
                                  error = true;
                                  errorText = Utils.serverErrorText(response);

                                  setState(() {});
                                }
                              } else if (response.status == -1) {
                                CenterDialog.networkErrorDialog(context);
                              } else {
                                error = true;
                                errorText = Utils.serverErrorText(response);

                                setState(() {});
                              }
                            }
                          },
                          focusNode: FocusNode(),
                          textStyle: AppTypography.pSmallSemiBold,
                          submittedFieldDecoration: _pinPutDecoration,
                          selectedFieldDecoration: _pinPutDecoration,
                          followingFieldDecoration: _pinPutDecoration,
                          eachFieldWidth:
                              (MediaQuery.of(context).size.width - 92) / 6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Text(
                            errorText,
                            style: AppTypography.pSmall1SemiBoldRed5B,
                          ),
                        ],
                      ),
                      const SizedBox(height: 44),
                      GestureDetector(
                        onTap: _start != 0
                            ? () {}
                            : () async {
                                _start = 180;
                                setState(() {});
                                startTimer();
                                HttpResult response =
                                    await createBloc.createNumber(
                                  "+${widget.number.replaceAll(" ", "").replaceAll("+", "")}",
                                  int.parse(widget.taskId),
                                  widget.taskModel,
                                );
                                if (!response.isSuccess) {
                                  CenterDialog.errorDialog(
                                    context,
                                    Utils.serverErrorText(response),
                                    response.result.toString(),
                                  );
                                }
                              },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _start != 0
                                    ? "${translate("send_sms")} ${Utils.numberFormat(_start ~/ 60)}:${Utils.numberFormat(_start % 60)}"
                                    : translate("send_sms"),
                                style: AppTypography.pSemiBold.copyWith(
                                  color: _start != 0
                                      ? AppColors.greyD6
                                      : AppColors.dark00,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Icon(
                                CupertinoIcons.refresh_thin,
                                color: _start != 0
                                    ? AppColors.greyD6
                                    : AppColors.yellow00,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // _start == 0
                      //     ? Container()
                      //     : Text(
                      //         "${translate("create_task.verify_time")} ${Utils.numberFormat(_start ~/ 60)}:${Utils.numberFormat(_start % 60)}",
                      //         style: const TextStyle(
                      //           fontFamily: AppTypography.fontFamilyProxima,
                      //           fontWeight: FontWeight.w600,
                      //           fontSize: 17,
                      //           color: AppColors.greyD6,
                      //         ),
                      //       )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        !loading
            ? Container()
            : Container(
                width: MediaQuery.of(context).size.width,
                color: AppColors.dark00.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 56,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator.adaptive(
                            backgroundColor: AppColors.dark00,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            translate("loading"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
      ],
    );
  }
}
