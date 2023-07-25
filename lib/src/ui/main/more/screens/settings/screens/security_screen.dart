import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/database/security_storage.dart';
import 'package:youdu/src/widget/app/app_bar_title.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/button/border_button.dart';
import 'package:youdu/src/widget/more/settings/settings.dart';
import 'package:youdu/src/widget/more/settings/auto_lock_modal_sheet.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/security/change_pin_code_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreentate();
}

class _SecurityScreentate extends State<SecurityScreen> {
  @override
  void initState() {
    super.initState();
    isLocalAuthEnabled = SecurityStorage.instance.isLocalAuthEnabled;
    isBiometricsEnabled = SecurityStorage.instance.isBiometricsEnabled;
  }

  late bool isBiometricsEnabled;
  late bool isLocalAuthEnabled;

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Builder(
        builder: (context) {
          return CupertinoPageScaffold(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.background,
                elevation: 1,
                leading: const BackWidget(),
                title: AppBarTitle(
                  text: translate("settings.security"),
                  textStyle: AppTypography.pSmallRegularDark33Bold,
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    SettingsWidget(
                      title: isLocalAuthEnabled
                          ? translate("security.change_pin_code")
                          : translate('security.enable_pin_code'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePinCodeScreen(),
                          ),
                        );
                      },
                    ),
                    isLocalAuthEnabled
                        ? SettingsWidget(
                            title: translate("security.auto_lock"),
                            onTap: () {
                              CupertinoScaffold.showCupertinoModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return const AutoLockModalSheet();
                                },
                              );
                            },
                          )
                        : const SizedBox(),
                    isLocalAuthEnabled
                        ? SettingsWidget(
                            title: translate("security.touch_face_id"),
                            icCheck: true,
                            value: isBiometricsEnabled,
                            onTap: () {
                              isBiometricsEnabled = !isBiometricsEnabled;
                              SecurityStorage.instance.saveBiometricsEnabled(
                                isBiometricsEnabled,
                              );
                              setState(() {});
                            },
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              floatingActionButton: BorderButton(
                txtColor: AppColors.red5B,
                text: translate("security.disable_pin_code"),
                margin: const EdgeInsets.fromLTRB(32, 16, 0, 16),
                isDisabled: !isLocalAuthEnabled,
                onTap: () {
                  if (isLocalAuthEnabled) {
                    SecurityStorage.instance.saveLocalAuthEnabled(false);
                    Fluttertoast.showToast(
                      msg: translate("security.pin_code_disabled_msg"),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
