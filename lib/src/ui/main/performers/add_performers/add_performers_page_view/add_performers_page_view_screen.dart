import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/performers/add_performers/add_performers_page_view/pages/page_four.dart';
import 'package:youdu/src/ui/main/performers/add_performers/add_performers_page_view/pages/page_one.dart';
import 'package:youdu/src/ui/main/performers/add_performers/add_performers_page_view/pages/page_three.dart';
import 'package:youdu/src/ui/main/performers/add_performers/add_performers_page_view/pages/page_two.dart';

class AddPerformersPageViewScreen extends StatefulWidget {
  const AddPerformersPageViewScreen({super.key});

  @override
  State<AddPerformersPageViewScreen> createState() =>
      _AddPerformersPageViewScreenState();
}

class _AddPerformersPageViewScreenState
    extends State<AddPerformersPageViewScreen> {
  final PageController _controller = PageController();
  int selected = 0;
  String name = "";
  List<CategoryModel> _category = [];

  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: GestureDetector(
          onTap: () {
            if (selected > 0) {
              selected--;
              setState(() {});
              _controller.jumpToPage(selected);
            } else {
              Navigator.pop(context);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(AppAssets.back),
          ),
        ),
        title: Text(
          translate("performers.perform_reg"),
          style: AppTypography.pSmallRegularDark00.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 5,
            margin: const EdgeInsets.only(top: 20, bottom: 16),
            child: Row(
              children: [
                const Spacer(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (_, index) {
                    return Container(
                      height: 5,
                      width: 64,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: selected >= index
                            ? AppColors.yellow00
                            : AppColors.greyEA,
                      ),
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: AppColors.greyE9,
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              allowImplicitScrolling: true,
              children: [
                PageOne(
                  onTap: () {
                    selected++;
                    setState(() {});
                    _controller.jumpToPage(
                      _controller.page!.toInt() + 1,
                    );
                  },
                ),
                PageTwo(
                  onTap: () {
                    selected++;
                    setState(() {});
                    _controller.jumpToPage(
                      _controller.page!.toInt() + 1,
                    );
                  },
                ),
                PageThree(
                  onTap: () {
                    selected++;
                    setState(() {});
                    _controller.jumpToPage(
                      _controller.page!.toInt() + 1,
                    );
                  },
                ),
                PageFour(
                  data: _category,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCategory() async {
    HttpResult response = await Repository().allCategory();
    if (response.isSuccess) {
      List<CategoryModel> data =
          AllCategoryModel.fromJson(response.result).data;
      _category = data;
      setState(() {});
    }
  }
}
