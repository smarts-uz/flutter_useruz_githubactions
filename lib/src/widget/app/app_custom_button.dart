import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';

class AppCustomButton extends StatelessWidget {
  final String title;
  final bool loading;
  final Function() onTap;
  final EdgeInsets margin;
  final Color color;

  const AppCustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color = AppColors.yellow16,
    this.margin = EdgeInsets.zero,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 370),
        curve: Curves.easeInOut,
        margin: margin,
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color,
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator.adaptive()
              : Text(
                  title,
                  style: AppTypography.pSmall1SemiBoldWhite.copyWith(
                    height: 1.4,
                  ),
                ),
        ),
      ),
    );
  }
}
