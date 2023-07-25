import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/profile/profile_model.dart';
import 'package:youdu/src/widget/more/profile/profile_widget.dart';

class SocialWidget extends StatelessWidget {
  final ProfileModel data;

  const SocialWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, top: 0, bottom: 8),
          child: Text(
            translate("profile.confirm"),
            style: AppTypography.h2SmallDark33Medium,
          ),
        ),
        data.data.phoneVerified
            ? ConfirmationWidget(
                icon: AppAssets.phone,
                title: translate("profile.phone"),
                onTap: () {},
              )
            : Container(),
        data.data.emailVerified
            ? ConfirmationWidget(
                icon: AppAssets.mail,
                title: translate("auth.form_email"),
                onTap: () {},
              )
            : Container(),
        data.data.googleId != ""
            ? ConfirmationWidget(
                icon: AppAssets.googleBlue,
                title: translate("auth.google"),
                onTap: () {},
              )
            : Container(),
        data.data.facebookId != ""
            ? ConfirmationWidget(
                icon: AppAssets.facebookBlue,
                title: translate("auth.facebook"),
                onTap: () {},
              )
            : Container(),
      ],
    );
  }
}
