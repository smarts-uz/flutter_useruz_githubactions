// ignore_for_file: sort_child_properties_last

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/my_task/product/product_item_screen.dart';
import 'package:youdu/src/widget/app/app_custom_button.dart';

class SuccessScreen extends StatefulWidget {
  final int id;
  final bool edit;

  const SuccessScreen({super.key, required this.id, required this.edit});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductItemScreen(
              id: widget.id,
            ),
          ),
        );
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset(AppAssets.createSuccess),
                    margin: const EdgeInsets.symmetric(horizontal: 44),
                  ),
                  const SizedBox(height: 44),
                  Text(
                    widget.edit
                        ? translate("task_edit")
                        : translate("create_task.success"),
                    textAlign: TextAlign.center,
                    style: AppTypography.h2SmallDark33SBold,
                  ),
                ],
              ),
            ),
            AppCustomButton(
              title: translate("create_task.back_home"),
              margin: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: Platform.isIOS ? 32 : 24,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductItemScreen(id: widget.id),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
