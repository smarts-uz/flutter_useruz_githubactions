import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/profile/my_task_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/my_task/as_customer_screen.dart';
import 'package:youdu/src/ui/main/my_task/as_performer_screen.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/sliver_app_bar_delegate.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({super.key});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen>
    with TickerProviderStateMixin {
  TabController? controller;
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    controller = TabController(
        length: LanguagePerformers.getRoleId() == 2 ? 2 : 1, vsync: this);
    controller!.index == 0
        ? myTaskBloc.getAllCount(0, context)
        : myTaskAsPerformerBloc.getAllCount(context);

    controller!.addListener(() {
      controller!.index == 0
          ? myTaskBloc.getAllCount(0, context)
          : myTaskAsPerformerBloc.getAllCount(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: DefaultTabController(
        length: LanguagePerformers.getRoleId() == 2 ? 2 : 1,
        child: RefreshIndicator(
          onRefresh: restart,
          color: AppColors.yellow00,
          backgroundColor: AppColors.white,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: AppColors.background,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(
                      left: 16,
                      bottom: 16,
                      right: 16,
                    ),
                    title: Text(
                      translate("my_task.title"),
                      style: AppTypography.h1,
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: SliverAppBarDelegate(
                    TabBar(
                      controller: controller,
                      labelColor: AppColors.yellow00,
                      unselectedLabelColor: AppColors.greyBF,
                      indicatorColor: AppColors.yellow00,
                      // physics: LanguagePerformers.getRoleId() == 2
                      //     ? null
                      //     : const NeverScrollableScrollPhysics(),
                      labelStyle: AppTypography.pTinyPro,
                      onTap: (e) {
                        e == 0
                            ? myTaskBloc.getAllCount(0, context)
                            : myTaskAsPerformerBloc.getAllCount(context);
                      },

                      unselectedLabelStyle: AppTypography.pTinyPro,
                      tabs: [
                        Tab(
                          text: translate("my_task.my"),
                        ),
                        if (LanguagePerformers.getRoleId() == 2)
                          Tab(
                            text: translate("my_task.you"),
                          ),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              controller: controller,
              children: [
                const AsCustomerScreen(
                  performer: 0,
                ),
                if (LanguagePerformers.getRoleId() == 2)
                  const AsPerformerScreen(
                    performer: 1,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> restart() async {
    await myTaskBloc.getAllCount(controller!.index, context);

    return true;
  }
}
