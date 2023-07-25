import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/database/security_storage.dart';

class AutoLockModalSheet extends StatefulWidget {
  const AutoLockModalSheet({super.key});

  @override
  State<AutoLockModalSheet> createState() => _AutoLockModalSheetState();
}

class _AutoLockModalSheetState extends State<AutoLockModalSheet> {
  List<String> durationList = [
    translate('security.auto_lock_duration.exit_5_minutes'),
    translate('security.auto_lock_duration.exit_10_minutes'),
    translate('security.auto_lock_duration.exit_15_minutes'),
    translate('security.auto_lock_duration.exit_30_minutes'),
    translate('security.auto_lock_duration.exit_45_minutes'),
    translate('security.auto_lock_duration.exit_1_hour'),
    translate('security.auto_lock_duration.never'),
  ];

  List<int> durationValueList = [5, 10, 15, 30, 45, 60, -1];

  late int click;

  @override
  void initState() {
    super.initState();
    click = durationValueList.indexOf(SecurityStorage.instance.lockDuration!);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Builder(
        builder: (context) {
          return CupertinoPageScaffold(
            backgroundColor: Colors.white,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.white,
              appBar: AppBar(
                elevation: 1,
                centerTitle: true,
                backgroundColor: AppColors.white,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.closeX,
                      height: 24,
                      width: 24,
                      color: AppColors.yellow16,
                    ),
                  ),
                ),
                title: Text(
                  translate("security.auto_lock"),
                  style: AppTypography.pSmall1,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    for (int i = 0; i < durationList.length; i++)
                      GestureDetector(
                        onTap: () {
                          SecurityStorage.instance
                              .saveLockDuration(durationValueList[i]);
                          setState(() => click = i);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    durationList[i],
                                    style: AppTypography.pTiny215ProDark33,
                                  ),
                                  click == i
                                      ? SvgPicture.asset(AppAssets.yellowCheck)
                                      : SvgPicture.asset(AppAssets.greyCircle),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                color: AppColors.greyE9,
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
