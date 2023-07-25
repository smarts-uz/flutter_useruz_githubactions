import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';

class BorderButton extends StatelessWidget {
  const BorderButton({
    super.key,
    this.margin = const EdgeInsets.only(left: 16, right: 16),
    this.isDisabled = false,
    required this.onTap,
    required this.text,
    required this.txtColor,
  });

  final Function() onTap;
  final EdgeInsets margin;
  final Color txtColor;
  final String text;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: margin,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyD6, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: AppColors.white,
          child: InkWell(
            onTap: () {
              onTap();
            },
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamilyProxima,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  height: 1.5,
                  color: isDisabled ? txtColor.withOpacity(0.4) : txtColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
