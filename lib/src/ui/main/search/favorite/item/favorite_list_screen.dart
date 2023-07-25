// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/favorites/favorite_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/favorite_tasks_model.dart'
    as favoritresult;
import 'package:youdu/src/model/api_model/tasks/task_filter_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/my_task/product/product_item_screen.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/loading_widget.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/search/favorite_task_list_widget.dart';
import 'package:youdu/src/widget/shimmer/search_shimmer.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({super.key});

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen>
    with AutomaticKeepAliveClientMixin<FavoriteListScreen> {
  @override
  bool get wantKeepAlive => true;
  Repository repository = Repository();
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  bool isLoading = false;
  int scrollIndex = 5;
  int page = 1;

  bool tap = false;

  @override
  void initState() {
    _initBus();
    _getMoreData(page);
    itemPositionsListener.itemPositions.addListener(() {
      if (itemPositionsListener.itemPositions.value.last.index == scrollIndex) {
        scrollIndex += 10;
        _getMoreData(page);
      }
    });

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _getMoreData(page, filterData);
    //   }
    // });
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: restart,
      color: AppColors.yellow00,
      backgroundColor: AppColors.white,
      child: StreamBuilder<favoritresult.FavoriteTasksModel>(
        stream: favoriteTasksBloc.getAllFavoriteTasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<favoritresult.TaskModelResult> data = snapshot.data!.data;
            snapshot.data!.lastPage == page - 1
                ? isLoading = true
                : isLoading = false;
            return data.isEmpty
                ? Center(
                    child: Text(
                      translate("no_favorites"),
                    ),
                  )
                : ScrollablePositionedList.builder(
                    itemScrollController: _scrollController,
                    itemPositionsListener: itemPositionsListener,
                    itemBuilder: (_, index) {
                      if (index == data.length) {
                        return LoadingWidget(
                          key: Key(isLoading.toString()),
                          isLoading: isLoading,
                        );
                      }
                      return FavoriteTaskListWidget(
                        data: data[index],
                        onTap: () async {
                          if (tap) {
                            return;
                          }
                          if (data[index].viewed) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductItemScreen(
                                  id: data[index].id,
                                ),
                              ),
                            );
                          } else {
                            tap = true;
                            setState(() {});
                            HttpResult response =
                                await repository.setView(data[index].id);
                            tap = false;
                            setState(() {});
                            if (response.isSuccess) {
                              data[index].viewed = true;
                              setState(() {});
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductItemScreen(
                                    id: data[index].id,
                                  ),
                                ),
                              );
                            } else {
                              if (response.status == -1) {
                                CenterDialog.networkErrorDialog(context);
                              } else {
                                CenterDialog.errorDialog(
                                  context,
                                  Utils.serverErrorText(response),
                                  response.result.toString(),
                                );
                              }
                            }
                          }
                        },
                      );
                    },
                    itemCount: data.length + 1,
                  );
          }
          return const SearchShimmer();
        },
      ),
    );
  }

  void _getMoreData(int index) async {
    if (!isLoading) {
      favoriteTasksBloc.allFavoriteTasks(index, context);
      page++;
    }
  }

  Future<bool> restart() async {
    isLoading = false;
    page = 1;
    scrollIndex = 5;
    await favoriteTasksBloc.allFavoriteTasks(page, context);
    page++;
    return true;
  }

  void _initBus() {
    RxBus.register<String>(tag: "SEARCH_TASK_EVENT").listen((event) {
      page = 1;
      scrollIndex = 5;
      isLoading = false;
      _getMoreData(page);
    });

    RxBus.register<TaskFilterModel>(tag: "SEARCH_TASK_FILTER").listen(
      (event) {
        page = 1;
        scrollIndex = 5;
        isLoading = false;
        _getMoreData(page);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    RxBus.destroy(tag: "SEARCH_TASK_FILTER");
    RxBus.destroy(tag: "SEARCH_TASK_EVENT");
  }
}
