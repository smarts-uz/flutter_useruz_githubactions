// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/performers/add_performers/final_view_screen.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/search/filter/category_widget.dart';

class PageFour extends StatefulWidget {
  final List<CategoryModel> data;

  const PageFour({super.key, required this.data});

  @override
  State<PageFour> createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  List<CategoryModel> _category = [];
  Repository repository = Repository();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _category = widget.data;

    for (int i = 0; i < _category.length; i++) {
      _category[i].selectedItem = false;
      _category[i].chooseItem = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Builder(
        builder: (context) {
          return CupertinoPageScaffold(
            backgroundColor: AppColors.background,
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      translate("performers.four.title1"),
                      style: AppTypography.pSmallRegularDark33SemiBold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      translate("performers.four.title2"),
                      style: AppTypography.pTiny215ProDark33,
                    ),
                  ),
                  Expanded(
                    child: CategoryWidget(
                      category: _category,
                      view: true,
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        loading = true;
                        setState(() {});
                        String category = "[";
                        for (int i = 0; i < _category.length; i++) {
                          for (int j = 0;
                              j < _category[i].chooseItem.length;
                              j++) {
                            category +=
                                _category[i].chooseItem[j].id.toString() + ",";
                          }
                        }
                        if (_category.isNotEmpty) {
                          category = category.substring(0, category.length - 1);
                          category += "]";
                        }
                        HttpResult response =
                            await repository.postCategoryId(category);
                        loading = false;
                        setState(() {});
                        if (response.isSuccess && response.result["success"]) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setInt("roleId", 2);
                          RxBus.post("", tag: "CHANGE_IMAGE_NAME");
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const FinalViewScreen();
                              },
                            ),
                          );
                        } else {
                          if (response.status == -1) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            CenterDialog.networkErrorDialog(context);
                          } else {
                            CenterDialog.errorDialog(
                              context,
                              Utils.serverErrorText(response),
                              response.result.toString(),
                            );
                          }
                        }
                      },
                      selected: (List<CategoryModel> _categorySelected,
                          {List<int> all = const <int>[]}) {
                        setState(() {
                          _category = _categorySelected;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
