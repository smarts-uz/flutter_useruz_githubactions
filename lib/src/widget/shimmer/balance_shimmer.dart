import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youdu/src/constants/constants.dart';

class BalanceShimmer extends StatelessWidget {
  const BalanceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            margin:
                const EdgeInsets.only(left: 40, right: 40, top: 32, bottom: 32),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 20,
                  color: Color.fromRGBO(0, 0, 0, 0.08),
                )
              ],
            ),
          ),
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
            color: AppColors.white,
          ),
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 48),
            color: AppColors.white,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      width: 100,
                      color: AppColors.white,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 16,
                      width: 150,
                      color: AppColors.white,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 18,
                  width: 130,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      width: 100,
                      color: AppColors.white,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 16,
                      width: 150,
                      color: AppColors.white,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 18,
                  width: 130,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      width: 100,
                      color: AppColors.white,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 16,
                      width: 150,
                      color: AppColors.white,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 18,
                  width: 130,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      width: 100,
                      color: AppColors.white,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 16,
                      width: 150,
                      color: AppColors.white,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 18,
                  width: 130,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      width: 100,
                      color: AppColors.white,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 16,
                      width: 150,
                      color: AppColors.white,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 18,
                  width: 130,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
