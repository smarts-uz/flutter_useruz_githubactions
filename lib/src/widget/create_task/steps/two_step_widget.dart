import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';

class TwoStepWidget extends StatelessWidget {
  final TextEditingController controllerText;
  final String prefIcon;
  final Function() clear;

  const TwoStepWidget({
    super.key,
    required this.controllerText,
    required this.prefIcon,
    required this.clear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: controllerText,
        cursorColor: AppColors.yellow00,
        style: AppTypography.pSmallRegularDark33,
        decoration: InputDecoration(
          label: Text(
            translate("location"),
            style: AppTypography.pSmall3Grey84.copyWith(
              color: AppColors.greyAD,
            ),
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              prefIcon,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              clear();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SvgPicture.asset(
                AppAssets.closeX,
                color: AppColors.yellow00,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
