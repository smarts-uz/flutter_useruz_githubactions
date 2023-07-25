import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/widget/my_task/dialog/choose_type_dialog.dart';

class AnotherUserWidget extends StatelessWidget {
  final TaskModel data;

  const AnotherUserWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: Platform.isIOS ? 24 : 16,
      ),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return ChooseTypeDialog(data: data);
            },
          );
        },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9416),
            borderRadius: BorderRadius.circular(16),
          ),
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              translate("respond"),
              style: AppTypography.pSmall1SemiBoldWhite,
            ),
          ),
        ),
      ),
    );
  }
}
