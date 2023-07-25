// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/auth/login_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/auth/register_screen.dart';
import 'package:youdu/src/ui/auth/reset/reset_screen.dart';
import 'package:youdu/src/utils/save_data.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/auth/auth_text_field_widget.dart';
import 'package:youdu/src/widget/button/card_button.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Repository repository = Repository();
  bool _loading = false;
  bool _loading1 = false;
  bool login = true;
  AccessToken? accessToken;

  // FacebookUserModel? userModel;

  @override
  void initState() {
    googleSignIn.signInSilently();
    googleSignIn.onCurrentUserChanged.listen(
      (account) async {
        login = false;
        String token = "";
        if (account != null) {
          account.authentication.then((value) async {
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
            if (response.isSuccess) {
              LoginModel data = LoginModel.fromJson(response.result);
              if (data.accessToken != "") {
                ///response success kelsa login malumotlarini saqlash
                if (mounted) {
                  SaveData.saveData(context, data);
                }
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
          });
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
          translate("auth.login"),
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
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Text(
                        translate("auth.login"),
                        style: AppTypography.h2Small,
                      ),
                    ),
                    CardButton(
                      title: translate("google"),
                      icon: AppAssets.google,
                      onTap: () async {
                        ///google sign out button
                        await googleSignIn.signOut();
                        try {
                          ///google sigIn button
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
                        _loading1 = true;
                        setState(() {});
                        _loginFacebook();
                      },
                    ),
                    Platform.isAndroid
                        ? const SizedBox()
                        : CardButton(
                            title: translate("apple"),
                            color: AppColors.dark00,
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
                                    clientId: 'uz.group.useruz',
                                    redirectUri: Uri.parse(
                                      'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                                    ),
                                  ),
                                  nonce: 'example-nonce',
                                  state: 'example-state',
                                );
                                if (kDebugMode) {
                                  print(credential.identityToken.toString());
                                }
                                login = false;
                                String token = "";
                                token = credential.identityToken.toString();
                                _loading1 = true;
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
                    Container(
                      margin: const EdgeInsets.only(
                        top: 24,
                        left: 16,
                        right: 16,
                      ),
                      child: Text(
                        translate("auth.through"),
                        style: AppTypography.h2Small,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: TextField(
                        controller: _emailController,
                        style: AppTypography.pSmall32,
                        cursorColor: AppColors.greyAD,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.dark33),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.dark33,
                            ),
                          ),
                          labelText: translate("auth.email"),
                          labelStyle: AppTypography.pSmall3,
                        ),
                      ),
                    ),
                    AuthTextFieldWidget(
                      controller: _passwordController,
                      text: translate("auth.password"),
                      isPassword: true,
                      error: null,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          translate("reset"),
                          style: AppTypography.pSmall2,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              YellowButton(
                text: translate("auth.sign_in"),
                loading: _loading,
                onTap: () async {
                  _loading = true;
                  setState(() {});
                  HttpResult response = await repository.login(
                    _emailController.text,
                    _passwordController.text,
                  );
                  setState(() {
                    _loading = false;
                  });
                  if (response.isSuccess) {
                    LoginModel data = LoginModel.fromJson(
                      response.result,
                    );
                    if (data.accessToken != "") {
                      ///response success kelsa login malumotlarini saqlash
                      SaveData.saveData(context, data);
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
                },
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: Platform.isIOS ? 24 : 16,
                ),
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

  _loginFacebook() async {
    try {
      try {
        final response1 =
            await FacebookAuth.instance.login(permissions: ['email']);
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
        /* CenterDialog.errorDialog(
          context,
          e.toString(),
          e.toString(),
        );*/
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
    FacebookAuth.instance.logOut();
    googleSignIn.signOut();
  }
}
