import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/database/favorite_storage.dart';
import 'package:youdu/src/model/api_model/tasks/favorite_tasks_model.dart'
    as favorite;
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';

class FavoriteTaskListWidget extends StatefulWidget {
  final favorite.TaskModelResult data;
  final Function() onTap;

  const FavoriteTaskListWidget(
      {super.key, required this.data, required this.onTap});

  @override
  State<FavoriteTaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<FavoriteTaskListWidget> {
  bool loading = false;
  bool loading1 = false;
  Repository repository = Repository();
  bool isLoading = false;
  var isFavorite = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomNetworkImage(
                    image: widget.data.categoryIcon,
                    height: 42,
                    width: 42,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              widget.data.name,
                              maxLines: 1,
                              style:
                                  AppTypography.pSmall1SemiBoldDark33.copyWith(
                                color: widget.data.viewed
                                    ? AppColors.viewedTitle
                                    : AppColors.dark33,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await FavoriteStorage.instance
                                  .toggleFavorite(widget.data.id);
                              setState(() {});
                            },
                            icon: FavoriteStorage.instance
                                    .isFavorite(widget.data.id)
                                ? SvgPicture.asset(
                                    AppAssets.selectedFavoritetask)
                                : SvgPicture.asset(
                                    AppAssets.unselectedFavoritetask),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: SvgPicture.asset(
                                AppAssets.addressLocation,
                                height: 14,
                                width: 14,
                                color: widget.data.viewed
                                    ? AppColors.viewedSubTitle
                                    : AppColors.grey84,
                              ),
                            ),
                            const WidgetSpan(
                              child: SizedBox(width: 4),
                            ),
                            TextSpan(
                              text: widget.data.addresses.isEmpty
                                  ? translate("create_task.remote_1")
                                  : widget.data.addresses.first.location,
                              style: AppTypography.pTiny.copyWith(
                                color: widget.data.viewed
                                    ? AppColors.viewedSubTitle
                                    : AppColors.grey84,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            widget.data.startDate != ""
                                ? WidgetSpan(
                                    child: SvgPicture.asset(
                                      AppAssets.clock,
                                      height: 14,
                                      width: 14,
                                      color: widget.data.viewed
                                          ? AppColors.viewedSubTitle
                                          : AppColors.grey84,
                                    ),
                                  )
                                : WidgetSpan(child: Container()),
                            const WidgetSpan(
                              child: SizedBox(width: 4),
                            ),
                            widget.data.startDate.toString() != ""
                                ? TextSpan(
                                    text: translate("create_task.begin") +
                                        Utils.dateNameFormatCreateDate(
                                            DateTime.parse(widget.data.startDate
                                                .toString())),
                                    style: AppTypography.pTiny.copyWith(
                                      color: widget.data.viewed
                                          ? AppColors.viewedSubTitle
                                          : AppColors.grey84,
                                    ))
                                : const TextSpan(),
                          ],
                        ),
                      ),
                      widget.data.endDate.toString() == ""
                          ? Container()
                          : RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: SvgPicture.asset(
                                      AppAssets.clock,
                                      height: 14,
                                      width: 14,
                                      color: widget.data.viewed
                                          ? AppColors.viewedSubTitle
                                          : AppColors.grey84,
                                    ),
                                  ),
                                  const WidgetSpan(
                                    child: SizedBox(width: 4),
                                  ),
                                  TextSpan(
                                      text: translate("create_task.end") +
                                          Utils.dateNameFormatCreateDate(
                                              DateTime.parse(widget.data.endDate
                                                  .toString())),
                                      style: AppTypography.pTiny.copyWith(
                                        color: widget.data.viewed
                                            ? AppColors.viewedSubTitle
                                            : AppColors.grey84,
                                      )),
                                ],
                              ),
                            ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                              LanguagePerformers.getLanguage() == "ru"
                                  ? "${translate("up")} ${priceFormat.format(num.parse(widget.data.budget.toString()))} ${translate("sum")}"
                                  : "${priceFormat.format(num.parse(widget.data.budget.toString()))} ${translate("sum")} ${translate("up")}",
                              style: AppTypography.pTiny.copyWith(
                                color: widget.data.viewed
                                    ? AppColors.viewedSubTitle
                                    : AppColors.grey84,
                              )),
                          const SizedBox(width: 12),
                          Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: AppColors.yellowEE,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                widget.data.oplata != "1"
                                    ? AppAssets.card
                                    : AppAssets.cash,
                                height: 16,
                                width: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: AppColors.greyEB)
          ],
        ),
      ),
    );
  }
}
