import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/performers/add_performers/add_performers_page_view/add_performers_page_view_screen.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';

class MainViewScreen extends StatefulWidget {
  const MainViewScreen({super.key});

  @override
  State<MainViewScreen> createState() => _MainViewScreenState();
}

class _MainViewScreenState extends State<MainViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 24,
            width: 24,
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              AppAssets.closeX,
              color: AppColors.yellow00,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.width / 3) * 2,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: SvgPicture.asset(AppAssets.mainView, fit: BoxFit.cover),
          ),
          Text(
            translate("performers.about_me"),
            style: AppTypography.h2SmallYellow,
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("performers.title_register"),
              textAlign: TextAlign.center,
              style: AppTypography.pSmall3Dark00.copyWith(
                fontStyle: FontStyle.normal,
                color: AppColors.dark33,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: YellowButton(
        text: translate("performers.perform_reg"),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPerformersPageViewScreen(),
            ),
          );
        },
        margin: EdgeInsets.only(
          left: 48,
          right: 16,
          bottom: Platform.isIOS ? 24 : 16,
        ),
      ),
    );
  }
}
