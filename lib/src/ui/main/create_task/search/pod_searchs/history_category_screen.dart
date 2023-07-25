import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/constants/app_colors.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/ui/main/create_task/create/create_main_screen.dart';
import 'package:youdu/src/widget/create_task/tasks/search_task_widget.dart';

class HistoryCategoryScreen extends StatefulWidget {
  const HistoryCategoryScreen({super.key});

  @override
  State<HistoryCategoryScreen> createState() => _HistoryCategoryScreenState();
}

class _HistoryCategoryScreenState extends State<HistoryCategoryScreen>
    with AutomaticKeepAliveClientMixin<HistoryCategoryScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    createBloc.allData("");
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return StreamBuilder<List<CategoryModel>>(
      stream: createBloc.getHistory,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CategoryModel> data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              return FutureBuilder<String>(
                future: createBloc.getCategoryName(data[index].id),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return SearchTaskWidget(
                      text: snapshot.data!,
                      onTap: () {
                        createBloc.saveCategory(data[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateMainScreen(
                              categoryId: data[index].id,
                              categoryName: snapshot.data!,
                              name: snapshot.data!,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Shimmer.fromColors(
                      baseColor: AppColors.shimmerBase,
                      highlightColor: AppColors.shimmerHighlight,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    );
                  }
                },
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
