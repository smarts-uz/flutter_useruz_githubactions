// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/auth/entrance_screen/entrance_screen.dart';
import 'package:youdu/src/ui/auth/reset/change_pass_screen.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/pipput/pin_put.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({
    super.key,
    required this.number,
    required this.end,
    this.delete = false,
    this.isEmail = false,
  });

  final String number;
  final Function() end;
  final bool delete;
  final bool isEmail;

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: AppColors.greyE9,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Repository repository = Repository();
  final scaffoldKey = GlobalKey();
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;
  TextEditingController controller1 = TextEditingController();
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
    return Container(
      height: MediaQuery.of(context).size.height - 120,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 56,
      ),
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
                      widget.isEmail
                          ? translate("create_task.verify_email")
                          : translate("create_task.verify_number"),
                      style: AppTypography.pSmall1.copyWith(height: null),
                    ),
                  ),
                ),
                const SizedBox(width: 40)
              ],
            ),
          ),
          Container(height: 1, color: AppColors.greyE9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isEmail
                      ? translate("create_task.verify_email_title")
                      : translate("create_task.verify_title"),
                  style: AppTypography.h2SmallDark33,
                ),
                const SizedBox(height: 12),
                Text(
                  "${widget.isEmail ? translate("create_task.verify_email_message") : translate("create_task.verify_message")}\n${widget.number}",
                  textAlign: TextAlign.center,
                  style: AppTypography.pSmall3Medium,
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
                      if (value.length == 6) {
                        if (!widget.delete && !widget.isEmail) {
                          HttpResult response = await repository.resetCode(
                              widget.number
                                  .replaceAll("+", "")
                                  .replaceAll(" ", ""),
                              value);
                          if (response.isSuccess &&
                              response.result["success"] == true) {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePassScreen(
                                  number: widget.number
                                      .replaceAll("+", "")
                                      .replaceAll(" ", ""),
                                ),
                              ),
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
                        } else if (widget.isEmail) {
                          HttpResult response =
                              await repository.verifyEmail(value);
                          if (response.isSuccess &&
                              response.result["success"] == true) {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Fluttertoast.showToast(
                              msg: translate("data_saved"),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
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
                          HttpResult response =
                              await repository.deletePostCode(value);
                          if (response.isSuccess &&
                              response.result["success"] == true) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String lang = LanguagePerformers.getLanguage();
                            prefs.clear();
                            LanguagePerformers.saveLanguage(lang);
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EntranceScreen(),
                              ),
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
                Text(
                  "${translate("create_task.verify_time")} ${Utils.numberFormat(_start ~/ 60)}:${Utils.numberFormat(_start % 60)}",
                  style: AppTypography.pSmall1SemiBold,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
