import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';

class BackWidget extends StatelessWidget {
  final Color color;

  const BackWidget({super.key, this.color = AppColors.yellow00});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: SvgPicture.asset(AppAssets.back, color: color),
        ),
      ),
    );
  }
}
