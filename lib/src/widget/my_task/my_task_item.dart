import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/my_task/item/my_task_item_screen.dart';

class MyTaskItemWidget extends StatelessWidget {
  final String icon, message, title;
  final double iconSize;
  final bool arrow;
  final int status;
  final int performer;

  const MyTaskItemWidget({
    super.key,
    required this.icon,
    required this.message,
    required this.title,
    required this.status,
    required this.performer,
    this.iconSize = 24,
    this.arrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MyTaskItemScreen(
                title: title,
                status: status,
                performer: performer,
                perform: false,
                performId: 0,
              );
            },
          ),
        );
      },
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: iconSize,
              width: iconSize,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamilyProxima,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      height: 1.4,
                      color: AppColors.dark33,
                    ),
                  ),
                  Text(
                    message,
                    style: AppTypography.tinyText2Large,
                  ),
                ],
              ),
            ),
            SizedBox(width: arrow ? 16 : 0),
            arrow
                ? SvgPicture.asset(AppAssets.arrowRight, height: 24, width: 24)
                : Container(),
          ],
        ),
      ),
    );
  }
}
