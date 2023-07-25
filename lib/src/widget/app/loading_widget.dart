import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';

class LoadingWidget extends StatelessWidget {
  final bool isLoading;

  const LoadingWidget({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Opacity(
        opacity: isLoading ? 0.0 : 1.0,
        child: const SizedBox(
          height: 44,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.yellow00,
            ),
          ),
        ),
      ),
    );
  }
}
