import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youdu/src/constants/constants.dart';

class NewsShimmer extends StatefulWidget {
  const NewsShimmer({super.key});

  @override
  State<NewsShimmer> createState() => _NewsShimmerState();
}

class _NewsShimmerState extends State<NewsShimmer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (_, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.white,
                  ),
                ),
                Container(
                  height: 32,
                  width: MediaQuery.of(context).size.width - 60,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: AppColors.white,
                ),
                Container(
                  height: 24,
                  width: MediaQuery.of(context).size.width - 100,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: AppColors.white,
                ),
                Container(
                  height: 24,
                  width: MediaQuery.of(context).size.width - 70,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: AppColors.white,
                ),
                Container(
                  height: 24,
                  width: MediaQuery.of(context).size.width - 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: AppColors.white,
                ),
                Container(
                  height: 24,
                  width: MediaQuery.of(context).size.width - 100,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: AppColors.white,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
