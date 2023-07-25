// ignore_for_file: prefer_is_empty, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/database/clear_storage.dart';
import 'package:youdu/src/database/security_storage.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/repositories/local_auth_repository.dart';
import 'package:youdu/src/ui/auth/entrance_screen/entrance_screen.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/more/settings/pin_code_circle_widget.dart';

class LocalAuthScreen extends StatefulWidget {
  const LocalAuthScreen({super.key});

  @override
  State<LocalAuthScreen> createState() => _LocalAuthScreenState();
}

class _LocalAuthScreenState extends State<LocalAuthScreen> {
  String userEnteredPinCode = '';
  String statusMessage = '';
  bool? isPinCodeValid;
  bool isAuthenticated = false;

  final Repository repository = Repository();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLanguage();
    });
    if (SecurityStorage.instance.isBiometricsEnabled) {
      authenticateBiometrics();
    }
  }

  Future<void> _setLanguage() async {
    setState(() {
      var localizationDelegate = LocalizedApp.of(context).delegate;
      localizationDelegate.changeLocale(
        Locale(
          LanguagePerformers.getLanguage(),
        ),
      );
    });
  }

  Future<void> authenticateBiometrics() async {
    isAuthenticated = await LocalAuthRepository.instance.authenticateUser();
    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const MainScreen();
          },
        ),
      );
    }
  }

  Future<void> changePinActions(int index) async {
    if (index + 1 == 10) {
      if (SecurityStorage.instance.isBiometricsEnabled) {
        authenticateBiometrics();
      }
    } else if (index + 1 == 11) {
      if (userEnteredPinCode.length == 4) return;
      userEnteredPinCode += '0';
    } else if (index + 1 == 12) {
      if (userEnteredPinCode.isEmpty) return;
      userEnteredPinCode =
          userEnteredPinCode.substring(0, userEnteredPinCode.length - 1);
    } else {
      if (userEnteredPinCode.length == 4) return;
      userEnteredPinCode += '${index + 1}';
    }
    if (userEnteredPinCode.length == 4) {
      if (userEnteredPinCode == SecurityStorage.instance.pincode) {
        isPinCodeValid = true;
        statusMessage = '';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const MainScreen();
            },
          ),
        );
      } else {
        isPinCodeValid = false;
        statusMessage = translate('security.wrong_pin_code');
      }
    } else {
      statusMessage = '';
      isPinCodeValid = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.snowDrift,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate('security.enter_pin_code'),
                    style: AppTypography.h2SmallDark00Medium.copyWith(
                      color: AppColors.darkGray,
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PinCodeCircle(
                            isFilled: userEnteredPinCode.length > 0,
                            status: isPinCodeValid,
                          ),
                          PinCodeCircle(
                            isFilled: userEnteredPinCode.length > 1,
                            status: isPinCodeValid,
                          ),
                          PinCodeCircle(
                            isFilled: userEnteredPinCode.length > 2,
                            status: isPinCodeValid,
                          ),
                          PinCodeCircle(
                            isFilled: userEnteredPinCode.length > 3,
                            status: isPinCodeValid,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        statusMessage,
                        style: AppTypography.pTiny215ProDark33.copyWith(
                          color: AppColors.darkRed,
                        ),
                      ),
                    ],
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: () => changePinActions(index),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColors.white,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          overlayColor: MaterialStateProperty.all(
                            SecurityStorage.instance.isBiometricsEnabled
                                ? AppColors.greyE9
                                : null,
                          ),
                        ),
                        child: index + 1 == 10
                            ? SvgPicture.asset(
                                AppAssets.fingerPrint,
                                color: !SecurityStorage
                                        .instance.isBiometricsEnabled
                                    ? AppColors.dark00.withOpacity(0.25)
                                    : null,
                              )
                            : index + 1 == 11
                                ? SvgPicture.asset(AppAssets.num0)
                                : index + 1 == 12
                                    ? SvgPicture.asset(AppAssets.x)
                                    : SvgPicture.asset(
                                        'assets/icons/${index + 1}.svg',
                                      ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            title: Text(
                              translate('security.reset'),
                              style: AppTypography.h3charcoalGray,
                            ),
                            content: Text(
                              translate('security.want_to_reset_accaunt'),
                              style: AppTypography.pSmall3CharcoalGray,
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  translate('security.reset_action'),
                                  style: AppTypography.pTinyBoldBlue91,
                                ),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String deviceId =
                                      prefs.getString("deviceId") ?? "";
                                  if (deviceId == "") {
                                    deviceId = await FlutterUdid.udid;
                                    prefs.setString("deviceId", deviceId);
                                  }
                                  HttpResult response =
                                      await repository.logout(deviceId);

                                  if (response.isSuccess) {
                                    String lang =
                                        LanguagePerformers.getLanguage();
                                    prefs.clear();
                                    ClearStorage.instance.clearStorage();
                                    LanguagePerformers.saveLanguage(lang);
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const EntranceScreen();
                                        },
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
                                },
                              ),
                              TextButton(
                                child: Text(
                                  translate('security.cancel'),
                                  style: AppTypography.pTinyBoldRedAlert,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      translate('security.forgot_pin_code'),
                      style: AppTypography.pTiny215YellowNormal.copyWith(
                        color: AppColors.greyDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
