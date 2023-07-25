import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';

class FiveStepWidget extends StatelessWidget {
  final String icon;
  final String title;
  final bool click;
  final Function() onTap;

  const FiveStepWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    required this.click,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        color: AppColors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                color: AppColors.yellowEE,
                borderRadius: BorderRadius.circular(84),
              ),
              child: Center(
                child: SvgPicture.asset(icon),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(title, style: AppTypography.pSmallRegularDark33),
            ),
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: click ? AppColors.yellow00 : AppColors.white,
                border: Border.all(
                  width: click ? 0 : 2,
                  color: AppColors.greyD6,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  click ? AppAssets.checks : "",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
