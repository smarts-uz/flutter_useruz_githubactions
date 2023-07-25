import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youdu/src/constants/constants.dart';

class MoreScreenShimmer extends StatelessWidget {
  const MoreScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 24,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                margin: const EdgeInsets.only(top: 28, left: 16, right: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
