// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/task/tasks_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/task_filter_model.dart';
import 'package:youdu/src/model/api_model/tasks/tasks_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/my_task/product/product_item_screen.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/loading_widget.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/search/task_list_widget.dart';
import 'package:youdu/src/widget/shimmer/search_shimmer.dart';

class SearchListScreen extends StatefulWidget {
  final TaskFilterModel filterData;
  final Function dragFunction;

  const SearchListScreen({
    super.key,
    required this.filterData,
    required this.dragFunction,
  });

  @override
  State<SearchListScreen> createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen>
    with AutomaticKeepAliveClientMixin<SearchListScreen> {
  @override
  bool get wantKeepAlive => true;
  Repository repository = Repository();
  String text = "";
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  bool isLoading = false;
  int scrollIndex = 5;
  int page = 1;
  late TaskFilterModel filterData;

  bool tap = false;

  @override
  void initState() {
    filterData = widget.filterData;
    _initBus();
    _getMoreData(page, filterData);
    itemPositionsListener.itemPositions.addListener(() {
      if (itemPositionsListener.itemPositions.value.last.index == scrollIndex) {
        scrollIndex += 10;
        _getMoreData(page, filterData);
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
      child: GestureDetector(
        onHorizontalDragEnd: ((details) => widget.dragFunction(details)),
        child: StreamBuilder<TasksModel>(
          stream: taskBloc.allTasks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<TaskModelResult> data = snapshot.data!.data;
              snapshot.data!.lastPage == page - 1
                  ? isLoading = true
                  : isLoading = false;
              return data.isEmpty
                  ? Center(
                      child: Text(
                        translate("empty"),
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
                        return TaskListWidget(
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
      ),
    );
  }

  void _getMoreData(int index, TaskFilterModel filter) async {
    if (!isLoading) {
      taskBloc.getAllTasks(index, text, filter, context);
      page++;
    }
  }

  Future<bool> restart() async {
    isLoading = false;
    page = 1;
    scrollIndex = 5;
    await taskBloc.getAllTasks(page, text, filterData, context);
    page++;
    return true;
  }

  void _initBus() {
    RxBus.register<String>(tag: "SEARCH_TASK_EVENT").listen((event) {
      page = 1;
      scrollIndex = 5;
      isLoading = false;
      text = event;
      _getMoreData(page, filterData);
    });

    RxBus.register<TaskFilterModel>(tag: "SEARCH_TASK_FILTER").listen(
      (event) {
        page = 1;
        scrollIndex = 5;
        isLoading = false;
        filterData = event;
        _getMoreData(page, event);
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
