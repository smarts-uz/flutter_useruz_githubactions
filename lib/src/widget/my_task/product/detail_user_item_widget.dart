import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/otklik_model.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';
import 'package:youdu/src/widget/stars/stars_widget.dart';

class DetailUserItemWidget extends StatelessWidget {
  final User data;

  const DetailUserItemWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate("my_task.custom"),
            style: const TextStyle(
              fontFamily: AppTypography.fontFamilyProxima,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              height: 1.5,
              color: AppColors.dark33,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                height: 54,
                width: 54,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(48),
                  child: CustomNetworkImage(
                    height: 72,
                    width: 72,
                    image: data.avatar,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: AppTypography.pSmallRegularDark33SemiBold,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AppAssets.clock,
                        height: 14,
                        width: 14,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        data.lastSeen,
                        textAlign: TextAlign.start,
                        style: AppTypography.pTinyGrey94.copyWith(
                          color: AppColors.grey95,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(AppAssets.like, height: 14, width: 14),
                      Text(
                        data.likes.toString(),
                        textAlign: TextAlign.start,
                        style: AppTypography.pTinyGrey94.copyWith(
                          color: AppColors.grey95,
                        ),
                      ),
                      const SizedBox(width: 24),
                      SvgPicture.asset(
                        AppAssets.dislike,
                        height: 14,
                        width: 14,
                      ),
                      Text(
                        data.dislikes.toString(),
                        textAlign: TextAlign.start,
                        style: AppTypography.pTinyGrey94.copyWith(
                          color: AppColors.grey95,
                        ),
                      ),
                      const SizedBox(width: 24),
                      StarsWidget(count: data.stars),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
