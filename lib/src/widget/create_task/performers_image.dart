import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youdu/src/constants/constants.dart';

class PerformersImage extends StatelessWidget {
  const PerformersImage({super.key, required this.imgs});

  final List imgs;

  @override
  Widget build(BuildContext context) {
    return imgs.isEmpty
        ? Shimmer.fromColors(
            baseColor: AppColors.grey84,
            highlightColor: AppColors.greyD6,
            child: Container(
              width: 80,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          )
        : SizedBox(
            width: 80,
            height: 35,
            child: Stack(
              children: [
                SizedBox(
                  width: 35,
                  height: 35,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: imgs[0],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: ClipOval(
                      //borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: imgs[1],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 40,
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imgs[2],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
