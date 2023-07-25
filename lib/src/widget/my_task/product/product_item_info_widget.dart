// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/utils.dart';

class ProductItemInfoWidget extends StatelessWidget {
  final TaskModel data;

  const ProductItemInfoWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // shrinkWrap: true,
        // padding: const EdgeInsets.only(
        //   left: 16,
        //   right: 16,
        //   bottom: 8,
        // ),
        // physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Text(
                data.status == 1 || data.status == 2
                    ? translate("my_task.open")
                    : data.status == 3
                        ? translate("my_task.bar.two")
                        : data.status == 4
                            ? translate("my_task.bar.three")
                            : data.status == 5
                                ? translate("my_task.bar.five")
                                : translate("my_task.bar.four"),
                style: AppTypography.pGrey97.copyWith(
                  color: data.status == 1 ||
                          data.status == 2 ||
                          data.status == 3 ||
                          data.status == 4
                      ? const Color(0xFF85C549)
                      : AppColors.red5B,
                ),
              ),
              data.status == 1 || data.status == 2
                  ? Text(
                      " ${LanguagePerformers.getLanguage() == "ru" ? translate("my_task.from") : ""} ${data.endDate.year}-${Utils.numberFormat(data.endDate.month)}-${Utils.numberFormat(data.endDate.day)} ${Utils.numberFormat(data.endDate.hour)}:${Utils.numberFormat(data.endDate.minute)} ${LanguagePerformers.getLanguage() == "uz" ? translate("my_task.from") : ""}",
                      style: AppTypography.pGrey97.copyWith(
                        color: const Color(0xFF9A9A9A),
                      ),
                    )
                  : Container(),
              const Spacer(),
              SvgPicture.asset(
                AppAssets.eye,
                color: const Color(0xFF9A9A9A),
                height: 24,
                width: 24,
              ),
              Text(
                " ${data.views}",
                style: AppTypography.pGrey97.copyWith(
                  color: const Color(0xFF9A9A9A),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            data.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: const TextStyle(
              fontFamily: AppTypography.fontFamilyProduct,
              fontWeight: FontWeight.w500,
              fontSize: 24.0,
              height: 1.2,
              color: AppColors.dark33,
            ),
          ),
          const Spacer(),
          Text(
            LanguagePerformers.getLanguage() == "ru"
                ? translate("up") +
                    " " +
                    priceFormat.format(num.parse(data.budget.toString())) +
                    " " +
                    translate("sum")
                : priceFormat.format(num.parse(data.budget.toString())) +
                    " " +
                    translate("sum") +
                    " " +
                    translate("up"),
            style: AppTypography.h2,
          ),
        ],
      ),
    );
  }
}
