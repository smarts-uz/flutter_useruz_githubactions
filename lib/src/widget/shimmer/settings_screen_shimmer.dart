import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youdu/src/constants/constants.dart';

class SettingsScreenShimmer extends StatelessWidget {
  const SettingsScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 36,
            ),
            Container(
              height: 12,
              width: 100,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            Container(
              height: 16,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 1,
              margin: const EdgeInsets.only(bottom: 24),
              color: AppColors.greyEB,
            ),
            Container(
              height: 12,
              width: 100,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            Container(
              height: 16,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 1,
              margin: const EdgeInsets.only(bottom: 24),
              color: AppColors.greyEB,
            ),
            Container(
              height: 12,
              width: 100,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            Container(
              height: 16,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 1,
              margin: const EdgeInsets.only(bottom: 24),
              color: AppColors.greyEB,
            ),
            Container(
              height: 12,
              width: 100,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            Container(
              height: 16,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 1,
              margin: const EdgeInsets.only(bottom: 24),
              color: AppColors.greyEB,
            ),
            Container(
              height: 12,
              width: 100,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            Container(
              height: 16,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 1,
              margin: const EdgeInsets.only(bottom: 24),
              color: AppColors.greyEB,
            ),
            Container(
              height: 12,
              width: 100,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            Container(
              height: 16,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 1,
              margin: const EdgeInsets.only(bottom: 24),
              color: AppColors.greyEB,
            ),
            Container(
              height: 12,
              width: MediaQuery.of(context).size.width - 24,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
            Container(
              height: 12,
              width: 200,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(96),
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
