// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:youdu/src/bloc/task/tasks_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/model/api_model/tasks/task_filter_model.dart';
import 'package:youdu/src/model/total_model.dart';
import 'package:youdu/src/ui/main/search/filter/item/category/filter_category_screen.dart';
import 'package:youdu/src/ui/main/search/filter/item/map/map_filter_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/circle_thumb_shape.dart';
import 'package:youdu/src/widget/search/filter/filter_item_widget.dart';
import 'package:youdu/src/widget/search/filter/filter_switch_widget.dart';

class FilterScreen extends StatefulWidget {
  final TaskFilterModel data;
  final Function(TaskFilterModel _data) selected;

  const FilterScreen({
    super.key,
    required this.data,
    required this.selected,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double _distance = 51;
  int budget = 0;
  List<CategoryModel> _category = [];
  String address = "";
  double latitude = 41, longitude = 69;
  bool remote = false, response = false, work = false;
  bool loading = false;

  final TextEditingController _controllerPrice = TextEditingController();

  @override
  void initState() {
    taskBloc.getFilterCount(widget.data, context);
    _distance = widget.data.distance;
    budget = widget.data.budget;
    _category = widget.data.category;
    address = widget.data.address;
    longitude = widget.data.longitude;
    latitude = widget.data.latitude;
    remote = widget.data.remote;
    response = widget.data.response;
    work = widget.data.work;
    _controllerPrice.text = budget == 0 ? "" : budget.toString();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool allSelected = true;
    int count = 0;
    for (int i = 0; i < _category.length; i++) {
      if (!_category[i].selectedItem) {
        allSelected = false;
        if (_category[i].chooseItem.isNotEmpty) {
          count += _category[i].chooseItem.length;
        }
      } else if (_category[i].selectedItem && _category[i].childCount != 0) {
        count += _category[i].childCount;
      }
    }
    return CupertinoScaffold(
      body: Builder(
        builder: (context) {
          return CupertinoPageScaffold(
            backgroundColor: Colors.white,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.white,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: AppColors.white,
                leading: GestureDetector(
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
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        _distance = 51;
                        for (int i = 0; i < _category.length; i++) {
                          _category[i].selectedItem = false;
                          _category[i].chooseItem = [];
                        }
                        address = "";
                        budget = 0;
                        latitude = 41.311081;
                        longitude = 69.240562;
                        remote = false;
                        response = false;
                        work = false;
                        _controllerPrice.text = "";
                        _sendData();
                        setState(() {});
                      },
                      child: Text(
                        translate("filter.clear"),
                        style: AppTypography.pSmall3Yellow16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                title: Text(
                  translate("filter.title"),
                  style: AppTypography.pSmall1,
                ),
              ),
              body: StreamBuilder<TaskCount>(
                stream: taskBloc.getTaskCount,
                builder: (context, snapshot) {
                  int countResult = 0;
                  if (snapshot.hasData) {
                    countResult = snapshot.data!.total;
                    loading = false;
                  } else {
                    loading = true;
                  }
                  String text = translate("filter.result");
                  if (countResult != 0) {
                    text += " " + countResult.toString();
                  } else if (countResult == 0) {
                    text = translate("filter.no_result");
                  }
                  return Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: AppColors.greyE9,
                          ),
                          Expanded(
                            child: ListView(
                              children: [
                                FilterItemWidget(
                                  icon: AppAssets.category,
                                  title: translate("filter.category"),
                                  message: allSelected
                                      ? translate("filter.all_category")
                                      : count == 0
                                          ? ""
                                          : "${translate("filter.choose")} $count ${translate("filter.us")}",
                                  onTap: () {
                                    CupertinoScaffold
                                        .showCupertinoModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return FilterCategoryScreen(
                                          category: _category,
                                          selected: (List<CategoryModel>
                                                  _categorySelected,
                                              {List<int> all = const <int>[]}) {
                                            setState(() {
                                              _category = _categorySelected;
                                              _sendData();
                                            });
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                                Container(
                                  height: 16,
                                  width: MediaQuery.of(context).size.width,
                                  color: const Color(0xFFFAF8F5),
                                ),
                                FilterItemWidget(
                                  icon: AppAssets.addressLocation,
                                  title: translate("filter.location"),
                                  message: address,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return MapFilterScreen(
                                            filterData: widget.data,
                                            value: _distance,
                                            address: address,
                                            longitude: longitude,
                                            latitude: latitude,
                                            change: (
                                              double _latitude,
                                              double _longitude,
                                              String _address,
                                              double value,
                                            ) {
                                              setState(() {
                                                _distance = value;
                                                longitude = _longitude;
                                                latitude = _latitude;
                                                address = _address;
                                                _sendData();
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  height: 1,
                                  margin: const EdgeInsets.only(left: 56),
                                  width: MediaQuery.of(context).size.width,
                                  color: const Color(0xFFEFEDE9),
                                ),
                                Container(
                                  color: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppAssets.gps,
                                        height: 24,
                                        width: 24,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                bottom: 4,
                                              ),
                                              child: Text(
                                                "${translate("filter.search")} ${_distance.toInt() == 150 ? "∞" : _distance.toInt()} ${translate("km")}",
                                                style:
                                                    AppTypography.pTinyGreyAD,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 8,
                                              ),
                                              child: SliderTheme(
                                                data: SliderTheme.of(context)
                                                    .copyWith(
                                                  activeTrackColor:
                                                      AppColors.yellow16,
                                                  inactiveTrackColor:
                                                      const Color(0xFFFAF8F5),
                                                  thumbColor:
                                                      AppColors.yellow16,
                                                  overlayShape:
                                                      const RoundSliderOverlayShape(
                                                    overlayRadius: 2,
                                                  ),
                                                  thumbShape:
                                                      const CircleThumbShape(
                                                    thumbRadius: 10,
                                                  ),
                                                ),
                                                child: Slider(
                                                  max: 150,
                                                  min: 1.5,
                                                  divisions: null,
                                                  onChangeEnd: (newValue) {
                                                    setState(() {
                                                      _distance = newValue;
                                                      _sendData();
                                                    });
                                                  },
                                                  value: _distance,
                                                  onChanged: (newValue) {
                                                    _distance = newValue;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 16,
                                  width: MediaQuery.of(context).size.width,
                                  color: const Color(0xFFFAF8F5),
                                ),
                                Container(
                                  color: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE6F4FC),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: SvgPicture.asset(
                                          AppAssets.price,
                                          height: 24,
                                          width: 24,
                                          color: AppColors.blueE6,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(height: 4),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        _controllerPrice,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    maxLength: 18,
                                                    inputFormatters: [
                                                      CurrencyTextInputFormatter(
                                                        symbol:
                                                            " ${translate(("sum"))}",
                                                        enableNegative: false,
                                                        decimalDigits: 0,
                                                      ),
                                                    ],
                                                    onChanged: (value) {
                                                      try {
                                                        int k = 0;
                                                        for (int i = 0;
                                                            i < value.length;
                                                            i++) {
                                                          try {
                                                            k = k * 10 +
                                                                int.parse(
                                                                    value[i]);
                                                          } catch (_) {}
                                                        }
                                                        budget = k;

                                                        _sendData();
                                                      } catch (_) {}
                                                      setState(() {});
                                                    },
                                                    style: AppTypography
                                                        .pSmall3Dark33H15,
                                                    decoration: InputDecoration(
                                                      label: Text(
                                                        translate(
                                                            "filter.price"),
                                                        style: AppTypography
                                                            .pSmall3Dark33H15,
                                                      ),
                                                      counterText: "",
                                                    ),
                                                  ),
                                                ),
                                                _controllerPrice.text == ""
                                                    ? Container()
                                                    : GestureDetector(
                                                        onTap: () {
                                                          budget = 0;
                                                          _controllerPrice
                                                              .text = "";
                                                          setState(() {});
                                                          Utils.close(context);
                                                          _sendData();
                                                        },
                                                        child: Container(
                                                          color: Colors
                                                              .transparent,
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.close,
                                                              color: AppColors
                                                                  .yellow16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 16,
                                  width: MediaQuery.of(context).size.width,
                                  color: const Color(0xFFFAF8F5),
                                ),
                                FilterSwitchWidget(
                                  title: translate("filter.remote_msg"),
                                  message: translate("filter.remote_title"),
                                  icon: AppAssets.remote,
                                  choose: (bool _value) {
                                    setState(() {
                                      remote = _value;
                                      _sendData();
                                    });
                                  },
                                  value: remote,
                                ),
                                Container(
                                  height: 1,
                                  margin: const EdgeInsets.only(left: 56),
                                  width: MediaQuery.of(context).size.width,
                                  color: const Color(0xFFEFEDE9),
                                ),
                                FilterSwitchWidget(
                                  value: response,
                                  title: translate("filter.no_response_msg"),
                                  message:
                                      translate("filter.no_response_title"),
                                  icon: AppAssets.responsive,
                                  choose: (bool _value) {
                                    setState(() {
                                      response = _value;
                                      _sendData();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          YellowButton(
                            text: text,
                            onTap: () {
                              widget.selected(
                                TaskFilterModel(
                                  response: response,
                                  budget: budget,
                                  remote: remote,
                                  address: address,
                                  category: _category,
                                  longitude: longitude,
                                  work: work,
                                  latitude: latitude,
                                  distance: _distance,
                                ),
                              );
                              Navigator.pop(context);
                            },
                            margin: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 24,
                            ),
                          ),
                        ],
                      ),
                      loading || snapshot.data!.load
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: AppColors.dark00.withOpacity(0.1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 72,
                                    width: 72,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: AppColors.white,
                                    ),
                                    child: const CircularProgressIndicator
                                        .adaptive(
                                      strokeWidth: 65,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _sendData() {
    taskBloc.getFilterCount(
      TaskFilterModel(
        response: response,
        budget: budget,
        remote: remote,
        address: address,
        category: _category,
        longitude: longitude,
        work: work,
        latitude: latitude,
        distance: _distance,
      ),
      context,
    );
  }
}
