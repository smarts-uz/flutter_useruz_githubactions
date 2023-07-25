import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/database/security_storage.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/security_screen.dart';
import 'package:youdu/src/utils/pipput/pin_put.dart';
import 'package:youdu/src/widget/app/app_bar_title.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';

class ChangePinCodeScreen extends StatefulWidget {
  const ChangePinCodeScreen({super.key});

  @override
  State<ChangePinCodeScreen> createState() => _ChangePinCodeScreenState();
}

class _ChangePinCodeScreenState extends State<ChangePinCodeScreen> {
  late final TextEditingController _pinCodeController;

  late String statusMessage;
  String warningMessage = '';

  String enteredPincode = '';
  bool isAuthFirstTime = true;
  bool isAuthSecondTime = true;
  bool isFirstTime = true;
  bool isButtonDisabled = true;
  late bool isLocalAuthEnabled;

  @override
  void initState() {
    super.initState();
    _pinCodeController = TextEditingController();
    isLocalAuthEnabled = SecurityStorage.instance.isLocalAuthEnabled;
    statusMessage = isLocalAuthEnabled
        ? translate('security.enter_pin_code')
        : translate('security.enter_new_pin_code');
  }

  @override
  void dispose() {
    _pinCodeController.dispose();
    super.dispose();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: AppColors.greyE9,
      borderRadius: BorderRadius.circular(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 120),
              Text(statusMessage, style: AppTypography.h2Small),
              const SizedBox(height: 24),
              PinPut(
                controller: _pinCodeController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                fieldsCount: 4,
                keyboardType: TextInputType.number,
                onChanged: handlePincodeActions,
                animationCurve: Curves.easeInOut,
                fieldsAlignment: MainAxisAlignment.spaceEvenly,
                textStyle: AppTypography.pSmallSemiBold,
                submittedFieldDecoration: _pinPutDecoration,
                selectedFieldDecoration: _pinPutDecoration,
                followingFieldDecoration: _pinPutDecoration,
                eachFieldHeight: 56,
                eachFieldWidth: 56,
              ),
              const SizedBox(height: 24),
              Text(
                warningMessage,
                style: AppTypography.tinyText2LargeRed,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: YellowButton(
        text: translate('security.save'),
        isDisabled: isButtonDisabled,
        margin: const EdgeInsets.fromLTRB(32, 16, 0, 16),
        onTap: () {
          if (isButtonDisabled) return;
          SecurityStorage.instance.saveLocalAuthEnabled(true);
          SecurityStorage.instance.savePincode(enteredPincode);
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => const SecurityScreen(),
            ),
          );
        },
      ),
    );
  }

  void handlePincodeActions(String value) {
    if (value.length == 4) {
      if (isLocalAuthEnabled) {
        if (isAuthFirstTime) {
          if (value == SecurityStorage.instance.pincode) {
            Future.delayed(const Duration(milliseconds: 500)).then((_) {
              setState(() {
                _pinCodeController.clear();
                statusMessage = translate('security.enter_new_pin_code');
                isAuthFirstTime = false;
              });
            });
          } else {
            setState(() {
              warningMessage = translate('security.wrong_pin_code');
            });
          }
        } else {
          if (isAuthSecondTime) {
            Future.delayed(const Duration(milliseconds: 500)).then((_) {
              setState(() {
                enteredPincode = value;
                _pinCodeController.clear();
                statusMessage = translate('security.confirm_new_pin_code');
                isAuthSecondTime = false;
              });
            });
          } else {
            if (enteredPincode == value) {
              isButtonDisabled = false;
              setState(() {});
            } else {
              setState(() {
                warningMessage = translate('security.pin_code_not_match');
              });
            }
          }
        }
      } else {
        if (isFirstTime) {
          Future.delayed(const Duration(milliseconds: 500)).then((_) {
            setState(() {
              enteredPincode = value;
              _pinCodeController.clear();
              statusMessage = translate('security.confirm_new_pin_code');
              isFirstTime = false;
            });
          });
        } else {
          if (enteredPincode == value) {
            isButtonDisabled = false;
            setState(() {});
          } else {
            setState(() {
              warningMessage = translate('security.pin_code_not_match');
            });
          }
        }
      }
    } else {
      setState(() {
        warningMessage = '';
      });
    }
  }
}
