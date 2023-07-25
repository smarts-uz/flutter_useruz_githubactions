import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';

class OneStepWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function() clear;

  const OneStepWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.clear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: controller,
        cursorColor: AppColors.yellow00,
        style: AppTypography.pSmallRegularDark33,
        decoration: InputDecoration(
          label: Text(
            label,
            style: AppTypography.pSmall3Grey84.copyWith(
              color: AppColors.greyAD,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              clear();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SvgPicture.asset(AppAssets.closeCircle),
            ),
          ),
        ),
      ),
    );
  }
}
