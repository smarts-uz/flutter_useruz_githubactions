// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:youdu/src/bloc/guest/category/category_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/ui/main/performers/filter/category/performers_filter_sub_category_screen.dart';
import 'package:youdu/src/ui/main/performers/filter/filter_provider/performers_provider.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/home/category_item_widget.dart';
import 'package:youdu/src/widget/shimmer/category_shimmer.dart';

class PerformersCategoryWidget extends StatefulWidget {
  final List<CategoryModel> category;
  final Function(List<CategoryModel> _category) selected;
  final bool view;
  final Function() onTap;
  final bool isPerformers;

  const PerformersCategoryWidget({
    super.key,
    required this.category,
    required this.selected,
    required this.view,
    required this.onTap,
    this.isPerformers = false,
  });

  @override
  State<PerformersCategoryWidget> createState() =>
      _PerformersCategoryWidgetState();
}

class _PerformersCategoryWidgetState extends State<PerformersCategoryWidget> {
  List<CategoryModel> selectedData = [];

  @override
  void initState() {
    selectedData = widget.category;
    categoryBloc.allCategory(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool allSelected = true;
    for (int i = 0; i < selectedData.length; i++) {
      if (!selectedData[i].selectedItem) {
        allSelected = false;
        break;
      }
    }
    return StreamBuilder<List<CategoryModel>>(
      stream: categoryBloc.getAllCategory,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CategoryModel> data = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.greyE9,
                    ),
                    widget.view
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              for (int i = 0; i < selectedData.length; i++) {
                                if (!selectedData[i].selectedItem) {
                                  allSelected = false;
                                  break;
                                }
                              }
                              for (int i = 0; i < data.length; i++) {
                                try {
                                  selectedData[i].selectedItem = true;
                                } catch (_) {}
                              }
                              if (allSelected) {
                                RxBus.post(false,
                                    tag: "CHANGE_PERFORMERS_CATEGORY_TYPE");
                              }
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 21,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        translate("filter.all_category"),
                                        style: AppTypography.pSmall3Dark3306
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                          color: allSelected
                                              ? AppColors.blueE6
                                              : AppColors.dark33,
                                        )),
                                  ),
                                  SvgPicture.asset(
                                    allSelected
                                        ? AppAssets.check
                                        : AppAssets.checkUnselected,
                                    height: 24,
                                    width: 24,
                                  )
                                ],
                              ),
                            ),
                          ),
                    Container(
                      height: 16,
                      color: const Color(0xFFFAF8F5),
                      width: MediaQuery.of(context).size.width,
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              CategoryItemWidget(
                                iconSize: 40,
                                image: data[index].ico,
                                title: data[index].name,
                                message: Utils.selectedCategory(
                                  data[index],
                                  selectedData,
                                )
                                    ? "${data[index].childCount.toString()} " +
                                        translate("filter.us")
                                    : selectedData[index].chooseItem.isNotEmpty
                                        ? "${selectedData[index].chooseItem.length} " +
                                            translate("filter.us")
                                        : "",
                                onTap: () {
                                  CupertinoScaffold
                                      .showCupertinoModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return PerformersFilterSubCategoryScreen(
                                        id: data[index].id,
                                        title: data[index].name,
                                        allCategory: Utils.selectedCategory(
                                              data[index],
                                              selectedData,
                                            ) ||
                                            selectedData[index]
                                                    .chooseItem
                                                    .length ==
                                                data[index].childCount,
                                        chooseItem:
                                            selectedData[index].chooseItem,
                                        selected:
                                            (List<CategoryModel> _chooseItem) {
                                          selectedData[index].selectedItem =
                                              false;
                                          selectedData[index].chooseItem =
                                              _chooseItem;
                                          setState(() {});
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              index == data.length - 1
                                  ? Container()
                                  : Container(
                                      height: 1,
                                      margin: const EdgeInsets.only(left: 56),
                                      width: MediaQuery.of(context).size.width,
                                      color: const Color(0xFFEFEDE9),
                                    ),
                            ],
                          );
                        },
                        itemCount: data.length,
                      ),
                    ),
                  ],
                ),
              ),
              YellowButton(
                text: widget.view
                    ? translate("perform_cat")
                    : translate("filter.result"),
                onTap: () {
                  if (widget.view) {
                    widget.selected(selectedData);
                    if (widget.isPerformers) {
                      getCat();
                    }
                    widget.onTap();
                  } else {
                    widget.selected(selectedData);
                    if (widget.isPerformers) {
                      getCat();
                    }
                    Navigator.pop(context);
                  }
                },
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
              ),
            ],
          );
        }
        return const CategoryShimmer();
      },
    );
  }

  getCat() {
    var provider =
        Provider.of<PerformersFilterProvider>(context, listen: false);
    provider.updateCategory(selectedData);
    List<List<int>> list = selectedData
        .map((e) => e.chooseItem.map((c) => c.id).toList())
        .toList();
    list.removeWhere((List element) => element.isEmpty);
    provider.updateCategoriesId(list);
  }
}
