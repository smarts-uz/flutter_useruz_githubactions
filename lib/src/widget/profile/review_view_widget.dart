import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/profile/review_model.dart';
import 'package:youdu/src/ui/main/more/screens/profile/profile_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';
import 'package:youdu/src/widget/stars/stars_widget.dart';

class ReviewViewWidget extends StatelessWidget {
  final ReviewData data;

  const ReviewViewWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              id: data.user.id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 16,
              width: MediaQuery.of(context).size.width,
              color: AppColors.greyFB,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(48),
                  child: CustomNetworkImage(
                    height: 54,
                    width: 54,
                    image: data.user.avatar,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.user.name,
                      style: AppTypography.pSmallRegularDark33SemiBold,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.clock,
                          height: 14,
                          width: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data.user.lastSeen.toString(),
                          textAlign: TextAlign.start,
                          style: AppTypography.pTinyGrey94.copyWith(
                            color: AppColors.grey95,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.like,
                          height: 14,
                          width: 14,
                          color: AppColors.blue91,
                        ),
                        Text(
                          data.user.reviewGood.toString(),
                          textAlign: TextAlign.start,
                          style: AppTypography.pTinyGrey94.copyWith(
                            color: AppColors.blue91,
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        SvgPicture.asset(
                          AppAssets.dislike,
                          height: 14,
                          width: 14,
                          color: AppColors.blue91,
                        ),
                        Text(
                          data.user.reviewBad.toString(),
                          textAlign: TextAlign.start,
                          style: AppTypography.pTinyGrey94.copyWith(
                            color: AppColors.blue91,
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        StarsWidget(
                          count: data.user.rating,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  data.goodBad == 1 ? AppAssets.like : AppAssets.dislike,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    data.task.name,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamilyProxima,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      height: 20 / 15,
                      color: AppColors.dark33,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                SvgPicture.asset(
                  AppAssets.arrowRight,
                  height: 20,
                  width: 20,
                  color: AppColors.grey9A,
                ),
              ],
            ),
            Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              color: AppColors.greyEB,
            ),
            Text(
              data.description,
              style: AppTypography.pSmall3Dark00,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const Spacer(),
                Text(
                  "${Utils.numberFormat(data.createdAt.day)}.${Utils.numberFormat(data.createdAt.month)}."
                  "${Utils.numberFormat(data.createdAt.year)} ${Utils.numberFormat(data.createdAt.hour)}:${Utils.numberFormat(data.createdAt.minute)}",
                  style: AppTypography.pTinyGrey94,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
