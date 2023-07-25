// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/my_task_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/profile/my_task_model.dart';
import 'package:youdu/src/model/api_model/tasks/tasks_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/create_task/search/pod_searchs/category_screen.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/ui/main/my_task/product/product_item_screen.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/app/loading_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/search/task_list_widget.dart';
import 'package:youdu/src/widget/shimmer/search_shimmer.dart';

class MyTaskItemScreen extends StatefulWidget {
  final String title;
  final int status;
  final int performer;
  final int performId;
  final bool perform;
  final int userId;
  final bool profile;
  final int id;

  const MyTaskItemScreen({
    super.key,
    required this.title,
    required this.status,
    required this.performer,
    required this.performId,
    required this.perform,
    this.userId = -1,
    this.profile = false,
    this.id = 0,
  });

  @override
  State<MyTaskItemScreen> createState() => _MyTaskItemScreenState();
}

class _MyTaskItemScreenState extends State<MyTaskItemScreen>
    with AutomaticKeepAliveClientMixin<MyTaskItemScreen> {
  @override
  bool get wantKeepAlive => true;
  final ScrollController _scrollController = ScrollController();
  Repository repository = Repository();
  int page = 1;
  bool isLoading = false;
  List<TaskModelResult> taskData = <TaskModelResult>[];
  bool view = false;

  @override
  void initState() {
    _initBus();
    _getMoreData(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!widget.profile) {
          _getMoreData(page);
        }
      }
    });

    super.initState();
  }

  void _getMoreData(int page) async {
    if (!isLoading) {
      if (widget.profile) {
        myTaskBloc.getAllTasksByID(widget.id, context);
      } else {  
        if (widget.userId == -1) {
          myTaskBloc.getAllMyTask(
              widget.status, widget.performer, page, context);
        } else {
          myTaskBloc.getAllUserTask(widget.userId, widget.status, context);
        }
      }
      page++;
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: const BackWidget(),
        title: Text(
          widget.title,
          style: AppTypography.pSmall1,
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: myTaskBloc.allMyTask,
            builder: (context, AsyncSnapshot<MyTaskModel> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.currentPage == 1) {
                  taskData = [];
                }
                taskData.addAll(snapshot.data!.data);
                snapshot.data!.meta.lastPage == page ? isLoading = true : false;
                return Column(
                  children: [
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.greyE9,
                    ),
                    Expanded(
                      child: taskData.isEmpty
                          ? Center(
                              child: Text(
                                translate(
                                  "my_task.empty",
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: taskData.length + 1,
                              itemBuilder: (_, index) {
                                if (index == taskData.length) {
                                  return LoadingWidget(
                                    key: Key(isLoading.toString()),
                                    isLoading: isLoading,
                                  );
                                }
                                return TaskListWidget(
                                  data: taskData[index],
                                  onTap: () async {
                                    if (widget.perform) {
                                      view = true;
                                      setState(() {});
                                      HttpResult response =
                                          await repository.giveTask(
                                        widget.performId,
                                        taskData[index].id,
                                      );
                                      view = false;
                                      setState(() {});
                                      if (response.isSuccess) {
                                        if (response.result["success"] ==
                                            true) {
                                          setState(() {});
                                          CenterDialog.messageDialog(
                                            context,
                                            "${translate(
                                              "my_task.task1",
                                            )} “${taskData[index].name}” ${translate(
                                              "my_task.send1",
                                            )}",
                                            () {},
                                          );
                                        } else {
                                          setState(() {});
                                          CenterDialog.errorDialog(
                                            context,
                                            Utils.serverErrorText(response),
                                            response.result.toString(),
                                          );
                                        }
                                      } else if (response.status == -1) {
                                        setState(() {});
                                        CenterDialog.networkErrorDialog(
                                            context);
                                      } else {
                                        CenterDialog.errorDialog(
                                          context,
                                          Utils.serverErrorText(response),
                                          response.result.toString(),
                                        );
                                      }
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductItemScreen(
                                            id: taskData[index].id,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                    ),
                    widget.userId == -1
                        ? YellowButton(
                            text: widget.performer == 0
                                ? translate("create_task.create")
                                : translate("search.title"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => widget.performer == 0
                                      ? const CategoryScreen(
                                          myTask: true,
                                        )
                                      : const MainScreen(),
                                ),
                              );
                            },
                            margin: EdgeInsets.only(
                              top: 4,
                              left: 16,
                              right: 15,
                              bottom: Platform.isIOS ? 32 : 24,
                            ),
                          )
                        : const SizedBox()
                  ],
                );
              } else {
                return const SearchShimmer();
              }
            },
          ),
          !view
              ? Container()
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.dark00.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  @override
  void dispose() {
    RxBus.destroy(tag: "RELOAD_MY_TASK");
    super.dispose();
  }

  void _initBus() {
    RxBus.register<bool>(tag: "RELOAD_MY_TASK").listen(
      (event) {
        page = 1;
        isLoading = false;
        _getMoreData(page);
      },
    );
  }
}
