import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/more/screens/profile/review/review_view_screen.dart';
import 'package:youdu/src/widget/stars/stars_widget.dart';

class ReviewsWidget extends StatelessWidget {
  final int good;
  final int bad;
  final int star;
  final String description;
  final String name;
  final int user;

  const ReviewsWidget({
    super.key,
    required this.good,
    required this.bad,
    required this.star,
    required this.description,
    required this.name,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(left: 16, top: 0, bottom: 12),
            child: Text(
              translate("profile.review"),
              style: AppTypography.h2SmallDark33Medium,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, top: 0, bottom: 6),
          child: Text(
            translate("profile.center"),
            style: AppTypography.pSmall3Grey84.copyWith(
              color: AppColors.dark33,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SvgPicture.asset(AppAssets.like),
              const SizedBox(width: 4),
              Text(
                good.toString(),
                style: AppTypography.pSmallRegularDark33,
              ),
              const SizedBox(width: 4),
              SvgPicture.asset(AppAssets.dislike),
              const SizedBox(width: 4),
              Text(
                bad.toString(),
                style: AppTypography.pSmallRegularDark33,
              ),
              StarsWidget(
                count: star,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        description != ""
            ? Container(
                margin: const EdgeInsets.only(
                    left: 16, top: 0, right: 16, bottom: 6),
                child: Text(
                  description,
                  style: AppTypography.pSmall3Grey84.copyWith(
                    color: AppColors.dark33,
                  ),
                ),
              )
            : Container(),
        name != ""
            ? Container(
                margin: const EdgeInsets.only(left: 16, top: 0, bottom: 14),
                child: Text(
                  name,
                  style: AppTypography.pTinyDark33Normal.copyWith(
                    color: AppColors.greyE7,
                  ),
                ),
              )
            : Container(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewViewScreen(
                  id: user,
                ),
              ),
            );
          },
          child: Container(
            margin:
                const EdgeInsets.only(left: 16, top: 0, bottom: 30, right: 16),
            color: Colors.transparent,
            child: Text(
              translate("profile.see_review"),
              style: AppTypography.pTinyDark33Normal.copyWith(
                color: AppColors.yellow00,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
