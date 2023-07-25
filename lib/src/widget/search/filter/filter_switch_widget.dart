// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';

class FilterSwitchWidget extends StatelessWidget {
  final String icon, title, message;
  final bool value;
  final Function(bool _value) choose;

  const FilterSwitchWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.value,
    required this.choose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            height: 24,
            width: 24,
            color: AppColors.blueE6,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.pSmall3Dark33H14),
                Text(message, style: AppTypography.pTinyGreyADH15),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch.adaptive(
            value: value,
            activeColor: AppColors.yellow16,
            onChanged: (_value) {
              choose(_value);
            },
          ),
        ],
      ),
    );
  }
}
