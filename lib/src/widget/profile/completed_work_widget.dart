import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/profile/profile_model.dart';
import 'package:youdu/src/utils/language_performers.dart';

class CompletedWorkWidget extends StatelessWidget {
  final List<TasksCount> tasksCount;

  const CompletedWorkWidget({super.key, required this.tasksCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, top: 0, bottom: 8),
          child: Text(
            translate("profile.progress"),
            style: AppTypography.h2SmallDark33Medium,
          ),
        ),
        ListView.builder(
          itemCount: tasksCount.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (_, index) {
            int taskCount = 0;
            for (var element in tasksCount[index].tasksCountSub) {
              taskCount += element.taskCount.toInt();
            }
            return Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tasksCount[index].name, style: AppTypography.h3Small),
                  const SizedBox(height: 5),
                  taskCount > 0
                      ?
                      // ? Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       ...tasksCount[index]
                      //           .tasksCountSub
                      //           .where((element) => element.taskCount > 0)
                      //           .map(
                      //             (e) => Padding(
                      //               padding: const EdgeInsets.only(
                      //                   bottom: 2, right: 16),
                      //               child: Row(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.end,
                      //                 children: [
                      //                   Text(
                      //                     e.name,
                      //                     style: const TextStyle(
                      //                         fontFamily:
                      //                             AppTypography.fontFamilyProxima,
                      //                         fontWeight: FontWeight.w400,
                      //                         fontSize: 14,
                      //                         // height: 1.6,
                      //                         color: AppColors.dark6A),
                      //                   ),
                      //                   const SizedBox(
                      //                     width: 8,
                      //                   ),
                      //                   const Expanded(
                      //                     child: DottedDashedLine(
                      //                       height: 0,
                      //                       dashColor: AppColors.dark6A,
                      //                       axis: Axis.horizontal,
                      //                       dashHeight: 6,
                      //                       dashWidth: 2,
                      //                       width: 1000,
                      //                     ),
                      //                   ),
                      //                   const SizedBox(
                      //                     width: 8,
                      //                   ),
                      //                   Text(
                      //                     "${e.taskCount} ${translate("tasks")}",
                      //                     textAlign: TextAlign.right,
                      //                     style: const TextStyle(
                      //                       fontFamily:
                      //                           AppTypography.fontFamilyProxima,
                      //                       fontWeight: FontWeight.w400,
                      //                       fontSize: 14,
                      //                       // height: 1.5,
                      //                       color: AppColors.dark6A,
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           )
                      //     ],
                      //   )
                      Text(
                          LanguagePerformers.getLanguage() == 'ru'
                              ? '${translate("done")} $taskCount ${translate("tasks")}'
                              : '$taskCount ${translate("tasks")} ${translate("done")}',
                          style: AppTypography.pTiny2,
                        )
                      : Text(
                          translate("no_tasks_done"),
                          style: AppTypography.pTiny2,
                        )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
