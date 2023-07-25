import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/support_guide_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/more/screens/support/guide_item_screen.dart';
import 'package:youdu/src/widget/more/settings/settings.dart';
import 'package:youdu/src/widget/shimmer/settings_screen_shimmer.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

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
            translate("more.guide"),
            style: AppTypography.pSmallRegularDark33Bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Repository().getFaqGuides(),
        builder: (context, AsyncSnapshot<HttpResult> snapshot) {
          if (snapshot.hasData) {
            AllSupporGuidesModel data =
                AllSupporGuidesModel.fromJson(snapshot.data!.result);
            return ListView.builder(
              itemCount: data.data.length,
              itemBuilder: (context, index) => SettingsWidget(
                title: data.data[index].title,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GuideItemScreen(
                        title: data.data[index].title,
                        id: data.data[index].id,
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const SettingsScreenShimmer();
          }
        },
      ),
    );
  }
}
