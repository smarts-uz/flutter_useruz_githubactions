import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youdu/src/constants/constants.dart';

class SearchTextWidget extends StatelessWidget {
  final EdgeInsets margin;
  final String text;
  final Function() onTap;
  final Color color;

  const SearchTextWidget({
    super.key,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    required this.text,
    required this.onTap,
    this.color = AppColors.greyF4,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: margin,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            SvgPicture.asset(AppAssets.search, height: 24, width: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: AppTypography.pSmallGrey85,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
