import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/database/security_storage.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/utils/pipput/pin_put.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';

class SetNewPincodeScreen extends StatefulWidget {
  const SetNewPincodeScreen({super.key});

  @override
  State<SetNewPincodeScreen> createState() => _SetNewPincodeScreenState();
}

class _SetNewPincodeScreenState extends State<SetNewPincodeScreen> {
  late final TextEditingController _pinCodeController;

  String statusMessage = translate('security.enter_new_pin_code');

  String enteredPincode = '';
  bool isFirstTime = true;
  bool isButtonDisabled = true;
  bool? isSamePincode;

  @override
  void initState() {
    super.initState();
    _pinCodeController = TextEditingController();
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
        actions: [
          TextButton(
            onPressed: () {
              SecurityStorage.instance.saveFirstTime(false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const MainScreen();
                  },
                ),
              );
            },
            child: Text(translate('auth.skip'), style: AppTypography.p),
          ),
        ],
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
                onChanged: (value) {
                  if (!isFirstTime) {
                    setState(() {
                      isButtonDisabled = value != enteredPincode;
                      if (value.length == 4) {
                        isSamePincode = value == enteredPincode;
                      } else {
                        isSamePincode = null;
                      }
                    });
                    return;
                  }
                  if (value.length == 4) {
                    Future.delayed(const Duration(milliseconds: 500)).then((_) {
                      setState(() {
                        enteredPincode = value;
                        _pinCodeController.clear();
                        statusMessage =
                            translate('security.confirm_new_pin_code');
                        isFirstTime = false;
                      });
                    });
                  }
                },
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
                isSamePincode == null || isSamePincode!
                    ? ''
                    : translate('security.pin_code_not_match'),
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
          SecurityStorage.instance.saveFirstTime(false);
          SecurityStorage.instance.saveLocalAuthEnabled(true);
          SecurityStorage.instance.savePincode(enteredPincode);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const MainScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
