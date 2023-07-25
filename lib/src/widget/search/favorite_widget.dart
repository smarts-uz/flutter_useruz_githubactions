import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';

class FavoriteWidget extends StatelessWidget {
  final Function() onTap;

  const FavoriteWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Center(
        child: SizedBox(
          height: 28,
          width: 28,
          child: Stack(
            children: [
              const Positioned(
                  top: 0,
                  right: 0,
                  child: SizedBox(
                    height: 8,
                    width: 8,
                  )),
              Positioned(
                bottom: 1.5,
                left: 0,
                child: SvgPicture.asset(AppAssets.favoriteIcon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
