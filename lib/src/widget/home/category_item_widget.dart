import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youdu/src/constants/constants.dart';

class CategoryItemWidget extends StatelessWidget {
  final Function() onTap;
  final String image, message, title;
  final double iconSize;

  const CategoryItemWidget({
    super.key,
    required this.onTap,
    required this.image,
    required this.title,
    required this.message,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: image,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
                height: iconSize,
                width: iconSize,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamilyProxima,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.dark33,
                    ),
                  ),
                  message == ""
                      ? Container()
                      : Text(
                          message,
                          style: AppTypography.pTinyGreyAD,
                        ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppAssets.arrowRight,
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}
