import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/profile/portfolio_bloc.dart';
import 'package:youdu/src/bloc/profile/profile_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/profile/portfolio_model.dart';
import 'package:youdu/src/ui/main/more/screens/profile/portfolio/create_portfolio_screen.dart';
import 'package:youdu/src/widget/profile/portfolio_view_widget.dart';
import 'package:youdu/src/widget/shimmer/portfolio_shimmer.dart';

class PortfolioViewScreen extends StatefulWidget {
  final int id;

  const PortfolioViewScreen({super.key, required this.id});

  @override
  State<PortfolioViewScreen> createState() => _PortfolioViewScreenState();
}

class _PortfolioViewScreenState extends State<PortfolioViewScreen> {
  @override
  void initState() {
    super.initState();
    portfolioBloc.getPortfolio(widget.id, context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => profileBloc.getProfile(-1, context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 1,
          leading: GestureDetector(
            onTap: () {
              profileBloc.getProfile(-1, context);
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.transparent,
              child: SvgPicture.asset(AppAssets.back),
            ),
          ),
          title: Text(
            translate("profile.work_example"),
            style: AppTypography.pSmallRegularDark33Bold,
          ),
          actions: [
            widget.id != -1
                ? Container()
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatePortfolioScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      color: Colors.transparent,
                      child: SvgPicture.asset(AppAssets.addRing),
                    ),
                  ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: portfolioBloc.allPortfolio,
                builder: (context, AsyncSnapshot<PortfolioModel> snapshot) {
                  if (snapshot.hasData) {
                    PortfolioModel data = snapshot.data!;
                    return data.data.isNotEmpty
                        ? SingleChildScrollView(
                            child: ListView.builder(
                              itemCount: data.data.length,
                              physics: const NeverScrollableScrollPhysics(),
                              reverse: true,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return PortfolioViewWidget(
                                  id: data.data[index].id,
                                  title: data.data[index].comment,
                                  content: data.data[index].description,
                                  image: data.data[index].images,
                                  user: widget.id,
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              translate("profile.no_work"),
                            ),
                          );
                  }
                  return const PortfolioShimmer();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
