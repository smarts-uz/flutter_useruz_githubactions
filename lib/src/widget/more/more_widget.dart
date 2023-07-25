import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';

class MoreWidget extends StatelessWidget {
  final String icon;
  final String title;
  final Function() onTap;

  const MoreWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 8),
              blurRadius: 32,
              color: Color.fromRGBO(0, 0, 0, 0.08),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                title,
                style: AppTypography.pTiny215ProDark33.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SvgPicture.asset(AppAssets.arrowRight),
          ],
        ),
      ),
    );
  }
}
