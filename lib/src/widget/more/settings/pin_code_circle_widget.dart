import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';

class PinCodeCircle extends StatelessWidget {
  const PinCodeCircle({super.key, this.isFilled = false, this.status});

  final bool isFilled;
  final bool? status;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14,
      width: 14,
      decoration: BoxDecoration(
        color: status != null
            ? status == true
                ? AppColors.darkGreen
                : AppColors.darkRed
            : isFilled
                ? AppColors.dark00
                : null,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: status != null
              ? status == true
                  ? AppColors.darkGreen2
                  : AppColors.darkRed2
              : AppColors.dark00,
          width: 1.5,
        ),
      ),
    );
  }
}
