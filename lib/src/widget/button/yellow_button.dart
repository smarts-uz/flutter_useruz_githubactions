import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';

class YellowButton extends StatelessWidget {
  final String text;
  final bool loading;
  final EdgeInsets margin;
  final Function() onTap;
  final Color color;
  final bool? isDisabled;

  const YellowButton({
    super.key,
    required this.text,
    required this.onTap,
    this.loading = false,
    this.isDisabled = false,
    this.color = AppColors.yellow16,
    this.margin = const EdgeInsets.only(left: 16, right: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: margin,
      decoration: BoxDecoration(
        color: isDisabled! ? color.withOpacity(0.4) : color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: isDisabled! ? color.withOpacity(0.4) : color,
          child: InkWell(
            onTap: () {
              onTap();
            },
            child: Center(
              child: loading
                  ? const CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      text,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamilyProxima,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        height: 1.5,
                        color: AppColors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
