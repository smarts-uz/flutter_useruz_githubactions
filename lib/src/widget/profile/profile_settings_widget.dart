// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:youdu/src/constants/app_assets.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/ui/main/more/screens/profile/about/about_screen.dart';
import 'package:youdu/src/ui/main/more/screens/profile/about/add_link_screen.dart';
import 'package:youdu/src/ui/main/more/screens/profile/balance/balance_screen.dart';
import 'package:youdu/src/ui/main/more/screens/profile/portfolio/portfolio_view_screen.dart';
import 'package:youdu/src/ui/main/more/screens/profile/response_templates/templates_screen.dart';
import 'package:youdu/src/ui/main/search/filter/item/category/filter_category_screen.dart';
import 'package:youdu/src/widget/more/settings/settings.dart';

class ProfileSettingsWidget extends StatelessWidget {
  final String money;
  final String link;
  final String about;
  final String workExp;
  final bool perform;
  final List<CategoryModel> category;
  final Function() onScale;
  final Function(List<CategoryModel> data, {List<int> all}) onTap;
  final int exampleCount;

  const ProfileSettingsWidget({
    super.key,
    required this.exampleCount,
    required this.money,
    required this.link,
    required this.about,
    required this.category,
    required this.onTap,
    required this.onScale,
    required this.perform,
    required this.workExp,
  });

  @override
  Widget build(BuildContext context) {
    return !perform
        ? SettingsWidget(
            icon: AppAssets.docEdit,
            title: translate("profile.about_me"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutScreen(
                    about: about,
                    workExp: workExp,
                  ),
                ),
              );
            },
          )
        : Column(
            children: [
              SettingsWidget(
                icon: AppAssets.wallet,
                title:
                    "${translate("pr")} ${priceFormat.format(num.parse(money))} ${translate("sum")}",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BalanceScreen(),
                    ),
                  );
                },
              ),
              SettingsWidget(
                icon: AppAssets.grid,
                title: translate("profile.subscription"),
                onTap: () {
                  CupertinoScaffold.showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return FilterCategoryScreen(
                        category: category,
                        isSubcription: true,
                        selected: (List<CategoryModel> _categorySelected,
                            {List<int> all = const <int>[]}) {
                          onTap(
                            _categorySelected,
                            all: all,
                          );
                        },
                      );
                    },
                  );
                },
              ),
              SettingsWidget(
                icon: AppAssets.docEdit,
                title: translate("profile.about_me"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutScreen(
                        about: about,
                        workExp: workExp,
                      ),
                    ),
                  );
                },
              ),
              SettingsWidget(
                icon: AppAssets.photo,
                title: translate("profile.about_me_video"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddLinkScreen(
                        link: link,
                        onScale: () {
                          onScale();
                        },
                      ),
                    ),
                  );
                },
              ),
              SettingsWidget(
                icon: AppAssets.templates,
                title: translate("profile.response_template"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TemplatesScreen(),
                    ),
                  );
                },
              ),
              SettingsWidget(
                icon: AppAssets.camera,
                title: translate("profile.work_example"),
                subtitle: exampleCount,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PortfolioViewScreen(id: -1),
                    ),
                  );
                },
              ),
            ],
          );
  }
}
