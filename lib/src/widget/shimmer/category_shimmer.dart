// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youdu/src/constants/constants.dart';

class CategoryShimmer extends StatelessWidget {
  final bool subCategory;

  const CategoryShimmer({super.key, this.subCategory = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: AppColors.greyE9,
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 21,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    translate("filter.all_category"),
                    style: AppTypography.pSmall3Dark3306.copyWith(
                      color: AppColors.dark33,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  AppAssets.checkUnselected,
                  height: 24,
                  width: 24,
                )
              ],
            ),
          ),
        ),
        Container(
          height: 16,
          color: const Color(0xFFFAF8F5),
          width: MediaQuery.of(context).size.width,
        ),
        Expanded(
          child: Shimmer.fromColors(
            child: ListView.builder(
              itemBuilder: (_, __) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 18,
                                  width: 210,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                subCategory
                                    ? Container()
                                    : const SizedBox(height: 12),
                                subCategory
                                    ? Container()
                                    : Container(
                                        height: 12,
                                        width: 125,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      )
                              ],
                            ),
                          ),
                          SvgPicture.asset(
                            AppAssets.arrowRight,
                            height: 24,
                            width: 24,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 56),
                      width: MediaQuery.of(context).size.width,
                      color: const Color(0xFFEFEDE9),
                    ),
                  ],
                );
              },
              itemCount: 20,
            ),
            baseColor: AppColors.shimmerBase,
            highlightColor: AppColors.shimmerHighlight,
          ),
        ),
      ],
    );
  }
}
