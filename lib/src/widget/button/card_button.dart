import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';

class CardButton extends StatelessWidget {
  final String icon, title;
  final EdgeInsets margin;
  final double height, width;
  final Color color;
  final Color txtColor;
  final Function() onTap;

  const CardButton({
    super.key,
    required this.icon,
    required this.title,
    this.margin = const EdgeInsets.only(top: 16, left: 16, right: 16),
    required this.onTap,
    this.height = 60,
    this.width = 60,
    this.color = AppColors.white,
    this.txtColor = AppColors.dark33,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      // color: AppColors.white,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
            color: Color.fromRGBO(0, 0, 0, 0.08),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: AppColors.white,
          child: InkWell(
            onTap: () {
              onTap();
            },
            child: Row(
              children: [
                const SizedBox(width: 16),
                SvgPicture.asset(
                  icon,
                  color: AppColors.dark00,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamilyProxima,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    height: 1.4,
                    color: txtColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
