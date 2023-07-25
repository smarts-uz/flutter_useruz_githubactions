// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/ui/main/performers/filter/category/per_category_widget.dart';
import 'package:youdu/src/utils/rx_bus.dart';

class PerformersFilterCategoryScreen extends StatefulWidget {
  final List<CategoryModel> category;
  final Function(List<CategoryModel> _category) selected;

  const PerformersFilterCategoryScreen({
    super.key,
    required this.category,
    required this.selected,
  });

  @override
  State<PerformersFilterCategoryScreen> createState() =>
      _PerformersFilterCategoryScreenState();
}

class _PerformersFilterCategoryScreenState
    extends State<PerformersFilterCategoryScreen> {
  List<CategoryModel> category = [];

  @override
  void initState() {
    initBus();
    category = widget.category;
    super.initState();
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
                elevation: 0,
                centerTitle: true,
                backgroundColor: AppColors.white,
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
                //       onTap: () {},
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
                title: Text(
                  translate("filter.category"),
                  style: AppTypography.pSmall1,
                ),
              ),
              body: PerformersCategoryWidget(
                key: Key(category.toString()),
                category: category,
                onTap: () {},
                view: false,
                selected: (List<CategoryModel> _category) {
                  widget.selected(_category);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    RxBus.destroy(tag: "CHANGE_PERFORMERS_CATEGORY_TYPE");
    super.dispose();
  }

  click() {
    for (int i = 0; i < category.length; i++) {
      category[i].selectedItem = false;
      category[i].chooseItem = [];
    }
    setState(() {});
  }

  initBus() {
    RxBus.register<bool>(tag: "CHANGE_PERFORMERS_CATEGORY_TYPE")
        .listen((event) {
      click();
    });
  }
}
