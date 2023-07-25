import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/tasks_model.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/ui/main/my_task/product/product_item_screen.dart';
import 'package:youdu/src/utils/language_performers.dart';

class TaskBottomDialog extends StatelessWidget {
  final TaskModelResult data;

  const TaskBottomDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductItemScreen(
              id: data.id,
            ),
          ),
        );
      },
      child: Container(
        height: 132,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: Platform.isIOS ? s.height / 6 : 84,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    data.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.pSmall1SemiBoldDark33,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    AppAssets.closeX,
                    height: 24,
                    width: 24,
                  ),
                )
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.addressLocation,
                  height: 14,
                  width: 14,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    data.addresses.isNotEmpty ? data.addresses[0].location : "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.pTiny,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset(AppAssets.clock, height: 14, width: 14),
                const SizedBox(width: 4),
                Text(
                  translate("create_task.begin"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.pTiny,
                ),
                Expanded(
                  child: Text(
                    data.startDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.pTiny,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  LanguagePerformers.getLanguage() == "ru"
                      ? "${translate("up")} ${priceFormat.format(num.parse(data.budget.toString()))} ${translate("sum")}"
                      : "${priceFormat.format(num.parse(data.budget.toString()))} ${translate("sum")} ${translate("up")}",
                  style: AppTypography.pSmall3Dark3306,
                ),
                const SizedBox(width: 12),
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: AppColors.yellowEE.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      data.oplata == "1" ? AppAssets.card : AppAssets.cash,
                      height: 16,
                      width: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
