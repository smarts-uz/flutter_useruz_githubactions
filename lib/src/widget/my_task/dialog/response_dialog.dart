// ignore_for_file: use_build_context_synchronously

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/task/task_view_bloc.dart';
import 'package:youdu/src/bloc/task/tasks_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/more/screens/profile/response_templates/use_template_screen.dart';
import 'package:youdu/src/ui/main/performers/add_performers/main_view_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class ResponseDialog extends StatefulWidget {
  final int response;
  final int id;
  final String title;

  const ResponseDialog({
    super.key,
    required this.response,
    required this.id,
    required this.title,
  });

  @override
  State<ResponseDialog> createState() => _ResponseDialogState();
}

class _ResponseDialogState extends State<ResponseDialog> {
  TextEditingController price = TextEditingController();
  final TextEditingController description = TextEditingController();
  Repository repository = Repository();
  bool loading = false;
  String? error;

  @override
  void initState() {
    price.addListener(() {
      error = null;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          (MediaQuery.of(context).size.height / 3) +
          100,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 50,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ListView(
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.closeX,
                      height: 24,
                      width: 24,
                      color: AppColors.yellow16,
                    ),
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  width: 36,
                ),
                Text(
                  widget.title,
                  style: AppTypography.pSmall1,
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => UseTemplatesScreen(
                            onTapped: (String text) {
                              description.text = text;
                            },
                          ),
                        ),
                      );
                    },
                    child: Text(
                      translate("profile.templates"),
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamilyProduct,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        height: 1.6,
                        color: AppColors.yellow16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.white,
            child: TextField(
              maxLength: 350,
              maxLines: 3,
              controller: description,
              style: AppTypography.pSmall3Dark00.copyWith(
                color: AppColors.dark33,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: translate("response_text"),
                labelStyle: AppTypography.pTinyDark33Normal.copyWith(
                  color: AppColors.greyAD,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("response_title"),
              style: AppTypography.pTinyDark33Normal.copyWith(
                color: AppColors.greyAD,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            color: AppColors.white,
            child: TextField(
              controller: price,
              keyboardType: TextInputType.number,
              maxLength: 18,
              inputFormatters: [
                CurrencyTextInputFormatter(
                  symbol: " ${translate(("sum"))}",
                  enableNegative: false,
                  decimalDigits: 0,
                ),
              ],
              style: AppTypography.pTiny215ProDark33,
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: "",
                labelText: translate("suggested_price"),
                labelStyle: AppTypography.pTinyDark33Normal.copyWith(
                  color: error != null ? AppColors.red5B : AppColors.greyAD,
                ),
                prefixIcon: Container(
                  height: 24,
                  width: 24,
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(AppAssets.moneyBug),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          YellowButton(
            text: translate("respond"),
            loading: loading,
            onTap: () async {
              try {
                int k = int.parse(price.text
                    .replaceAll(RegExp(r'[^0-9]'), '')
                    .replaceAll(' ', ''));

                if (price.text.replaceAll(RegExp(r'[^0-9]'), '') != "" &&
                    price.text.replaceAll(RegExp(r'[^0-9]'), '') != "0" &&
                    description.text != "" &&
                    description.text.length > 5 &&
                    k >= Utils.priceValidator) {
                  loading = true;
                  setState(() {});

                  HttpResult response = await repository.otklik(
                    widget.id,
                    k.toString(),
                    description.text,
                    widget.response,
                  );
                  loading = false;
                  setState(() {});
                  if (response.isSuccess) {
                    if (response.result["success"] == true) {
                      CenterDialog.messageDialog(
                          context, translate("add_respond"), () {
                        taskBloc.getInfoTask(widget.id, context);
                        taskViewBloc.getOtklik(widget.id, "rating", 1, context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    } else {
                      try {
                        if (response.result["data"] == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainViewScreen(),
                            ),
                          );
                        } else {
                          CenterDialog.errorDialog(
                            context,
                            Utils.serverErrorText(response),
                            response.result.toString(),
                          );
                        }
                      } catch (_) {
                        CenterDialog.errorDialog(
                          context,
                          Utils.serverErrorText(response),
                          response.result.toString(),
                        );
                      }
                    }
                  } else if (response.status == -1) {
                    CenterDialog.networkErrorDialog(context);
                  } else {
                    CenterDialog.errorDialog(
                      context,
                      Utils.serverErrorText(response),
                      response.result.toString(),
                    );
                  }
                } else {
                  if (k <= Utils.priceValidator) {
                    error = "";
                    setState(() {});
                  } else if (price.text == "" || price.text == "0") {
                    CenterDialog.messageDialog(
                        context, translate("price"), () {});
                  } else {
                    CenterDialog.messageDialog(
                        context, translate("null_text"), () {});
                  }
                }
              } catch (e) {
                CenterDialog.errorDialog(context, e.toString(), e.toString());
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
