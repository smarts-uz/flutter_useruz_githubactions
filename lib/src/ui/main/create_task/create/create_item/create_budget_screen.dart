// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

import '../../../../../model/http_result.dart';
import '../../../../../utils/language_performers.dart';
import '../../../../../widget/app/app_custom_button.dart';

class CreateBudgetScreen extends StatefulWidget {
  final int taskId;
  final TaskModel? taskModel;
  final Function(String _route) nextPage;

  const CreateBudgetScreen({
    super.key,
    required this.taskId,
    required this.nextPage,
    required this.taskModel,
  });

  @override
  State<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen>
    with AutomaticKeepAliveClientMixin<CreateBudgetScreen> {
  @override
  bool get wantKeepAlive => true;
  int budget = -1, allPrice = 0;

  int paymentType = 1;
  bool loading = false;
  bool manual = false;
  bool manual1 = false;
  String lang = LanguagePerformers.getLanguage();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    _initBus();
    if (widget.taskModel != null) {
      paymentType = int.parse(widget.taskModel!.pay);
      budget = widget.taskModel!.budget;

      setState(() {});
    }
    setState(() {});
    super.initState();
  }

  String _formatNumber(String s) =>
      s != "" ? NumberFormat.decimalPattern("ru").format(int.parse(s)) : "0";
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate("create_task.budjet_title"),
              style: AppTypography.h2SmallSemiBold,
            ),
            const SizedBox(height: 16),
            Text(
              translate("create_task.budjet_label"),
              style: AppTypography.pTiny215GreyAD,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    translate("create_task.enter_budget"),
                    style: AppTypography.pSmallRegularDark33,
                  ),
                ),
                Switch.adaptive(
                  value: manual,
                  activeColor: AppColors.yellow16,
                  onChanged: (value) {
                    setState(() {
                      if (manual1 == false) {
                        _priceController.text = (budget == -1)
                            ? priceFormat.format(allPrice ~/ (5))
                            : priceFormat.format(budget);
                      }
                      manual = value;
                      manual1 = true;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 1,
              color: AppColors.greyE9,
            ),
            const SizedBox(height: 16),
            manual1
                ? const SizedBox()
                : Text(
                    lang == "ru"
                        ? translate("up") +
                            " " +
                            ((budget == -1)
                                ? priceFormat.format(allPrice ~/ (5))
                                : priceFormat.format(budget)) +
                            " " +
                            translate("sum")
                        : ((budget == -1)
                                ? priceFormat.format(allPrice ~/ (5))
                                : priceFormat.format(budget)) +
                            " " +
                            translate("sum") +
                            " " +
                            translate("up"),
                    style: AppTypography.h1Normal,
                  ),
            !manual1
                ? const SizedBox()
                : TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    enabled: manual,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    onChanged: (string) {
                      setPrice(string);
                    },
                    cursorColor: AppColors.dark33,
                    style: AppTypography.h1Normal,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      counterText: "",
                      prefix: lang == "ru"
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                translate("up"),
                                style: AppTypography.h1Normal,
                              ),
                            )
                          : null,
                      suffixText: lang == "ru"
                          ? translate("sum")
                          : translate("sum") + " " + translate("up"),
                      suffixStyle: AppTypography.h1Normal,
                      border: InputBorder.none,
                    ),
                  ),
            Container(
              height: 1,
              color: AppColors.greyE9,
            ),
            const SizedBox(height: 12),
            Visibility(
              visible: !manual,
              child: SizedBox(
                height: 26,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, position) {
                    int index = position;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _priceController.text =
                              (allPrice ~/ 5 * (index + 1)).toString();
                          setPrice(_priceController.text);
                          budget = allPrice ~/ 5 * (index + 1);
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 370),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.only(right: 8),
                        height: 26,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: allPrice ~/ 5 * (index + 1) == budget ||
                                  (budget == -1 && index == 0)
                              ? const Color(0xFF005A91)
                              : Colors.white,
                          border: Border.all(
                            color: allPrice ~/ 5 * (index + 1) == budget ||
                                    (budget == -1 && index == 0)
                                ? const Color(0xFF005A91)
                                : AppColors.greyAD,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            lang == "ru"
                                ? translate("up") +
                                    " " +
                                    priceFormat
                                        .format(allPrice ~/ 5 * (index + 1))
                                : priceFormat
                                        .format(allPrice ~/ 5 * (index + 1)) +
                                    " " +
                                    translate("up"),
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamilyProxima,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: allPrice ~/ 5 * (index + 1) == budget ||
                                      (budget == -1 && index == 0)
                                  ? Colors.white
                                  : const Color(0xFF005A91),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              translate("create_task.budjet_type"),
              style: AppTypography.h2SmallSemiBold,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  paymentType = 1;
                });
              },
              child: Container(
                height: 60,
                color: Colors.transparent,
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: AppColors.yellowEE,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Center(
                        child: SvgPicture.asset(AppAssets.cash),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        translate("create_task.budjet_cash"),
                        style: AppTypography.pSmallDark33H11,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 370),
                      curve: Curves.easeInOut,
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: paymentType == 1
                            ? AppColors.yellow00
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: paymentType == 1
                              ? AppColors.yellow00
                              : AppColors.greyD6,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(AppAssets.createCheck),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  paymentType = 0;
                });
              },
              child: Container(
                height: 60,
                color: Colors.transparent,
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: AppColors.yellowEE,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Center(
                        child: SvgPicture.asset(AppAssets.card),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        translate("create_task.budjet_online"),
                        style: AppTypography.pSmallDark33H11,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 370),
                      curve: Curves.easeInOut,
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: paymentType == 0
                            ? AppColors.yellow00
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: paymentType == 0
                              ? AppColors.yellow00
                              : AppColors.greyD6,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(AppAssets.createCheck),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AppCustomButton(
        color: widget.taskModel != null
            ? widget.taskModel!.budget != 0
                ? AppColors.yellow16
                : !manual
                    ? budget != 0
                        ? AppColors.yellow16
                        : AppColors.greyD6
                    : _priceController.text
                                .replaceAll(RegExp(r"\s+"), "")
                                .toString() ==
                            ""
                        ? AppColors.greyD6
                        : _priceController.text
                                    .replaceAll(RegExp(r"\s+"), "")
                                    .toString() ==
                                "0"
                            ? AppColors.greyD6
                            : AppColors.yellow16
            : manual
                ? _priceController.text
                            .replaceAll(RegExp(r"\s+"), "")
                            .toString() ==
                        ""
                    ? AppColors.greyD6
                    : _priceController.text
                                .replaceAll(RegExp(r"\s+"), "")
                                .toString() ==
                            "0"
                        ? AppColors.greyD6
                        : AppColors.yellow16
                : AppColors.yellow16,
        loading: loading,
        margin: EdgeInsets.only(bottom: Platform.isIOS ? 32 : 24, left: 32),
        onTap: widget.taskModel != null
            ? widget.taskModel!.budget != 0
                ? sendData
                : !manual
                    ? budget != 0
                        ? sendData
                        : () {}
                    : _priceController.text
                                .replaceAll(RegExp(r"\s+"), "")
                                .toString() ==
                            ""
                        ? () {}
                        : _priceController.text
                                    .replaceAll(RegExp(r"\s+"), "")
                                    .toString() ==
                                "0"
                            ? () {}
                            : sendData
            : manual
                ? _priceController.text
                            .replaceAll(RegExp(r"\s+"), "")
                            .toString() ==
                        ""
                    ? () {}
                    : _priceController.text
                                .replaceAll(RegExp(r"\s+"), "")
                                .toString() ==
                            "0"
                        ? () {}
                        : sendData
                : sendData,
        title: translate("next"),
      ),
    );
  }

  void sendData() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    if (kDebugMode) {
      print(_priceController.text + "--------------------------");
    }

    var price = widget.taskModel != null
        ? widget.taskModel!.budget != -1
            ? !manual
                ? budget
                : _priceController.text
                            .replaceAll(RegExp(r"\s+"), "")
                            .toString() ==
                        ""
                    ? allPrice ~/ 5
                    : _priceController.text
                                .replaceAll(RegExp(r"\s+"), "")
                                .toString() ==
                            "0"
                        ? allPrice ~/ 5
                        : int.parse(_priceController.text
                            .replaceAll(RegExp(r"\s+"), ""))
            : int.parse(_priceController.text.replaceAll(RegExp(r"\s+"), ""))
        : manual
            ? _priceController.text.replaceAll(RegExp(r"\s+"), "").toString() ==
                    ""
                ? allPrice ~/ 5
                : _priceController.text
                            .replaceAll(RegExp(r"\s+"), "")
                            .toString() ==
                        "0"
                    ? allPrice ~/ 5
                    : int.parse(
                        _priceController.text.replaceAll(RegExp(r"\s+"), ""))
            : budget == -1
                ? allPrice ~/ 5
                : budget;
    HttpResult response = await createBloc.createBudget(
      price,
      paymentType,
      widget.taskId,
      widget.taskModel,
    );

    if (response.isSuccess) {
      CreateRouteModel data = CreateRouteModel.fromJson(response.result);
      if (data.success) {
        widget.nextPage(
          data.data.route,
        );
      } else {
        CenterDialog.errorDialog(
          context,
          Utils.serverErrorText(response),
          response.result.toString(),
        );
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

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    RxBus.destroy(tag: "CREATE_BUGDET");
    super.dispose();
  }

  void setPrice(String string) {
    string = _formatNumber(string.replaceAll(',', ''));
    _priceController.value = TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }

  void _initBus() {
    RxBus.register<int>(tag: "CREATE_BUGDET").listen((event) {
      allPrice = event;
      if (mounted) {
        setState(() {});
      }
    });
  }
}
