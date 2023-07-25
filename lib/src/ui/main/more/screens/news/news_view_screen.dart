import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youdu/src/bloc/profile/news_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/news_detail_model.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';

class NewsViewScreen extends StatefulWidget {
  final int id;

  const NewsViewScreen({super.key, required this.id});

  @override
  State<NewsViewScreen> createState() => _NewsViewScreenState();
}

class _NewsViewScreenState extends State<NewsViewScreen> {
  @override
  void initState() {
    newsBloc.getNewDetail(widget.id, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppColors.white,
      body: StreamBuilder<NewsDetailModel>(
        stream: newsBloc.newsDetail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NewsDetailModel data = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CustomNetworkImage(
                          image: data.data.img,
                          height: 400,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.only(left: 16, top: 44),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: SvgPicture.asset(AppAssets.back),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            await Share.share("${Utils.newsLink}${widget.id}");
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 16, top: 44),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: SvgPicture.asset(AppAssets.share),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        child: Container(
                          height: 1500,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 300),
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: AppColors.white,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        data.data.title,
                                        style:
                                            AppTypography.h2SmallDark33Medium,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        data.data.text,
                                        style: AppTypography.pTiny215,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: AppColors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.yellow00,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
