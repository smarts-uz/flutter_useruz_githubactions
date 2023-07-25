// ignore_for_file: sort_child_properties_last, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/guest/category/category_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/shimmer/category_shimmer.dart';

class PerformersFilterSubCategoryScreen extends StatefulWidget {
  final String title;
  final int id;
  final bool allCategory;
  final List<CategoryModel> chooseItem;
  final Function(List<CategoryModel> _chooseItem) selected;

  const PerformersFilterSubCategoryScreen({
    super.key,
    required this.title,
    required this.chooseItem,
    required this.selected,
    required this.id,
    required this.allCategory,
  });

  @override
  State<PerformersFilterSubCategoryScreen> createState() =>
      _PerformersFilterSubCategoryScreenState();
}

class _PerformersFilterSubCategoryScreenState
    extends State<PerformersFilterSubCategoryScreen> {
  bool allCategory = false;
  bool isFirst = false;
  List<CategoryModel> data = [];
  List<CategoryModel> chooseItem = [];

  @override
  void initState() {
    allCategory = widget.allCategory;
    chooseItem = widget.chooseItem;
    categoryBloc.allSubCategory(widget.id, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: SvgPicture.asset(
              AppAssets.back,
              height: 24,
              width: 24,
              color: AppColors.yellow16,
            ),
          ),
        ),
        // actions: [
        //   Align(
        //     alignment: Alignment.center,
        //     child: GestureDetector(
        //       onTap: () {
        //
        //       },
        //       child: Text(
        //         translate("filter.clear"),
        //         style: const TextStyle(
        //           fontFamily: AppTypography.fontFamilyProduct,
        //           fontWeight: FontWeight.w400,
        //           fontSize: 15,
        //           height: 1.6,
        //           color: AppColors.yellow16,
        //         ),
        //       ),
        //     ),
        //   ),
        //   const SizedBox(width: 16),
        // ],
        title: Text(widget.title, style: AppTypography.pSmall1),
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColors.greyE9,
          ),
          GestureDetector(
            onTap: () {
              if (allCategory) {
                for (int i = 0; i < chooseItem.length; i++) {
                  chooseItem[i].selectedItem = false;
                }
                chooseItem = data;
                allCategory = false;
              } else {
                chooseItem = data;
                allCategory = true;
                for (int i = 0; i < chooseItem.length; i++) {
                  chooseItem[i].selectedItem = true;
                }
              }
              setState(() {});
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      translate("filter.sub_category"),
                      style: AppTypography.pSmall3.copyWith(
                        color:
                            allCategory ? AppColors.blueE6 : AppColors.dark33,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    allCategory ? AppAssets.check : AppAssets.checkUnselected,
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
            child: StreamBuilder<List<CategoryModel>>(
              stream: categoryBloc.getSubCategory,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  data = snapshot.data!;
                  if (!isFirst) {
                    if (widget.allCategory) {
                      chooseItem = data;
                    } else {
                      chooseItem = data;
                      for (int i = 0; i < chooseItem.length; i++) {
                        bool selected = false;
                        for (int j = 0; j < widget.chooseItem.length; j++) {
                          if (widget.chooseItem[j].id == chooseItem[i].id) {
                            selected = true;
                          }
                        }
                        chooseItem[i].selectedItem = selected;
                      }
                    }

                    isFirst = true;
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 21),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data[index].name,
                                      style: AppTypography.pSmall3.copyWith(
                                        color: Utils.selectedSubCategory(
                                                  data[index],
                                                  chooseItem,
                                                ) ||
                                                allCategory
                                            ? AppColors.blueE6
                                            : AppColors.dark33,
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    Utils.selectedSubCategory(
                                              data[index],
                                              chooseItem,
                                            ) ||
                                            allCategory
                                        ? AppAssets.check
                                        : AppAssets.checkUnselected,
                                    height: 24,
                                    width: 24,
                                  )
                                ],
                              ),
                              color: Colors.transparent,
                            ),
                            onTap: () {
                              if (allCategory) {
                                chooseItem = data;
                              }
                              chooseItem[index].selectedItem =
                                  !chooseItem[index].selectedItem;
                              int k = 0;
                              for (int i = 0; i < chooseItem.length; i++) {
                                if (chooseItem[i].selectedItem) {
                                  k++;
                                }
                              }
                              if (k == chooseItem.length) {
                                allCategory = true;
                              } else {
                                allCategory = false;
                              }
                              setState(() {});
                            },
                          ),
                          index == data.length - 1
                              ? Container()
                              : Container(
                                  height: 1,
                                  width: MediaQuery.of(context).size.width,
                                  color: const Color(0xFFEFEDE9),
                                ),
                        ],
                      );
                    },
                    itemCount: data.length,
                  );
                }
                return const CategoryShimmer(
                  subCategory: true,
                );
              },
            ),
          ),
          YellowButton(
            text: translate("filter.save"),
            onTap: () {
              if (allCategory) {
                widget.selected(data);
              } else {
                List<CategoryModel> info = [];
                for (int i = 0; i < chooseItem.length; i++) {
                  if (chooseItem[i].selectedItem) {
                    info.add(chooseItem[i]);
                  }
                }
                widget.selected(info);
              }
              Navigator.pop(context);
            },
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          ),
        ],
      ),
    );
  }
}
