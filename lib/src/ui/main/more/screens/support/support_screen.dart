import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/more/screens/support/guides_screen.dart';
import 'package:youdu/src/ui/main/search/chat/chat_item_screen.dart';
import 'package:youdu/src/widget/more/settings/settings.dart';
import 'package:youdu/src/widget/more/support_phone_widget.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  int sId = 0;
  String sName = "", sAvatar = "";

  @override
  void initState() {
    getSupport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.transparent,
            child: SvgPicture.asset(AppAssets.back),
          ),
        ),
        title: Container(
          color: Colors.transparent,
          child: Text(
            translate("more.support"),
            style: AppTypography.pSmallRegularDark33Bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsWidget(
            title: translate("more.support_chat"),
            onTap: () {
              sId == 0
                  ? null
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatItemScreen(
                          id: sId,
                          name: sName,
                          avatar: sAvatar,
                          time: "",
                        ),
                      ),
                    );
            },
            icon: AppAssets.chat,
          ),
          SettingsWidget(
            title: translate("more.guide"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GuidesScreen(),
                ),
              );
            },
            icon: AppAssets.info,
          ),
          const SizedBox(
            height: 16,
          ),
          const SupportPhoneWidget()
        ],
      ),
    );
  }

  getSupport() async {
    HttpResult response = await Repository().getSupport();

    if (response.isSuccess) {
      sId = int.parse(response.result["data"]["id"].toString());
      sName = response.result["data"]["name"];
      sAvatar = response.result["data"]["avatar"];
      setState(() {});
    }
  }
}
