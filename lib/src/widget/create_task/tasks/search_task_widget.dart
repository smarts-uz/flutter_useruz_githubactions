import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youdu/src/constants/constants.dart';

class SearchTaskWidget extends StatelessWidget {
  final String text;
  final Function() onTap;

  const SearchTaskWidget({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 21, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: AppTypography.pSmall3Grey84.copyWith(
                        color: AppColors.dark33,
                      ),
                    ),
                  ),
                  SvgPicture.asset(AppAssets.arrowRight),
                ],
              ),
            ),
            Container(
              height: 0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: AppColors.greyF9,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
