import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/profile/news_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/profile/news_model.dart';
import 'package:youdu/src/ui/main/more/screens/news/news_view_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/more/news_widget.dart';
import 'package:youdu/src/widget/shimmer/news_shimmer.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    newsBloc.getAllNews(context);
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
            color: Colors.transparent,
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(AppAssets.back),
          ),
        ),
        title: Text(
          translate("profile.news"),
          style: AppTypography.pSmallRegularDark33.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: newsBloc.allNews,
        builder: (context, AsyncSnapshot<NewsModel> snapshot) {
          if (snapshot.hasData) {
            NewsModel data = snapshot.data!;

            return ListView.builder(
              itemCount: data.data.length,
              itemBuilder: (_, index) {
                return NewsWidget(
                  img: data.data[index].img,
                  title: data.data[index].title,
                  content: data.data[index].text,
                  date: Utils.dateNameFormatCreateDate(
                      data.data[index].createdAt),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsViewScreen(
                          id: data.data[index].id,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const NewsShimmer();
        },
      ),
    );
  }
}
