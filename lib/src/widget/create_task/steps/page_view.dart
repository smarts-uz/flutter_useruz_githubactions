import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';

class PageViewWidget extends StatelessWidget {
  final int i;

  const PageViewWidget({super.key, required this.i});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 7,
        itemBuilder: (_, index) {
          return Container(
            height: 5,
            width: 33,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: i >= index ? AppColors.yellow00 : AppColors.greyEA,
            ),
          );
        },
      ),
    );
  }
}
