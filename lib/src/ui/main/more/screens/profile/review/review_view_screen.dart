import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/app_colors.dart';
import 'package:youdu/src/ui/main/more/screens/profile/review/view_screen.dart';
import 'package:youdu/src/widget/app/app_bar_title.dart';
import 'package:youdu/src/widget/app/back_widget.dart';

class ReviewViewScreen extends StatefulWidget {
  final int id;

  const ReviewViewScreen({super.key, required this.id});

  @override
  State<ReviewViewScreen> createState() => _ReviewViewScreenState();
}

class _ReviewViewScreenState extends State<ReviewViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          leading: const BackWidget(),
          title: AppBarTitle(
            text: translate("profile.review"),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              labelColor: AppColors.yellow00,
              unselectedLabelColor: AppColors.greyBF,
              indicatorColor: AppColors.yellow00,
              tabs: [
                Tab(
                  text: translate("profile.from_customers"),
                ),
                Tab(
                  text: translate("profile.from_performer"),
                ),
              ],
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: AppColors.dark00.withOpacity(0.1),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ViewScreen(
                    id: 0,
                    userId: widget.id,
                  ),
                  ViewScreen(
                    id: 1,
                    userId: widget.id,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
