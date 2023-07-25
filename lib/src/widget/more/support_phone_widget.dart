import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/profile/support_number_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/utils.dart';

class SupportPhoneWidget extends StatelessWidget {
  const SupportPhoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Repository().getSupportNumber(),
      builder: (context, AsyncSnapshot<HttpResult> snapshot) {
        if (snapshot.hasData) {
          SupportNumberModel data =
              SupportNumberModel.fromJson(snapshot.data!.result);
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 75,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 8),
                  blurRadius: 32,
                  color: Color.fromRGBO(0, 0, 0, 0.08),
                ),
              ],
            ),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.success == true
                              ? data.data.supportNumber != ""
                                  ? data.data.supportNumber
                                  : Utils.supportPhoneNumber
                              : Utils.supportPhoneNumber,
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamilyProxima,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: AppColors.dark00,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          translate("more.make_call"),
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamilyProxima,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: AppColors.dark33,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _makePhoneCall(Utils.supportPhoneNumber);
                    },
                    child: SvgPicture.asset(AppAssets.phoneOutlined),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Shimmer.fromColors(
            baseColor: AppColors.shimmerBase,
            highlightColor: AppColors.shimmerHighlight,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 75,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
