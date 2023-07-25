import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/create_task/search/create_search_screen.dart';
import 'package:youdu/src/ui/main/create_task/search/pod_searchs/category_screen.dart';
import 'package:youdu/src/widget/app/search_text_widget.dart';

class NewSearchScreen extends StatefulWidget {
  const NewSearchScreen({super.key});

  @override
  State<NewSearchScreen> createState() => _NewSearchScreenState();
}

class _NewSearchScreenState extends State<NewSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 380,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16, bottom: 48, top: 48),
                  child: Text(
                    translate("create_task.create"),
                    style: AppTypography.h1,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 72),
                    child: Center(
                      child: Image.asset(
                        AppAssets.createTaskMain,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 26,
                    bottom: 8,
                    top: 24,
                  ),
                  child: Text(
                    translate("create_task.help"),
                    style: AppTypography.pSmallRegularDark33,
                  ),
                ),
              ],
            ),
          ),
          SearchTextWidget(
            text: translate("search.search"),
            color: AppColors.white,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const CreateSearchScreen(),
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(left: 40, top: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryScreen(),
                  ),
                );
              },
              child: Text(
                translate("create_task.sort"),
                style: AppTypography.pTiny215Yellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
