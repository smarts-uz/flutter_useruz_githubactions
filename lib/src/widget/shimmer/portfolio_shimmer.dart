import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youdu/src/constants/constants.dart';

class PortfolioShimmer extends StatefulWidget {
  const PortfolioShimmer({super.key});

  @override
  State<PortfolioShimmer> createState() => _PortfolioShimmerState();
}

class _PortfolioShimmerState extends State<PortfolioShimmer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 24),
              Container(
                height: 32,
                width: 250,
                color: AppColors.white,
              ),
              const SizedBox(height: 16),
              Container(
                height: 24,
                width: 180,
                color: AppColors.white,
              ),
              const SizedBox(height: 8),
              Container(
                height: 24,
                width: MediaQuery.of(context).size.width - 50,
                color: AppColors.white,
              ),
              const SizedBox(height: 24),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8)),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                height: 32,
                width: 250,
                color: AppColors.white,
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 24,
                width: 180,
                color: AppColors.white,
              ),
              const SizedBox(height: 8),
              Container(
                height: 24,
                width: MediaQuery.of(context).size.width - 50,
                color: AppColors.white,
              ),
              const SizedBox(height: 24),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8)),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
