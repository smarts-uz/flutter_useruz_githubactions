import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youdu/src/constants/constants.dart';

class PerformersFilterItem extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final bool isActive;
  final String label;
  const PerformersFilterItem({
    super.key,
    required this.onTap,
    required this.label,
    required this.image,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          color: Colors.transparent,
          child: Row(
            children: [
              SvgPicture.asset(
                image,
                color: AppColors.blueE6,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamilyProxima,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dark00,
                    fontSize: 16,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 370),
                curve: Curves.easeInOut,
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: isActive ? AppColors.yellow00 : AppColors.white,
                  border: Border.all(
                    color: isActive ? AppColors.yellow00 : AppColors.greyD6,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(AppAssets.checkWhite, height: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
