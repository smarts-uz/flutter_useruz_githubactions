// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/bloc/balance/balance.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/dialog/bottom_dialog.dart';
import 'package:youdu/src/model/api_model/balance/balance_model.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/ui/main/more/screens/profile/balance/paynet_screen.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/lib/flutter_datetime_picker.dart';
import 'package:youdu/src/utils/lib/src/i18n_model.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/loading_widget.dart';
import 'package:youdu/src/widget/balance/history_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/more/settings/settings.dart';
import 'package:youdu/src/widget/shimmer/balance_shimmer.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final ScrollController _scrollController = ScrollController();
  int filter = 0;
  int month = 0;
  bool isLoading = false;
  int page = 1;
  List<String> date = [
    translate("profile.all_operation"),
    translate("profile.year"),
    translate("profile.month"),
    translate("profile.week"),
  ];
  String language = "";
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getMoreData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Builder(
        builder: (context) {
          return CupertinoPageScaffold(
            backgroundColor: Colors.white,
            child: Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBar(
                backgroundColor: AppColors.background,
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
                title: Text(
                  translate("profile.balance"),
                  style: AppTypography.pSmallRegularDark33.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              body: StreamBuilder(
                stream: balanceBloc.allBalance,
                builder: (context, AsyncSnapshot<BalanceModel> snapshot) {
                  if (snapshot.hasData) {
                    BalanceModel data = snapshot.data!;
                    snapshot.data!.data.transaction.meta.lastPage == (page - 1)
                        ? isLoading = true
                        : isLoading = false;
                    _setData(data.data.balance);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              left: 40, right: 40, top: 32, bottom: 32),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 20,
                                color: Color.fromRGBO(0, 0, 0, 0.08),
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              priceFormat.format(data.data.balance) +
                                  " " +
                                  translate("profile.sum"),
                              style: AppTypography.h1Normal,
                            ),
                          ),
                        ),
                        SettingsWidget(
                          icon: filter == 0
                              ? AppAssets.arrowTop
                              : filter == 1
                                  ? AppAssets.arrowUp
                                  : AppAssets.arrowDown,
                          title: filter == 0
                              ? translate("all")
                              : filter == 1
                                  ? translate("pay")
                                  : translate("all_pay"),
                          color: AppColors.blueFF,
                          balance: true,
                          onTap: () {
                            BottomDialog.bottomDialogPrice(context, filter,
                                (id) {
                              filter = id;
                              page = 1;
                              isLoading = false;
                              setState(() {});
                              _getMoreData();
                            });
                          },
                        ),
                        // SettingsWidget(
                        //   icon: "assets/icons/history.svg",
                        //   title: date[month],
                        //   color: AppColors.blueFF,
                        //   onTap: () {
                        //     BottomDialog.bottomDialogDate(context, month, (id) {
                        //       month = id;
                        //       page = 1;
                        //       isLoading = false;
                        //       setState(() {});
                        //       _getMoreData();
                        //     });
                        //   },
                        // ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: AppColors.greyE9,
                        ),
                        SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    DatePicker.showDatePicker(
                                      context,
                                      showTitleActions: true,
                                      minTime: DateTime(2018, 01, 01),
                                      maxTime: DateTime.now(),
                                      onConfirm: (date) {
                                        if (date != startTime) {
                                          startTime = date;

                                          setState(() {
                                            isLoading = true;
                                          });
                                          balanceBloc
                                              .getBalance(filter, month, page,
                                                  startTime, endTime, context)
                                              .then((_) {
                                            isLoading = false;
                                            setState(() {});
                                          });
                                        }
                                      },
                                      currentTime: startTime,
                                      locale: (language == "ru")
                                          ? LocaleType.ru
                                          : LocaleType.uz,
                                    );
                                  },
                                  child: Container(
                                    height: 70,
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                translate("profile.from"),
                                                style: AppTypography.pSmall3,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                Utils.dataBalanceFormat(
                                                    startTime),
                                                style: AppTypography
                                                    .pSmallDark33Medium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    DatePicker.showDatePicker(
                                      context,
                                      showTitleActions: true,
                                      minTime: DateTime(startTime.year,
                                          startTime.month, startTime.day),
                                      maxTime: DateTime.now(),
                                      onConfirm: (date) {
                                        if (startTime.isBefore(date) ||
                                            startTime == endTime) {
                                          if (endTime != date) {
                                            endTime = date;

                                            setState(() {
                                              isLoading = true;
                                            });
                                            balanceBloc
                                                .getBalance(filter, month, page,
                                                    startTime, endTime, context)
                                                .then((_) {
                                              isLoading = false;
                                              setState(() {});
                                            });
                                          }
                                        } else {
                                          CenterDialog.errorDialog(
                                            context,
                                            translate("create_task.title"),
                                            translate("create_task.title"),
                                          );
                                        }
                                      },
                                      currentTime: endTime,
                                      locale:
                                          (LanguagePerformers.getLanguage() ==
                                                  "ru")
                                              ? LocaleType.ru
                                              : LocaleType.uz,
                                    );
                                  },
                                  child: Container(
                                    height: 70,
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              translate("profile.to"),
                                              style: AppTypography.pSmall3,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              Utils.dataBalanceFormat(endTime),
                                              style: AppTypography
                                                  .pSmallDark33Medium,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 16,
                          width: MediaQuery.of(context).size.width,
                          color: AppColors.background,
                        ),
                        Expanded(
                          child: data.data.transaction.data.isEmpty
                              ? Center(
                                  child: Text(
                                    translate(
                                      "profile.empty_data",
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.only(bottom: 65),
                                  itemCount:
                                      data.data.transaction.data.length + 1,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (_, index) {
                                    if (index ==
                                        data.data.transaction.data.length) {
                                      return LoadingWidget(
                                        key: Key(isLoading.toString()),
                                        isLoading: isLoading,
                                      );
                                    }
                                    return HistoryWidget(
                                      name: data
                                          .data.transaction.data[index].method,
                                      date: data.data.transaction.data[index]
                                          .createdAt,
                                      price: data
                                          .data.transaction.data[index].amount,
                                      state: data
                                          .data.transaction.data[index].status,
                                    );
                                  },
                                ),
                        )
                      ],
                    );
                  } else {
                    return const BalanceShimmer();
                  }
                },
              ),
              floatingActionButton: YellowButton(
                onTap: () {
                  CupertinoScaffold.showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return const PaynetScreen();
                    },
                  );
                },
                text: translate("profile.fill_balance"),
                margin: EdgeInsets.only(
                  left: 48,
                  right: 16,
                  bottom: Platform.isIOS ? 24 : 16,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _setData(int balance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("balance", balance);
    RxBus.post("_controller.text", tag: "CHANGE_IMAGE_NAME");
  }

  void _getMoreData() async {
    if (!isLoading) {
      balanceBloc.getBalance(filter, month, page, startTime, endTime, context);
      page++;
    }
  }
}
