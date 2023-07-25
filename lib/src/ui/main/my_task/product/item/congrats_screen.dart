import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';

class CongratsScreen extends StatefulWidget {
  const CongratsScreen({super.key});

  @override
  State<CongratsScreen> createState() => _CongratsScreenState();
}

class _CongratsScreenState extends State<CongratsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
          SvgPicture.asset(AppAssets.review),
          const SizedBox(height: 48),
          Text(
            translate("my_task.thanks"),
            style: AppTypography.h2SmallDark00,
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              translate("my_task.con_title"),
              textAlign: TextAlign.center,
              style: AppTypography.pSmall3Dark00,
            ),
          ),
        ],
      ),
      floatingActionButton: YellowButton(
        text: translate("my_task.clear"),
        margin: const EdgeInsets.only(left: 48),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
