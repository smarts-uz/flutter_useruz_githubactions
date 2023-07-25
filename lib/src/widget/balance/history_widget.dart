import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/utils/utils.dart';

class HistoryWidget extends StatelessWidget {
  final String name;
  final DateTime date;
  final int price;
  final int state;

  const HistoryWidget({
    super.key,
    required this.name,
    required this.date,
    required this.price,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.pTiny215ProDark33,
                  ),
                  Text(
                    "${Utils.numberFormat(date.day)} ${Utils.monthFormat(date.month)} ${date.year}",
                    style: AppTypography.pTinyDark33Normal.copyWith(
                      color: AppColors.greyAD,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                "${(state == 0) ? "-" : "+"} ${priceFormat.format(price)} UZS",
                style: AppTypography.pTinyDark33Normal.copyWith(
                  color: (state == 0) ? AppColors.red5B : AppColors.green,
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: AppColors.background,
          ),
        ],
      ),
    );
  }
}
