import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/profile/profile_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';

class FinalViewScreen extends StatefulWidget {
  const FinalViewScreen({super.key});

  @override
  State<FinalViewScreen> createState() => _FinalViewScreenState();
}

class _FinalViewScreenState extends State<FinalViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.width / 3) * 2,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Image.asset(AppAssets.finalView),
          ),
          Text(
            translate("performers.compliment"),
            style: AppTypography.h2SmallYellow,
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("performers.title1"),
              textAlign: TextAlign.center,
              style: AppTypography.pSmall3Dark00.copyWith(
                fontStyle: FontStyle.normal,
                color: AppColors.dark33,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "",
                children: [
                  TextSpan(
                    text: translate("performers.title2"),
                    style: AppTypography.pSmall3Dark00.copyWith(
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  TextSpan(
                    text: "USer.Uz!",
                    style: AppTypography.pSmall3Dark00.copyWith(
                      fontStyle: FontStyle.normal,
                      color: AppColors.yellow00,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: YellowButton(
        text: translate("performers.access"),
        onTap: () async {
          profileBloc.getProfile(-1, context);
          Navigator.pop(context);
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
