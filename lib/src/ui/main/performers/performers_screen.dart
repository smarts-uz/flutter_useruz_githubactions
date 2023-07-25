// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/bloc/guest/performers/performers_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/guest/performers/all_performers_model.dart';
import 'package:youdu/src/ui/main/my_task/item/my_task_item_screen.dart';
import 'package:youdu/src/ui/main/performers/blocked_users/blocked_users_screen.dart';
import 'package:youdu/src/ui/main/performers/filter/filter_provider/performers_provider.dart';
import 'package:youdu/src/ui/main/performers/search/performers_search_widget.dart';
import 'package:youdu/src/widget/app/loading_widget.dart';
import 'package:youdu/src/widget/shimmer/all_performers_shimmer.dart';

import '../../../widget/performers/performers_widget.dart';
import '../../auth/entrance_screen/entrance_screen.dart';
import 'filter/performers_filter_screen.dart';

class PerformersScreen extends StatefulWidget {
  const PerformersScreen({super.key});

  @override
  State<PerformersScreen> createState() => _PerformersScreenState();
}

class _PerformersScreenState extends State<PerformersScreen>
    with AutomaticKeepAliveClientMixin<PerformersScreen> {
  @override
  bool get wantKeepAlive => true;
  // final ItemScrollController _scrollController = ItemScrollController();
  // final ItemPositionsListener itemPositionsListener =
  //     ItemPositionsListener.create();
  ScrollController controller = ScrollController();
  final TextEditingController _controller = TextEditingController();
  bool value = false;
  bool isLoading = false;
  bool isLast = false;
  int page = 1;
  int isMine = 0, scrollIndex = 5;

  @override
  void initState() {
    _getMoreData(value, page, "");
    getData();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        _getMoreData(value, page, _controller.text.trim());
      }
    });

    _controller.addListener(() {
      page = 1;
      _getMoreData(value, page, _controller.text.trim());
    });
    super.initState();
  }

  void _getMoreData(bool value, int index, String search) async {
    var provider =
        Provider.of<PerformersFilterProvider>(context, listen: false);

    if (!provider.loading) {
      if (!isLoading) {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
        await filterPerformersBloc
            .allPerformers(search, provider.resultFilter, value, page, context)
            .then(
          (_) {
            page++;
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          },
        );
      }
    }
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isMine = prefs.getInt("id") ?? 0;
    setState(() {});
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    var provider = Provider.of<PerformersFilterProvider>(context);
    return CupertinoScaffold(
      body: Builder(
        builder: (context) {
          return CupertinoPageScaffold(
            backgroundColor: Colors.white,
            child: Scaffold(
              backgroundColor: AppColors.white,
              body: NestedScrollView(
                controller: controller,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 65,
                      floating: false,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: AppColors.white,
                      actions: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const BlockedUsersScreen(),
                              ),
                            ),
                            child: SvgPicture.asset(AppAssets.blockedUsers),
                          ),
                        )
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: false,
                        titlePadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 5,
                          right: 16,
                        ),
                        title: Text(
                          translate("performers.title"),
                          style: AppTypography.h1,
                        ),
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: [
                    PerformersSearchWidget(
                      margin: const EdgeInsets.all(16),
                      text: translate("search.search"),
                      controller: _controller,
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: restart,
                        color: AppColors.yellow00,
                        backgroundColor: AppColors.white,
                        child: StreamBuilder(
                          stream: filterPerformersBloc.getAllPerformers,
                          builder: (context,
                              AsyncSnapshot<AllPerformersModel> snapshot) {
                            if (provider.loading) {
                              return const AllPerformersShimmer();
                            } else {
                              if (snapshot.hasData) {
                                snapshot.data!.meta.lastPage < page
                                    ? isLoading = true
                                    : isLoading = false;

                                List<PerformersModel> performModel =
                                    snapshot.data!.data;
                                return performModel.isEmpty
                                    ? Center(
                                        child: Text(
                                            translate("performers.empty_data")),
                                      )
                                    : ListView.builder(
                                        // itemScrollController: _scrollController,
                                        // itemPositionsListener:
                                        //     itemPositionsListener,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemCount: performModel.length + 1,
                                        itemBuilder: (_, index) {
                                          if (index == performModel.length) {
                                            return LoadingWidget(
                                              key: Key(isLoading.toString()),
                                              isLoading: isLoading,
                                            );
                                          }
                                          return PerformersWidget(
                                            data: performModel[index],
                                            id: isMine,
                                            onTap: () async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              if (prefs.getString(
                                                      "accessToken") ==
                                                  null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return const EntranceScreen();
                                                    },
                                                  ),
                                                );
                                              } else {
                                                CupertinoScaffold
                                                    .showCupertinoModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return MyTaskItemScreen(
                                                      title: translate(
                                                          "performers.my_task"),
                                                      status: 1,
                                                      performer: 0,
                                                      performId:
                                                          performModel[index]
                                                              .id,
                                                      perform: true,
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          );
                                        },
                                      );
                              }
                              return const AllPerformersShimmer();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.blue32,
                child: Center(
                  child: SvgPicture.asset(AppAssets.filter),
                ),
                onPressed: () {
                  CupertinoScaffold.showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return PerformersFilterScreen(
                        onTap: () {
                          page = 1;
                        },
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> restart() async {
    var provider =
        Provider.of<PerformersFilterProvider>(context, listen: false);
    page = 1;

    scrollIndex = 5;
    isLoading = false;
    await filterPerformersBloc.allPerformers(
        _controller.text, provider.resultFilter, value, page, context);
    page++;

    return true;
  }
}
