// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';

class SettingsWidget extends StatelessWidget {
  final String? icon;
  final String title;
  final bool icCheck;
  final bool value;
  final Color color;
  final Color txtColor;
  final Function() onTap;
  final int subtitle;
  final bool balance;

  const SettingsWidget({
    super.key,
    this.subtitle = 0,
    this.icon,
    required this.title,
    this.icCheck = false,
    this.value = false,
    this.color = AppColors.yellow00,
    this.txtColor = AppColors.dark33,
    required this.onTap,
    this.balance = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        color: AppColors.white,
        margin: EdgeInsets.symmetric(vertical: icCheck ? 0 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  icon != null
                      ? SvgPicture.asset(
                          icon!,
                          color: color,
                          height: 28,
                          width: 28,
                        )
                      : const SizedBox(),
                  SizedBox(
                    width: icon != null ? 16 : 0,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.pTiny215ProDark33.copyWith(
                        color: txtColor,
                      ),
                    ),
                  ),
                  icCheck
                      ? Switch.adaptive(
                          value: value,
                          activeColor: AppColors.yellow16,
                          onChanged: (_value) {
                            onTap();
                          },
                        )
                      : SvgPicture.asset(AppAssets.arrowRight),
                ],
              ),
            ),
            subtitle != 0
                ? Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Text(
                      "$subtitle ${translate("work")}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppColors.greyD6,
                        fontFamily: AppTypography.fontFamilyProxima,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              height: icCheck ? 10 : 20,
            ),
            balance
                ? const SizedBox()
                : Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: icon != null ? 50 : 16),
                    color: AppColors.greyE9,
                  ),
          ],
        ),
      ),
    );
  }
}
