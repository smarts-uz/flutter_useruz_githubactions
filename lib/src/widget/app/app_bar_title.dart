import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';

class AppBarTitle extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  const AppBarTitle({super.key, required this.text, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle ??
          AppTypography.h2Small.copyWith(
            color: AppColors.dark33,
          ),
    );
  }
}
