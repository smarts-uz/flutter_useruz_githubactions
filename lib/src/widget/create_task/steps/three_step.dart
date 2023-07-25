import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';

class ThreeStepWidget extends StatelessWidget {
  final TextEditingController controllerText;
  final String suffixIcon;
  final String label;

  const ThreeStepWidget({
    super.key,
    required this.controllerText,
    required this.suffixIcon,
    required this.label,
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
            label,
            style: AppTypography.pSmall3Grey84.copyWith(
              color: AppColors.greyAD,
            ),
          ),
          suffixIcon: Container(
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(suffixIcon),
          ),
        ),
      ),
    );
  }
}
