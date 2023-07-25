import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/profile/my_task_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/profile/may_task_count_model.dart';
import 'package:youdu/src/widget/my_task/my_task_item.dart';
import 'package:youdu/src/widget/shimmer/my_task_count_shimmer.dart';

class AsCustomerScreen extends StatefulWidget {
  const AsCustomerScreen({super.key, required this.performer});
  final int performer;

  @override
  State<AsCustomerScreen> createState() => _AsCustomerScreenState();
}

class _AsCustomerScreenState extends State<AsCustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: myTaskBloc.allCount,
      builder: (context, AsyncSnapshot<MyTaskCountModel> snapshot) {
        if (snapshot.hasData) {
          MyTaskCountModel data = snapshot.data!;
          return !snapshot.data!.load
              ? Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.white,
                      ),
                      child: MyTaskItemWidget(
                        icon: AppAssets.allTask,
                        title: translate("my_task.all_task"),
                        status: data.data.all.status,
                        performer: widget.performer,
                        message:
                            '${data.data.all.count} ${translate("my_task.task")}',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.white,
                      ),
                      child: Column(
                        children: [
                          MyTaskItemWidget(
                            icon: AppAssets.open,
                            title: translate("my_task.bar.one"),
                            status: data.data.openTasks.status,
                            performer: widget.performer,
                            message:
                                '${data.data.openTasks.count} ${translate("my_task.task")}',
                          ),
                          MyTaskItemWidget(
                            icon: AppAssets.progress,
                            title: translate("my_task.bar.two"),
                            status: data.data.inProcessTasks.status,
                            performer: widget.performer,
                            message:
                                '${data.data.inProcessTasks.count} ${translate("my_task.task")}',
                          ),
                          MyTaskItemWidget(
                            icon: AppAssets.done,
                            title: translate("my_task.bar.three"),
                            status: data.data.completeTasks.status,
                            performer: widget.performer,
                            message:
                                '${data.data.completeTasks.count} ${translate("my_task.task")}',
                          ),
                          MyTaskItemWidget(
                            icon: AppAssets.cancel,
                            title: translate("my_task.bar.four"),
                            status: data.data.cancelledTasks.status,
                            performer: widget.performer,
                            message:
                                '${data.data.cancelledTasks.count} ${translate("my_task.task")}',
                          ),
                          MyTaskItemWidget(
                            icon: AppAssets.progress,
                            title: translate("no_complete"),
                            status: data.data.withoutReviews.status,
                            performer: widget.performer,
                            message:
                                '${data.data.withoutReviews.count} ${translate("my_task.task")}',
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : const MyTaskCountShimmer();
        } else {
          return const MyTaskCountShimmer();
        }
      },
    );
  }
}
