// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/auth/login_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/auth/form_screen.dart';
import 'package:youdu/src/utils/save_data.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/border_button.dart';
import 'package:youdu/src/widget/button/card_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ["email"],
);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GoogleSignInAccount? _googleSignInAccount;
  AccessToken? accessToken;

  // FacebookUserModel? userModel;
  Repository repository = Repository();
  bool register = false;
  bool _loading1 = false;
  bool login = true;

  @override
  void initState() {
    googleSignIn.signInSilently();

    ///google auth response
    googleSignIn.onCurrentUserChanged.listen(
      (account) {
        _googleSignInAccount = account;
        login = false;
        String token = "";
        if (_googleSignInAccount != null) {
          _googleSignInAccount!.authentication.then(
            (value) async {
              if (_loading1) {
                return;
              }
              debugPrint(value.accessToken);
              token = value.accessToken.toString();
              _loading1 = true;
              if (mounted) {
                setState(() {});
              }
              HttpResult response =
                  await repository.socialLogin(Utils.google, token);
              _loading1 = false;
              if (mounted) {
                setState(() {});
              }
              if (response.status == 200) {
                LoginModel data = LoginModel.fromJson(response.result);
                if (data.accessToken != "") {
                  ///response success kelsa login malumotlarini saqlash
                  if (mounted) {
                    SaveData.saveData(context, data);
                    setState(() {
                      login = true;
                    });
                  }
                }
              } else {
                CenterDialog.errorDialog(
                  context,
                  Utils.serverErrorText(response),
                  response.result.toString(),
                );
                if (mounted) {
                  setState(() {
                    login = true;
                  });
                }
              }
            },
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: SvgPicture.asset(AppAssets.back),
            ),
          ),
        ),
        title: Text(
          translate("auth.registration"),
          style: AppTypography.pSmall1,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: AppColors.greyE9,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Text(
                        translate("auth.register_social"),
                        style: AppTypography.h2Small,
                      ),
                    ),
                    CardButton(
                      title: translate("google"),
                      icon: AppAssets.google,
                      onTap: () async {
                        try {
                          ///googledan malumotlarni olish uchun signIn
                          await googleSignIn.signIn();
                        } catch (e) {
                          CenterDialog.networkErrorDialog(context);
                        }
                      },
                    ),
                    CardButton(
                      title: translate("facebook"),
                      icon: AppAssets.facebook,
                      onTap: () async {
                        _loginFacebook();
                      },
                    ),
                    Platform.isAndroid
                        ? Container()
                        : CardButton(
                            title: translate("apple"),
                            icon: AppAssets.apple,
                            onTap: () async {
                              try {
                                final credential =
                                    await SignInWithApple.getAppleIDCredential(
                                  scopes: [
                                    AppleIDAuthorizationScopes.email,
                                    AppleIDAuthorizationScopes.fullName,
                                  ],
                                  webAuthenticationOptions:
                                      WebAuthenticationOptions(
                                    clientId:
                                        'de.lunaone.flutter.signinwithapplZeexample.service',
                                    redirectUri: Uri.parse(
                                      'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                                    ),
                                  ),
                                  nonce: 'example-nonce',
                                  state: 'example-state',
                                );
                                login = false;
                                String token = "";
                                token = credential.identityToken.toString();
                                _loading1 = false;
                                setState(() {});
                                HttpResult response = await repository
                                    .socialLogin(Utils.apple, token);
                                _loading1 = false;
                                setState(() {});
                                if (response.isSuccess) {
                                  LoginModel data =
                                      LoginModel.fromJson(response.result);
                                  if (data.accessToken != "") {
                                    ///response success kelsa login malumotlarini saqlash
                                    SaveData.saveData(context, data);
                                  } else {
                                    CenterDialog.errorDialog(
                                      context,
                                      Utils.serverErrorText(response),
                                      response.result.toString(),
                                    );
                                    login = true;
                                  }
                                  login = true;
                                } else {
                                  CenterDialog.errorDialog(
                                    context,
                                    Utils.serverErrorText(response),
                                    response.result.toString(),
                                  );
                                  login = true;
                                }
                              } catch (_) {}
                            },
                          ),
                  ],
                ),
              ),
              BorderButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        ///form screen button
                        return const FormScreen();
                      },
                    ),
                  );
                },
                text: translate("auth.number"),
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: Platform.isIOS ? 24 : 16,
                ),
                txtColor: AppColors.dark33,
              ),
            ],
          ),
          !_loading1
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
      ),
    );
  }

  ///login with facebook
  _loginFacebook() async {
    try {
      try {
        var response1 = await FacebookAuth.instance.login();
        await FacebookAuth.i.getUserData(
          fields: "email,name",
        );

        _loading1 = true;
        if (mounted) {
          setState(() {});
        }
        HttpResult response = await repository.socialLogin(
            Utils.facebook, response1.accessToken!.token.toString());
        _loading1 = false;
        if (mounted) {
          setState(() {});
        }
        if (response.isSuccess) {
          LoginModel data = LoginModel.fromJson(response.result);
          if (data.accessToken != "") {
            ///response success kelsa login malumotlarini saqlash
            SaveData.saveData(context, data);
          }
        } else {
          CenterDialog.errorDialog(
            context,
            Utils.serverErrorText(response),
            response.result.toString(),
          );
        }
      } catch (_) {
        // CenterDialog.errorDialog(
        //   context,
        //   e.toString(),
        //   e.toString(),
        // );
      }

      _loading1 = false;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _loading1 = false;
      if (mounted) {
        setState(() {});
      }
    } finally {
      _loading1 = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    ///facebook auth logout
    FacebookAuth.instance.logOut();

    ///google logout
    googleSignIn.signOut();
  }
}
