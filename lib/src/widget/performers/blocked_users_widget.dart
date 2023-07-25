import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/blocked_users_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/blocked_user_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/more/screens/profile/profile_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';
import 'package:youdu/src/widget/button/border_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class BlockeduserWidget extends StatefulWidget {
  final Function() onTap;
  final int id;
  final BlockedUserModel data;

  const BlockeduserWidget({
    super.key,
    required this.onTap,
    required this.id,
    required this.data,
  });

  @override
  State<BlockeduserWidget> createState() => _BlockeduserWidgetState();
}

class _BlockeduserWidgetState extends State<BlockeduserWidget> {
  Repository repository = Repository();
  bool progress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              id: widget.data.id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(48),
                  child: CustomNetworkImage(
                    height: 54,
                    width: 54,
                    image: widget.data.avatar,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.name,
                      style: AppTypography.pSmallRegularDark33SemiBold,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          AppAssets.clock,
                          height: 14,
                          width: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.data.lastSeen,
                          textAlign: TextAlign.start,
                          style: AppTypography.pTinyGrey94.copyWith(
                            color: AppColors.grey95,
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     SvgPicture.asset(
                    //       "assets/icons/like.svg",
                    //       height: 14,
                    //       width: 14,
                    //     ),
                    //     Text(
                    //       widget.data.likes.toString(),
                    //       textAlign: TextAlign.start,
                    //       style: const TextStyle(
                    //         fontFamily: AppTypography.fontFamilyProxima,
                    //         fontStyle: FontStyle.normal,
                    //         fontWeight: FontWeight.w400,
                    //         fontSize: 13,
                    //         height: 18 / 13,
                    //         color: AppColors.grey95,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 24,
                    //     ),
                    //     SvgPicture.asset(
                    //       "assets/icons/dislike.svg",
                    //       height: 14,
                    //       width: 14,
                    //     ),
                    //     Text(
                    //       widget.data.dislikes.toString(),
                    //       textAlign: TextAlign.start,
                    //       style: const TextStyle(
                    //         fontFamily: AppTypography.fontFamilyProxima,
                    //         fontStyle: FontStyle.normal,
                    //         fontWeight: FontWeight.w400,
                    //         fontSize: 13,
                    //         height: 18 / 13,
                    //         color: AppColors.grey95,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 24,
                    //     ),
                    //     StarsWidget(
                    //       count: widget.data.stars,
                    //     ),
                    //   ],
                    // ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            BorderButton(
              onTap: () {
                CenterDialog.selectDialogBlock(context, 'unblock',
                    (value) async {
                  if (value) {
                    Navigator.pop(context);
                    progress = true;
                    setState(() {});
                    HttpResult response =
                        await Repository().blockUser(widget.id);
                    progress = false;
                    setState(() {});
                    if (response.isSuccess &&
                        response.result["success"] == true) {
                      if (mounted) {
                        blockedUsersBloc.allBlockedusers(context);
                      }
                    } else if (response.status == -1) {
                      if (mounted) {
                        CenterDialog.errorDialog(
                          context,
                          Utils.serverErrorText(response),
                          response.result.toString(),
                        );
                      }
                    } else {
                      if (mounted) {
                        CenterDialog.errorDialog(
                          context,
                          Utils.serverErrorText(response),
                          response.result.toString(),
                        );
                      }
                    }
                  }
                });
              },
              text: translate("unblock"),
              txtColor: AppColors.redAlert,
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width,
              color: AppColors.greyEB,
            )
          ],
        ),
      ),
    );
  }
}
