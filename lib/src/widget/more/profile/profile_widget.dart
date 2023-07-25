import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';

class ProfileWidget extends StatelessWidget {
  final String title;
  final String content;

  const ProfileWidget({
    super.key,
    required this.content,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 20,
            color: Color.fromRGBO(0, 0, 0, 0.08),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppTypography.h2SmallDark00Medium.copyWith(
              color: AppColors.dark33,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            content,
            style: AppTypography.pTinyDark33Normal.copyWith(
              color: AppColors.greyD6,
            ),
          ),
        ],
      ),
    );
  }
}

class TextTasks extends StatelessWidget {
  final String title;
  final String content;

  const TextTasks({
    Key? key,
    required this.content,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.pTiny215ProDark33,
          ),
          Text(
            content,
            style: AppTypography.pTinyDark33Normal.copyWith(
              color: AppColors.greyAD,
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmationWidget extends StatelessWidget {
  final String icon;
  final String title;
  final Function() onTap;

  const ConfirmationWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: Colors.transparent,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
          ),
          const SizedBox(
            width: 26,
          ),
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppTypography.fontFamilyProxima,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontSize: 17,
              height: 22 / 15,
              color: AppColors.dark33,
            ),
          )
        ],
      ),
    );
  }
}
