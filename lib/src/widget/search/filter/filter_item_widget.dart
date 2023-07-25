import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';

class FilterItemWidget extends StatelessWidget {
  final Function() onTap;
  final String icon, message;
  final String? title;
  final double iconSize;
  final bool arrow;
  final Color color;

  const FilterItemWidget({
    super.key,
    required this.onTap,
    required this.icon,
    this.title,
    this.color = AppColors.white,
    required this.message,
    this.iconSize = 24,
    this.arrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              height: iconSize,
              width: iconSize,
              decoration: iconSize != 24
                  ? BoxDecoration(
                      color: const Color(0xFFE6F4FC),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              padding:
                  iconSize != 24 ? const EdgeInsets.all(8) : EdgeInsets.zero,
              child: SvgPicture.asset(
                icon,
                height: iconSize,
                width: iconSize,
                color: AppColors.blueE6,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  message == "" ? Container(height: 4) : Container(),
                  title == null
                      ? Container()
                      : Text(title!, style: AppTypography.pSmall3Dark33H15),
                  message == ""
                      ? Container(height: 4)
                      : Text(
                          message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.pTinyGreyAD,
                        ),
                ],
              ),
            ),
            SizedBox(width: arrow ? 16 : 0),
            arrow
                ? SvgPicture.asset(
                    AppAssets.arrowRight,
                    height: 24,
                    width: 24,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
