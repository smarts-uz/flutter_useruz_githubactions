import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';

class NewsWidget extends StatelessWidget {
  final String img;
  final String title;
  final String content;
  final String date;
  final Function() onTap;

  const NewsWidget({
    super.key,
    required this.img,
    required this.title,
    required this.content,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: MediaQuery.of(context).size.width - 32,
        width: MediaQuery.of(context).size.width - 32,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width - 32,
              width: MediaQuery.of(context).size.width - 32,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomNetworkImage(
                  image: img,
                  height: MediaQuery.of(context).size.width - 32,
                  width: MediaQuery.of(context).size.width - 32,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: (MediaQuery.of(context).size.width - 32) / 2,
                width: MediaQuery.of(context).size.width - 32,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(0, 0, 0, 0),
                      Color(0xFF000000),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 39, bottom: 8),
                      child: Text(
                        title,
                        style: AppTypography.h2SmallDark00Medium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: const EdgeInsets.only(right: 39, bottom: 8),
                    //   child: Text(
                    //     content,
                    //     style: const TextStyle(
                    //       fontFamily: AppTypography.fontFamilyProxima,
                    //       fontStyle: FontStyle.normal,
                    //       fontWeight: FontWeight.w400,
                    //       fontSize: 15,
                    //       height: 22 / 15,
                    //       color: AppColors.greyF9,
                    //     ),
                    //   ),
                    // ),
                    Row(
                      children: [
                        const Spacer(),
                        Text(date,
                            style: AppTypography.tinyText2.copyWith(
                              color: AppColors.greyD0,
                            )),
                        const SizedBox(width: 16),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
