// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/profile_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/pipput/pin_put.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class VerifyScreen extends StatefulWidget {
  final String number;
  final Function() end;
  final bool scope;
  final Function() retry;

  const VerifyScreen({
    super.key,
    required this.number,
    required this.end,
    this.scope = false,
    required this.retry,
  });

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: AppColors.greyE9,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Repository repository = Repository();

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

  final scaffoldKey = GlobalKey();
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;
  TextEditingController controller1 = TextEditingController();

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
    return Container(
      height: MediaQuery.of(context).size.height - 120,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, top: 50),
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
                      style: AppTypography.pSmall1NH,
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
                  translate("create_task.verify_message") +
                      "\n" +
                      widget.number,
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
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (value.length == 6) {
                        HttpResult response = await repository.verifySms(
                          value,
                        );
                        if (response.isSuccess &&
                            response.result["success"] == true) {
                          if (!widget.scope) {
                            prefs.setString("number", widget.number);
                            profileBloc.getSettingsData(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            CenterDialog.messageDialog(context,
                                response.result["message"].toString(), () {});
                          } else {
                            prefs.setString("number", widget.number);
                            widget.end();
                          }
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
                    focusNode: FocusNode(),
                    textStyle: AppTypography.pSmallSemiBold,
                    submittedFieldDecoration: _pinPutDecoration,
                    selectedFieldDecoration: _pinPutDecoration,
                    followingFieldDecoration: _pinPutDecoration,
                    eachFieldWidth:
                        (MediaQuery.of(context).size.width - 92) / 6,
                  ),
                ),
                const SizedBox(height: 44),
                Center(
                  child: GestureDetector(
                    onTap: _start != 0
                        ? () {}
                        : () async {
                            _start = 180;
                            setState(() {});
                            startTimer();

                            // HttpResult response = await createBloc.createNumber(
                            //   "+${widget.number.replaceAll(" ", "").replaceAll("+", "")}",
                            //   int.parse(widget.taskId),
                            //   widget.taskModel,
                            // );
                            // if (!response.isSuccess) {
                            //   CenterDialog.errorDialog(
                            //     context,
                            //     Utils.serverErrorText(response),
                            //     response.result.toString(),
                            //   );
                            // }
                            widget.retry();
                          },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _start != 0
                                ? translate("send_sms") +
                                    " " +
                                    Utils.numberFormat(_start ~/ 60) +
                                    ":" +
                                    Utils.numberFormat(_start % 60)
                                : translate("send_sms"),
                            style: AppTypography.pSemiBold.copyWith(
                              color: _start != 0
                                  ? AppColors.greyD6
                                  : AppColors.dark00,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
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
                ),
                const SizedBox(
                  height: 16,
                ),
                // _start == 0
                //     ? Container()
                //     : Text(
                //         translate("create_task.verify_time") +
                //             " " +
                //             Utils.numberFormat(_start ~/ 60) +
                //             ":" +
                //             Utils.numberFormat(_start % 60),
                //         style: const TextStyle(
                //           fontFamily: AppTypography.fontFamilyProxima,
                //           fontWeight: FontWeight.w600,
                //           fontSize: 17,
                //           color: AppColors.greyD6,
                //         ),
                //       )
              ],
            ),
          )
        ],
      ),
    );
  }
}
