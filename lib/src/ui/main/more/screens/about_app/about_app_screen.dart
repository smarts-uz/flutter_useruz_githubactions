import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/app_custom_button.dart';
import 'package:youdu/src/widget/more/links_widget.dart';
import 'package:youdu/src/widget/web_page.dart';

class AboutAppSCreen extends StatelessWidget {
  const AboutAppSCreen({super.key, required this.data});
  final List<String> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(AppAssets.back),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: Image.asset(AppAssets.users),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinksWidget(
                      icon: AppAssets.telegram,
                      link: data
                          .firstWhere((element) => element.contains('t.me')),
                    ),
                    LinksWidget(
                      icon: AppAssets.facebook,
                      link: data.firstWhere(
                          (element) => element.contains('facebook')),
                    ),
                    LinksWidget(
                      icon: AppAssets.instagram,
                      link: data.firstWhere(
                          (element) => element.contains('instagram')),
                    ),
                    const LinksWidget(
                      icon: AppAssets.browser,
                      link: Utils.webUrl,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewPage(
                          url: LanguagePerformers.getLanguage() == 'uz'
                              ? "https://user.uz/terms/uz"
                              : "https://user.uz/terms/ru",
                        ),
                      ),
                    );
                  },
                  child: Text(
                    translate("more.terms"),
                    textAlign: TextAlign.center,
                    style: AppTypography.pBlueAlert,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewPage(
                          url: LanguagePerformers.getLanguage() == 'uz'
                              ? "https://user.uz/privacy"
                              : "https://user.uz/privacy",
                        ),
                      ),
                    );
                  },
                  child: Text(
                    translate("more.privacy"),
                    textAlign: TextAlign.center,
                    style: AppTypography.pBlueAlert,
                  ),
                ),
                const SizedBox(
                  height: 24,
                )
              ],
            ),
          ),
          AppCustomButton(
            title: translate("more.rate"),
            onTap: () {
              Platform.isIOS
                  ? _launchUrl(
                      'https://apps.apple.com/uz/app/user-uz/id1645713842')
                  : _launchUrl('market://details?id=uz.smart.useruz');
            },
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          )
        ],
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
