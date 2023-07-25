import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/profile/profile_model.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';

class PortfolioWidget extends StatelessWidget {
  final List<Portfolio> data;
  final Function() onTap;

  const PortfolioWidget({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, bottom: 16),
          child: Text(
            translate("profile.work_example"),
            style: AppTypography.h2SmallDark33Medium,
          ),
        ),
        data.isNotEmpty
            ? Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length > 10 ? 10 : data.length,
                  itemBuilder: (_, index) {
                    return data[index].images.isNotEmpty
                        ? Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CustomNetworkImage(
                                image: data[index].images[0],
                                height: 100,
                                width: 100,
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
              )
            : Container(),
        GestureDetector(
          onTap: () {
            data.isNotEmpty ? onTap() : null;
          },
          child: Container(
            color: Colors.transparent,
            margin: const EdgeInsets.only(left: 16, top: 14, bottom: 30),
            child: Text(
              data.isNotEmpty
                  ? translate("profile.see_work")
                  : translate("profile.not_work"),
              style: AppTypography.pTinyDark33Normal.copyWith(
                color: data.isNotEmpty ? AppColors.yellow00 : AppColors.red5B,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
