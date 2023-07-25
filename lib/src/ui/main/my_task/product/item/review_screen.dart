// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/my_task/product/item/congrats_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class ReviewScreen extends StatefulWidget {
  final int id;
  final int status;

  const ReviewScreen({super.key, required this.id, required this.status});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  TextEditingController controller = TextEditingController();
  Repository repository = Repository();
  bool loading = false;
  int select = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.transparent,
            child: SvgPicture.asset(AppAssets.back),
          ),
        ),
        title: Container(
          color: Colors.transparent,
          child: Text(
            translate("my_task.your_task"),
            style: AppTypography.pSmallRegularDark33Bold,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(right: 24, left: 24),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 24,
            ),
            Text(
              (widget.status == 1)
                  ? translate("my_task.per_feedback")
                  : translate("my_task.customer"),
              style: AppTypography.h2SmallDark33Medium,
            ),
            const SizedBox(height: 24),
            widget.status == 0
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              select = 1;
                              setState(() {});
                            },
                            child: Container(
                              color: Colors.transparent,
                              height: 48,
                              width: 48,
                              child: SvgPicture.asset(
                                AppAssets.likeE,
                                color: select == 1
                                    ? const Color(0xFF299E51)
                                    : const Color(0xFF299E51).withOpacity(0.5),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            translate("my_task.positive"),
                            style: AppTypography.pTiny215ProDark33,
                          ),
                        ],
                      )),
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                select = 0;
                                setState(() {});
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: 48,
                                width: 48,
                                child: SvgPicture.asset(
                                  AppAssets.dislikeE,
                                  color: select == 0
                                      ? AppColors.red5B
                                      : const Color(0xFFD84A5B)
                                          .withOpacity(0.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              translate("my_task.negative"),
                              style: AppTypography.pTiny215ProDark33,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 32,
            ),
            Text(
              translate("my_task.review"),
              style: AppTypography.h2SmallDark33Medium,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.status == 0
                  ? translate("my_task.status_null1")
                  : translate("my_task.status_null2"),
              style: AppTypography.pTiny215ProGrey84,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: translate("my_task.review"),
                labelStyle: AppTypography.pTiny215ProGreyAD,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: YellowButton(
        text: translate("my_task.publish"),
        margin: const EdgeInsets.only(left: 48),
        loading: loading,
        onTap: () async {
          loading = true;
          setState(() {});
          if (widget.status == 1) {
            HttpResult response = await repository.sendReview(
              widget.status,
              select,
              controller.text,
              widget.id,
            );
            loading = false;
            setState(() {});
            if (response.isSuccess && response.result["success"] == true) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CongratsScreen(),
                ),
              );
            } else {
              if (response.status == -1) {
                CenterDialog.networkErrorDialog(context);
              } else {
                CenterDialog.errorDialog(
                  context,
                  Utils.serverErrorText(response),
                  response.result.toString(),
                );
              }
            }
          } else {
            HttpResult response =
                await repository.notComplete(controller.text, widget.id);
            loading = false;
            setState(() {});
            if (response.isSuccess && response.result["success"] == true) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CongratsScreen(),
                ),
              );
            } else {
              if (response.status == -1) {
                CenterDialog.networkErrorDialog(context);
              } else {
                CenterDialog.errorDialog(
                  context,
                  Utils.serverErrorText(response),
                  response.result.toString(),
                );
              }
            }
          }
        },
      ),
    );
  }
}
