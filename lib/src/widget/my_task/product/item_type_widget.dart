import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/utils/utils.dart';

class ItemTypeWidget extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final DateTime now;

  const ItemTypeWidget({
    super.key,
    required this.start,
    required this.end,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          translate("my_task.begin"),
          style: AppTypography.pTinyGreyAD,
        ),
        Text(
          Utils.dateNameFormatCreateDate(start),
          style: AppTypography.pTiny215Pro,
        ),
        const SizedBox(height: 12),
        now.isBefore(DateTime(end.year, end.month, end.day, end.hour))
            ? Text(
                translate("my_task.end"),
                style: AppTypography.pTinyGreyAD,
              )
            : Container(),
        now.isBefore(DateTime(end.year, end.month, end.day, end.hour))
            ? Text(
                Utils.dateNameFormatCreateDate(end),
                style: AppTypography.pTiny215Pro,
              )
            : Container(),
      ],
    );
  }
}
