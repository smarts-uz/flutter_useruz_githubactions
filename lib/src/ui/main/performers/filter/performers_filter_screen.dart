// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/ui/main/performers/filter/filter_provider/performers_provider.dart';
import 'package:youdu/src/ui/main/search/filter/item/category/filter_category_screen.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/performers/performers_filter_item.dart';

import '../../../../api/repository.dart';
import '../../../../bloc/guest/performers/performers_bloc.dart';
import '../../../../model/http_result.dart';
import '../../../../widget/search/filter/filter_item_widget.dart';

class PerformersFilterScreen extends StatefulWidget {
  final Function onTap;
  const PerformersFilterScreen({super.key, required this.onTap});

  @override
  State<PerformersFilterScreen> createState() => _PerformersFilterScreenState();
}

class _PerformersFilterScreenState extends State<PerformersFilterScreen> {
  List<CategoryModel> _category = [];

  bool loading = false;
  Future<void> _getCategory() async {
    HttpResult response = await Repository().allCategory();
    if (response.isSuccess) {
      List<CategoryModel> data =
          AllCategoryModel.fromJson(response.result).data;
      _category = data;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool allSelected = true;
    int count = 0;
    var provider = Provider.of<PerformersFilterProvider>(context);
    if (provider.categories.isNotEmpty) {
      for (int i = 0; i < _category.length; i++) {
        if (!provider.categories[i].selectedItem) {
          allSelected = false;
          if (provider.categories[i].chooseItem.isNotEmpty) {
            count += provider.categories[i].chooseItem.length;
          }
        } else if (provider.categories[i].selectedItem &&
            provider.categories[i].childCount != 0) {
          count += provider.categories[i].childCount;
        }
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
                    provider.setLast();
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
                        provider.resetFilter();
                        provider.updateCategory([]);
                        provider.updateCategoriesId([]);
                        for (int i = 0; i < _category.length; i++) {
                          _category[i].selectedItem = false;
                          _category[i].chooseItem = [];
                        }
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
              body: Stack(
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
                                CupertinoScaffold.showCupertinoModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return FilterCategoryScreen(
                                      category: provider.categories.isEmpty
                                          ? _category
                                          : provider.categories,
                                      isPerformers: true,
                                      selected: (List<CategoryModel>
                                              _categorySelected,
                                          {List<int> all = const <int>[]}) {
                                        setState(() {
                                          _category = _categorySelected;
                                        });
                                      },
                                    );
                                  },
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
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.dark00.withOpacity(0.04),
                                    offset: const Offset(0, 2),
                                    blurRadius: 12,
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  SvgPicture.asset(
                                    AppAssets.online,
                                    color: AppColors.blueE6,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      translate("performers.online"),
                                      style: AppTypography.pSmallRegularDark33,
                                    ),
                                  ),
                                  Switch.adaptive(
                                    value: provider.filter.online,
                                    activeColor: AppColors.yellow16,
                                    onChanged: (value) {
                                      provider.updateOnline(value);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 16,
                              width: MediaQuery.of(context).size.width,
                              color: const Color(0xFFFAF8F5),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 16),
                              child: Text(
                                translate("performers_filter.sort"),
                                style: AppTypography.h3Dark00,
                              ),
                            ),
                            PerformersFilterItem(
                              label: translate("performers_filter.alphabet"),
                              onTap: () => provider.updateAlphabet(true),
                              image: AppAssets.alphabet,
                              isActive: provider.filter.alphabet,
                            ),
                            Container(
                              height: 1,
                              margin: const EdgeInsets.only(left: 56),
                              width: MediaQuery.of(context).size.width,
                              color: const Color(0xFFEFEDE9),
                            ),
                            PerformersFilterItem(
                              label: translate("performers_filter.review"),
                              onTap: () => provider.updateReview(true),
                              image: AppAssets.filterReview,
                              isActive: provider.filter.review,
                            ),
                            Container(
                              height: 16,
                              width: MediaQuery.of(context).size.width,
                              color: const Color(0xFFFAF8F5),
                            ),
                            PerformersFilterItem(
                              label: translate("performers_filter.desc"),
                              onTap: () => provider.updateDesc(true),
                              image: AppAssets.desc,
                              isActive: provider.filter.desc,
                            ),
                            Container(
                              height: 1,
                              margin: const EdgeInsets.only(left: 56),
                              width: MediaQuery.of(context).size.width,
                              color: const Color(0xFFEFEDE9),
                            ),
                            PerformersFilterItem(
                              label: translate("performers_filter.asc"),
                              onTap: () => provider.updateAsc(true),
                              image: AppAssets.asc,
                              isActive: provider.filter.asc,
                            ),
                          ],
                        ),
                      ),
                      YellowButton(
                        text: translate("filter.result"),
                        onTap: () async {
                          provider.setResult();

                          RxBus.post(
                            provider.resultFilter,
                            tag: 'SEARCH_PERFORMERS_FILTER',
                          );

                          Navigator.pop(context);
                          provider.updateLoading(true);
                          await filterPerformersBloc
                              .allPerformers(
                                provider.searchText,
                                provider.resultFilter,
                                provider.resultFilter.online,
                                1,
                                context,
                              )
                              .then((_) => provider.updateLoading(false));
                          widget.onTap();
                        },
                        margin: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // void _sendData() {
  //   taskBloc.getFilterCount(
  //     TaskFilterModel(
  //       response: response,
  //       budget: budget,
  //       remote: remote,
  //       address: address,
  //       category: _category,
  //       longitude: longitude,
  //       work: work,
  //       latitude: latitude,
  //       distance: _distance,
  //     ),
  //     context,
  //   );
  // }

  getCat() {
    var provider =
        Provider.of<PerformersFilterProvider>(context, listen: false);
    provider.updateCategory(_category);
    List<List<int>> list =
        _category.map((e) => e.chooseItem.map((c) => c.id).toList()).toList();
    list.removeWhere((List element) => element.isEmpty);
    provider.updateCategoriesId(list);
  }
}
