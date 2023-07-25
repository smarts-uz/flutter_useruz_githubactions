// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/my_task_bloc.dart';
import 'package:youdu/src/bloc/task/tasks_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/dialog/bottom_dialog.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/api_model/tasks/status_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/my_task/product/item/detail_screen.dart';
import 'package:youdu/src/ui/main/my_task/product/item/responses_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/my_task/product/product_button.dart';
import 'package:youdu/src/widget/my_task/product/product_item_image_widget.dart';
import 'package:youdu/src/widget/my_task/product/product_item_info_widget.dart';
import 'package:youdu/src/widget/shimmer/task_view_shimmer.dart';

import '../../../../utils/rx_bus.dart';
import '../../../../utils/sliver_app_bar_delegate.dart';
import '../../../../widget/my_task/btn/another_user_widget.dart';
import '../../../../widget/my_task/btn/cancel_product_widget.dart';

class ProductItemScreen extends StatefulWidget {
  final int id;

  const ProductItemScreen({super.key, required this.id});

  @override
  State<ProductItemScreen> createState() => _ProductItemScreenState();
}

class _ProductItemScreenState extends State<ProductItemScreen> {
  String token = "";
  TextEditingController controller = TextEditingController();
  Repository repository = Repository();
  bool loading = false;

  StatusModel? status;
  String text = "";
  int userId = 0;

  @override
  void initState() {
    taskBloc.getInfoTask(widget.id, context);
    _getToken();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: taskBloc.infoTasks,
        builder: (context, AsyncSnapshot<TaskModel> snapshot) {
          if (snapshot.hasData) {
            TaskModel data = snapshot.data!;
            return DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      floating: false,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: AppColors.white,
                      leading: const BackWidget(
                        color: AppColors.dark33,
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(
                          "${translate("performers.task")} № ${data.id}",
                          style: AppTypography.pSmall1,
                        ),
                      ),
                      actions: [
                        GestureDetector(
                          onTap: () async {
                            BottomDialog.bottomDialogProfile(
                              context,
                              data.isMine,
                              block: false,
                              (id) {
                                if (id == 1) {
                                  shareLink(widget.id);
                                }
                                if (id == 0) {
                                  BottomDialog.bottomDialogText(
                                    context,
                                    status!,
                                    (tex) {
                                      text = tex;
                                      setState(() {});
                                    },
                                    controller,
                                    (id) async {
                                      HttpResult response =
                                          await repository.jaloba(
                                        id,
                                        data.id,
                                        text,
                                      );
                                      if (response.isSuccess) {
                                        CenterDialog.messageDialog(
                                            context, response.result["message"],
                                            () {
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        if (response.status == -1) {
                                          CenterDialog.networkErrorDialog(
                                              context);
                                        } else {
                                          CenterDialog.errorDialog(
                                            context,
                                            Utils.serverErrorText(response),
                                            response.result.toString(),
                                          );
                                        }
                                      }
                                    },
                                  );
                                }
                              },
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 16),
                            color: Colors.transparent,
                            child: widget.id == -1
                                ? SvgPicture.asset(
                                    AppAssets.share,
                                    color: AppColors.yellow00,
                                  )
                                : RotatedBox(
                                    quarterTurns: 1,
                                    child: SvgPicture.asset(AppAssets.profile),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SliverAppBar(
                      expandedHeight: 208,
                      elevation: 0,
                      backgroundColor: AppColors.white,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: EdgeInsets.zero,
                        title: ProductItemImageWidget(
                          image: data.photos,
                        ),
                      ),
                    ),
                    SliverAppBar(
                      expandedHeight: 130,
                      collapsedHeight: 130,
                      elevation: 0,
                      backgroundColor: AppColors.white,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: false,
                        titlePadding: EdgeInsets.zero,
                        title: ProductItemInfoWidget(
                          data: data,
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: SliverAppBarDelegate(
                        TabBar(
                          labelColor: AppColors.yellow00,
                          unselectedLabelColor: AppColors.greyBF,
                          indicatorColor: AppColors.yellow00,
                          physics: const NeverScrollableScrollPhysics(),
                          labelStyle: AppTypography.pTinyPro,
                          unselectedLabelStyle: AppTypography.pTinyPro,
                          tabs: [
                            Tab(
                              text: translate("my_task.detail"),
                            ),
                            Tab(
                              text: translate("my_task.click"),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        background: AppColors.white,
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          DetailScreen(
                            data: data,
                          ),
                          ResponsesScreen(
                            selectedMe:
                                !data.isMine && data.performer.id == userId,
                            id: data.id,
                            isMine: data.isMine,
                            data: data,
                            status: data.status,
                          ),
                        ],
                      ),
                    ),
                    if (token != "")
                      if (data.isMine &&
                          data.responsesCount == 0 &&
                          data.status == 1)
                        CancelProductWidget(
                          data: data,
                        ),
                    if (data.isMine && data.status == 6)
                      YellowButton(
                        text: translate("otmen_btn"),
                        loading: loading,
                        margin: EdgeInsets.only(
                            bottom: Platform.isIOS ? 24 : 16,
                            left: 16,
                            right: 16),
                        onTap: () async {
                          loading = true;
                          setState(() {});
                          HttpResult response =
                              await repository.changeStatus(data.id);
                          if (response.isSuccess) {
                            CenterDialog.messageDialog(
                                context, response.result["message"], () {
                              RxBus.post("", tag: "SEARCH_TASK_EVENT");
                              myTaskBloc.getAllCount(0, context);
                              myTaskAsPerformerBloc.getAllCount(context);
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            });
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
                          loading = false;
                          setState(() {});
                        },
                      ),
                    if (!data.isMine &&
                        token != "" &&
                        !data.currentUserResponse &&
                        data.status == 1)
                      AnotherUserWidget(
                        data: data,
                      ),
                    if (data.isMine &&
                        data.performer.id != 0 &&
                        data.status == 3)
                      ProductButtonWidget(
                        id: data.id,
                        onTap: () {
                          BottomDialog.bottomDialogText(
                            context,
                            status!,
                            (tex) {
                              text = tex;
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            controller,
                            (id) async {
                              HttpResult response = await repository.jaloba(
                                id,
                                data.id,
                                text,
                              );
                              if (response.isSuccess) {
                                CenterDialog.messageDialog(
                                    context, response.result["message"], () {
                                  Navigator.pop(context);
                                });
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
                            },
                          );
                        },
                      ),
                    if (!data.isMine &&
                        data.performer.id == userId &&
                        data.status == 4 &&
                        data.performerReview == 0)
                      ProductButtonWidget(
                        id: data.id,
                        onTap: () {
                          BottomDialog.bottomDialogText(
                            context,
                            status!,
                            (tex) {
                              text = tex;
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            controller,
                            (id) async {
                              HttpResult response = await repository.jaloba(
                                id,
                                data.id,
                                text,
                              );
                              if (response.isSuccess) {
                                CenterDialog.messageDialog(
                                    context, response.result["message"], () {
                                  Navigator.pop(context);
                                });
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
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          }
          return const TaskViewShimmer();
        },
      ),
    );
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("accessToken") ?? "";
    userId = prefs.getInt("id") ?? 0;
    HttpResult response = await repository.getStatus();
    if (response.isSuccess) {
      status = statusModelFromJson(
        json.encode(response.result),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  shareLink(int id) {
    Share.share("http://user.uz/detailed-tasks/$id");
  }
}
