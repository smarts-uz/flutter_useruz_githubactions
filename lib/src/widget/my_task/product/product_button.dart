import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/my_task/product/item/review_screen.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';

class ProductButtonWidget extends StatelessWidget {
  final int id;
  final Function() onTap;

  const ProductButtonWidget({
    super.key,
    required this.id,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          YellowButton(
            text: translate("my_task.final_task"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewScreen(
                    id: id,
                    status: 1,
                  ),
                ),
              );
            },
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewScreen(
                    id: id,
                    status: 0,
                  ),
                ),
              );
            },
            child: Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 2,
                  color: AppColors.red5B,
                ),
              ),
              child: Center(
                child: Text(
                  translate("my_task.no_final_task"),
                  style: AppTypography.pTiny215Pro.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16)
        ],
      ),
    );
  }
}
