import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/support_guide_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/widget/shimmer/news_shimmer.dart';

class GuideItemScreen extends StatelessWidget {
  const GuideItemScreen({
    super.key,
    required this.title,
    required this.id,
  });
  final String title;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
            title,
            style: AppTypography.pSmallRegularDark33Bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Repository().getFaqGuideById(id),
        builder: (context, AsyncSnapshot<HttpResult> snapshot) {
          if (snapshot.hasData) {
            GuideItemModel guide =
                GuideItemModel.fromJson(snapshot.data!.result['data']);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      guide.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamilyProxima,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark00,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: guide.logo,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: 270,
                        placeholder: (context, url) => const SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.greyD6,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      guide.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamilyProxima,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.dark00,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const NewsShimmer();
          }
        },
      ),
    );
  }
}
