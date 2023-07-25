import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youdu/src/constants/app_assets.dart';

class StarsWidget extends StatelessWidget {
  final int count;

  const StarsWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 24,
        ),
        SizedBox(
          height: 20,
          child: ListView.builder(
            itemCount: 5,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: SvgPicture.asset(
                  index >= count ? AppAssets.star : AppAssets.clickStar,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
