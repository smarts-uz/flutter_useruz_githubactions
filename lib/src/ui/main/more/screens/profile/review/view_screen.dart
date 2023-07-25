import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/profile/review_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/profile/review_model.dart';
import 'package:youdu/src/widget/profile/review_view_widget.dart';
import 'package:youdu/src/widget/shimmer/all_performers_shimmer.dart';

class ViewScreen extends StatefulWidget {
  final int id;
  final int userId;

  const ViewScreen({
    Key? key,
    required this.id,
    required this.userId,
  }) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  int selected = 0;
  List<String> review = ["", "good", "bad"];

  @override
  void initState() {
    super.initState();
    reviewBloc.getAllReview(
        widget.id, widget.userId, review[selected], context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 58,
          child: ListView.builder(
            padding: const EdgeInsets.only(
              top: 8,
              left: 16,
              right: 8,
              bottom: 24,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  selected = index;
                  reviewBloc.getAllReview(
                      widget.id, widget.userId, review[selected], context);
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: index == selected
                        ? AppColors.blue91
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    border: index == selected
                        ? null
                        : Border.all(color: AppColors.greyE9),
                  ),
                  child: Center(
                    child: Text(
                      index == 0
                          ? translate("profile.show_all")
                          : index == 1
                              ? translate("profile.positive")
                              : translate("profile.negative"),
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamilyProxima,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: index == selected
                            ? AppColors.white
                            : AppColors.blue91,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: reviewBloc.allReview,
            builder: (context, AsyncSnapshot<ReviewModel> snapshot) {
              if (snapshot.hasData) {
                ReviewModel data = snapshot.data!;
                return data.data.isNotEmpty
                    ? ListView.builder(
                        itemCount: data.data.length,
                        itemBuilder: (_, index) {
                          return ReviewViewWidget(
                            data: data.data[index],
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          translate("profile.no_review"),
                        ),
                      );
              }
              return const AllPerformersShimmer();
            },
          ),
        ),
      ],
    );
  }
}
