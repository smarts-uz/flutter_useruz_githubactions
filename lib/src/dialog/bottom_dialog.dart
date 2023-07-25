// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/status_model.dart';
import 'package:youdu/src/widget/dialog/jaloba_widget.dart';
import 'package:youdu/src/widget/report_screen.dart';

class BottomDialog {
  static void showBottomCalendarTypeDialog(
    BuildContext context,
    int type,
    Function(int _type) choose,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 320,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Center(
                  child: Text(
                    translate("create_task.date_type"),
                    style: AppTypography.h3Large,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, position) {
                    int index = position + 1;
                    return GestureDetector(
                      onTap: () {
                        choose(index);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 56,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                index == 1
                                    ? translate("create_task.date_type_1")
                                    : index == 2
                                        ? translate("create_task.date_type_2")
                                        : translate("create_task.date_type_3"),
                                style: AppTypography.pDark33,
                              ),
                            ),
                            Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: type == index
                                      ? AppColors.yellow16
                                      : AppColors.greyE9,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: type == index
                                        ? AppColors.yellow16
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void bottomDialogPrice(
      BuildContext context, int type, Function(int id) onTap) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  onTap(0);
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppAssets.arrowTop),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          translate("all"),
                          style: AppTypography.pSmallRegularDark00,
                        ),
                      ),
                      type == 0
                          ? SvgPicture.asset(AppAssets.choise)
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(60, 60, 67, 0.36),
              ),
              GestureDetector(
                onTap: () {
                  onTap(1);
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppAssets.arrowUp),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          translate("pay"),
                          style: AppTypography.pSmallRegularDark00,
                        ),
                      ),
                      type == 1
                          ? SvgPicture.asset(AppAssets.choise)
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(60, 60, 67, 0.36),
              ),
              GestureDetector(
                onTap: () {
                  onTap(2);
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppAssets.arrowDown),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          translate("all_pay"),
                          style: AppTypography.pSmallRegularDark00,
                        ),
                      ),
                      type == 2
                          ? SvgPicture.asset(AppAssets.choise)
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(60, 60, 67, 0.36),
              ),
            ],
          ),
        );
      },
    );
  }

  static void bottomDialogDate(
      BuildContext context, int type, Function(int id) onTap) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  onTap(0);
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    children: [
                      // SvgPicture.asset(
                      //   "assets/icons/arrow_top.svg",
                      // ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          translate("profile.all_operation"),
                          style: AppTypography.pSmallRegularDark00,
                        ),
                      ),
                      type == 0
                          ? SvgPicture.asset(AppAssets.choise)
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(60, 60, 67, 0.36),
              ),
              GestureDetector(
                onTap: () {
                  onTap(1);
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          translate("profile.year"),
                          style: AppTypography.pSmallRegularDark00,
                        ),
                      ),
                      type == 1
                          ? SvgPicture.asset(AppAssets.choise)
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(60, 60, 67, 0.36),
              ),
              GestureDetector(
                onTap: () {
                  onTap(2);
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          translate("profile.month"),
                          style: AppTypography.pSmallRegularDark00,
                        ),
                      ),
                      type == 2
                          ? SvgPicture.asset(AppAssets.choise)
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(60, 60, 67, 0.36),
              ),
              GestureDetector(
                onTap: () {
                  onTap(3);
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          translate("profile.week"),
                          style: AppTypography.pSmallRegularDark00,
                        ),
                      ),
                      type == 3
                          ? SvgPicture.asset(AppAssets.choise)
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(60, 60, 67, 0.36),
              ),
            ],
          ),
        );
      },
    );
  }

  static void reportDialog(BuildContext context, int id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ReportScreen(id: id);
      },
    );
  }

  static void bottomDialogProfile(
    BuildContext context,
    bool view,
    Function(int id) onTap, {
    bool block = true,
    bool unBlock = false,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: !view
              ? !block
                  ? 260
                  : 300
              : 180,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              view
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onTap(0);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 56,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.blue32,
                        ),
                        child: Center(
                          child: Text(
                            translate("jaloba"),
                            style: AppTypography.pSmallRegularWhite,
                          ),
                        ),
                      ),
                    ),
              view || !block
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onTap(2);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 56,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.blue32,
                        ),
                        child: Center(
                          child: Text(
                            unBlock
                                ? translate("un_block")
                                : translate("block"),
                            style: AppTypography.pSmallRegularWhite,
                          ),
                        ),
                      ),
                    ),
              GestureDetector(
                onTap: () {
                  onTap(1);
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.blue32,
                  ),
                  child: Center(
                    child: Text(
                      translate("share"),
                      style: AppTypography.pSmallRegularWhite,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  onTap(2);
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.blue32,
                  ),
                  child: Center(
                    child: Text(
                      translate("create_task.break"),
                      style: AppTypography.pSmallRegularWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void bottomDialogText(
      BuildContext context,
      StatusModel statusModel,
      Function(String text) onTap,
      TextEditingController controller,
      Function(int id) onTapId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return JalobaWidget(
          controller: controller,
          onTap: onTap,
          statusModel: statusModel,
          onTapId: onTapId,
        );
      },
    );
  }
}
