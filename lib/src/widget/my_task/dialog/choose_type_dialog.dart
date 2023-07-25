// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/widget/my_task/dialog/response_dialog.dart';

class ChooseTypeDialog extends StatelessWidget {
  final TaskModel data;

  const ChooseTypeDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: MediaQuery.of(context).size.height / 2 + 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFC4C4C4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                translate("review_title"),
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamilyProxima,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  height: 1.2,
                  color: AppColors.dark00,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return ResponseDialog(
                    response: 1,
                    id: data.id,
                    title: translate("ordinary"),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(top: 24),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark00.withOpacity(0.08),
                      offset: const Offset(0, 4),
                      blurRadius: 20,
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          translate("ordinary"),
                          style: AppTypography.pSmallDark00,
                        ),
                      ),
                      Text(
                        data.responsePrice + " UZS",
                        style: AppTypography.pSmallDark00,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      translate("choose_title"),
                      style: AppTypography.pTinyDark00,
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return ResponseDialog(
                    response: 0,
                    id: data.id,
                    title: translate("postpaid"),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(top: 16),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark00.withOpacity(0.08),
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          translate("postpaid"),
                          style: AppTypography.pSmallDark00,
                        ),
                      ),
                      const Text(
                        "0 UZS",
                        style: AppTypography.pSmallDark00,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "• ${translate("choose_request1")}\n• ${translate("choose_request2")} ${data.freeResponse} ${translate("choose_request3")}",
                      style: AppTypography.pTinyDark00,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
