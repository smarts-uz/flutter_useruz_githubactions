import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/api_model/tasks/tasks_model.dart';
import 'package:youdu/src/ui/main/more/screens/profile/profile_screen.dart';
import 'package:youdu/src/ui/main/my_task/product/item/map_screen.dart';
import 'package:youdu/src/ui/main/my_task/product/product_item_screen.dart';
import 'package:youdu/src/widget/my_task/product/detail_user_item_widget.dart';
import 'package:youdu/src/widget/my_task/product/item_info_widget.dart';
import 'package:youdu/src/widget/my_task/product/item_type_widget.dart';
import 'package:youdu/src/widget/my_task/product/two_point_map_widget.dart';
import 'package:youdu/src/widget/search/task_list_widget.dart';

class DetailScreen extends StatefulWidget {
  final TaskModel data;

  const DetailScreen({super.key, required this.data});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<String> list1 = [];
  List<double> lat = [];
  List<double> lon = [];
  List<String> list2 = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.data.address.length; i++) {
      lat.add(widget.data.address[i].latitude);
      lon.add(widget.data.address[i].longitude);
      list1.add(
          "${widget.data.address[i].latitude},${widget.data.address[i].longitude}");
      list2.add(widget.data.address[i].location);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAF8F5),
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                list1.isEmpty
                    ? Container(
                        margin: const EdgeInsets.only(top: 24),
                        child: Text(translate("my_task.remote")))
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreenWidget(
                                list1: lat,
                                list2: lon,
                                name: list1,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: TwoPointMapWidget(
                            list1: lat,
                            list2: lon,
                            name: list2,
                          ),
                        ),
                      ),
                Container(
                  color: AppColors.greyE9,
                  margin: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                ),
                ItemInfoWidget(
                  description: widget.data.description,
                  data: widget.data.customFields,
                ),
                ItemTypeWidget(
                  start: widget.data.startDate,
                  end: widget.data.endDate,
                  now: DateTime.now(),
                ),
                Container(
                  color: AppColors.greyE9,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SvgPicture.asset(
                      widget.data.pay != "1" ? AppAssets.card : AppAssets.cash,
                      height: 24,
                      width: 24,
                      color: AppColors.blueE6,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      widget.data.pay != "1"
                          ? translate("my_task.pay1")
                          : translate("my_task.pay2"),
                      style: AppTypography.pSmall3Dark33H15,
                    )
                  ],
                ),
                Container(
                  color: AppColors.greyE9,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.passport,
                      height: 24,
                      width: 24,
                      color: AppColors.blueE6,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      translate("my_task.documents"),
                      style: AppTypography.pSmall3Dark33H15,
                    ),
                    const Spacer(),
                    Icon(
                      widget.data.docs == 0 ? Icons.close : Icons.check,
                      color: AppColors.yellow00,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
                Container(
                  color: AppColors.greyE9,
                  margin: const EdgeInsets.only(top: 16, bottom: 8),
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                ),
                Text(
                  "${translate("my_task.created")} ${widget.data.createdAt}"
                  "\n${translate("my_task.subcategory")} ${widget.data.other ? widget.data.parentCategoryName : ""} “${widget.data.categoryName}”",
                  style: AppTypography.pTinyGreyAD,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    id: widget.data.user.id,
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: DetailUserItemWidget(
                data: widget.data.user,
              ),
            ),
          ),
          const SizedBox(height: 16),
          widget.data.sameData.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    bottom: 12,
                  ),
                  color: AppColors.white,
                  child: Text(
                    translate("my_task.similar"),
                    style: AppTypography.h2Small.copyWith(
                      color: AppColors.dark33,
                    ),
                  ),
                )
              : Container(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: AppColors.white,
            child: Column(
              children: [
                ListView.builder(
                  itemBuilder: (context, index) {
                    TaskModelResult info = TaskModelResult(
                      id: widget.data.sameData[index].id,
                      name: widget.data.sameData[index].name,
                      startDate:
                          widget.data.sameData[index].startDate.toString(),
                      endDate: "",
                      addresses: widget.data.sameData[index].address,
                      viewed: false,
                      budget: widget.data.sameData[index].budget,
                      oplata: widget.data.sameData[index].oplata,
                      categoryIcon: widget.data.sameData[index].image,
                    );
                    return TaskListWidget(
                      data: info,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductItemScreen(
                              id: info.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.data.sameData.length,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
