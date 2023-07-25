import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/create_task/search/pod_searchs/history_category_screen.dart';
import 'package:youdu/src/ui/main/create_task/search/pod_searchs/tab_screens.dart';

class CreateSearchScreen extends StatefulWidget {
  const CreateSearchScreen({super.key});

  @override
  State<CreateSearchScreen> createState() => _CreateSearchScreenState();
}

class _CreateSearchScreenState extends State<CreateSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final Duration _duration = const Duration(milliseconds: 600);
  bool animation = false, text = false;

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
      createBloc.allPopularCategory(_controller.text);
      createBloc.allData(_controller.text);
    });
    Timer(const Duration(milliseconds: 10), () {
      setState(() {
        animation = true;
      });
    });
    Timer(_duration, () {
      setState(() {
        text = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        back();
        return false;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: Size.zero,
            child: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
            ),
          ),
          body: Column(
            children: [
              AnimatedContainer(
                duration: _duration,
                height: animation ? 24 : 380,
                curve: Curves.easeInOut,
              ),
              Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: _duration,
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(
                        left: animation ? 16 : 24,
                      ),
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: animation ? AppColors.greyF4 : AppColors.white,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.search,
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _controller,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                suffix: _controller.text == ""
                                    ? null
                                    : GestureDetector(
                                        onTap: () {
                                          _controller.text = "";
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 16,
                                          width: 16,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: AppColors.dark00
                                                .withOpacity(0.5),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.close,
                                              color: AppColors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                hintText: text
                                    ? translate("create_task.help")
                                    : translate("search.search"),
                                hintStyle: AppTypography.pSmallGrey85,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      back();
                    },
                    child: AnimatedContainer(
                      duration: _duration,
                      width: animation ? 78 : 24,
                      curve: Curves.easeInOut,
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          text ? translate("create_task.break") : "",
                          style: AppTypography.pTinyYellow,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TabBar(
                labelColor: AppColors.yellow16,
                unselectedLabelColor: AppColors.greyBF,
                indicatorColor: AppColors.yellow16,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                tabs: [
                  Tab(
                    text: translate("create_task.popular"),
                  ),
                  Tab(
                    text: translate("create_task.history"),
                  ),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    TabScreens(),
                    HistoryCategoryScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void back() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      text = false;
      animation = false;
    });
    Timer(_duration, () {
      Navigator.pop(context);
    });
  }
}
