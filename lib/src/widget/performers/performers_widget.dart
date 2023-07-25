import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/guest/performers/all_performers_model.dart';
import 'package:youdu/src/ui/main/more/screens/profile/profile_screen.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/stars/stars_widget.dart';

class PerformersWidget extends StatefulWidget {
  final PerformersModel data;
  final Function() onTap;
  final int id;

  const PerformersWidget({
    super.key,
    required this.data,
    required this.onTap,
    required this.id,
  });

  @override
  State<PerformersWidget> createState() => _PerformersWidgetState();
}

class _PerformersWidgetState extends State<PerformersWidget> {
  Repository repository = Repository();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              id: widget.data.id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(48),
                  child: CustomNetworkImage(
                    height: 54,
                    width: 54,
                    image: widget.data.avatar,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.name,
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
                          widget.data.lastSeen,
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
                          widget.data.likes.toString(),
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
                          widget.data.dislikes.toString(),
                          textAlign: TextAlign.start,
                          style: AppTypography.pTinyGrey94.copyWith(
                            color: AppColors.grey95,
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        StarsWidget(
                          count: widget.data.stars,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              widget.data.description,
              textAlign: TextAlign.start,
              style: AppTypography.pTinyGrey94.copyWith(
                color: AppColors.dark33,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            widget.data.id == widget.id
                ? Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.greyAD,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        translate("performers.btn_task"),
                        style: AppTypography.pSmall1SemiBoldWhite.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ),
                  )
                : YellowButton(
                    text: translate("performers.btn_task"),
                    margin: EdgeInsets.zero,
                    onTap: () {
                      widget.onTap();
                    },
                  ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width,
              color: AppColors.greyEB,
            )
          ],
        ),
      ),
    );
  }
}
