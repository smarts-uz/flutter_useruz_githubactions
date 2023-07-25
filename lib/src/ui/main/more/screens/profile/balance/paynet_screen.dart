import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/phone_number_formatter.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';

class PaynetScreen extends StatefulWidget {
  const PaynetScreen({super.key});

  @override
  State<PaynetScreen> createState() => _PaynetScreenState();
}

class _PaynetScreenState extends State<PaynetScreen> {
  final TextEditingController _controller = TextEditingController();
  int click = 1;
  int id = 0;
  String? error;

  @override
  void initState() {
    super.initState();
    _controller.text = "4 000";
    _controller.addListener(() {
      error = null;
      setState(() {});
    });
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        leading: const BackWidget(),
        title: Text(
          translate("profile.fill"),
          style: AppTypography.pSmallRegularDark33.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            color: AppColors.white,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [NumericTextFormatter()],
              style: const TextStyle(
                fontFamily: AppTypography.fontFamilyProxima,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontSize: 17,
                height: 22 / 17,
                color: AppColors.dark00,
              ),
              decoration: InputDecoration(
                labelText: translate("profile.sum"),
                errorText: error,
                errorStyle: AppTypography.pSmallRedB5,
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("profile.choose"),
              style: const TextStyle(
                fontFamily: AppTypography.fontFamilyProxima,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontSize: 17,
                height: 24 / 17,
                color: AppColors.dark00,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          for (int i = 1; i <= 3; i++)
            GestureDetector(
              onTap: () {
                click = i;
                setState(() {});
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          i == 1
                              ? AppAssets.payme
                              : i == 2
                                  ? AppAssets.click
                                  : AppAssets.paynet,
                          height: 32,
                          width: 96,
                        ),
                        const Spacer(),
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: click == i
                                ? AppColors.yellow00
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              width: 2,
                              color: click == i
                                  ? AppColors.yellow00
                                  : AppColors.greyD6,
                            ),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: AppColors.white,
                            size: 16,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.greyE9,
                    )
                  ],
                ),
              ),
            )
        ],
      ),
      floatingActionButton: YellowButton(
        onTap: () async {
          int k = 0;
          for (int i = 0; i < _controller.text.length; i++) {
            try {
              k = k * 10 + int.parse(_controller.text[i]);
            } catch (_) {}
          }
          if (k >= 4000) {
            String data =
                "m=628b421bd7e616cbdee6f11d;ac.user_id=$id;a=${k * 100}";
            var bytes = utf8.encode(data);
            var base64 = base64Encode(bytes);
            switch (click) {
              case 1:
                if (!await launchUrl(
                  Uri.parse("https://checkout.paycom.uz/$base64"),
                  mode: LaunchMode.inAppWebView,
                )) {
                  throw 'Could not launch ';
                }
                break;
              case 2:
                if (!await launchUrl(
                  Uri.parse(
                      "https://my.click.uz/services/pay?service_id=23202&merchant_id=14364&amount=$k&transaction_param=$id"),
                  mode: LaunchMode.inAppWebView,
                )) {
                  throw 'Could not launch ';
                }
                break;

              default:
                if (!await launchUrl(
                  Uri.parse(
                    LanguagePerformers.getLanguage() == 'ru'
                        ? "https://user.uz/paynet-oplata/ru"
                        : "https://user.uz/paynet-oplata/uz",
                  ),
                  mode: LaunchMode.inAppWebView,
                )) {
                  throw 'Could not launch ';
                }
                break;
            }
          } else {
            error = translate("profile.min_sum");
            setState(() {});
          }
        },
        text: translate("profile.next"),
        margin: EdgeInsets.only(
          left: 48,
          right: 16,
          bottom: Platform.isIOS ? 24 : 16,
        ),
      ),
    );
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("id") ?? 0;
    setState(() {});
  }
}
