import 'package:flutter/material.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/model/api/create/popular_category_model.dart';
import 'package:youdu/src/ui/main/create_task/create/create_main_screen.dart';
import 'package:youdu/src/widget/create_task/tasks/search_task_widget.dart';

class TabScreens extends StatefulWidget {
  const TabScreens({super.key});

  @override
  State<TabScreens> createState() => _TabScreensState();
}

class _TabScreensState extends State<TabScreens>
    with AutomaticKeepAliveClientMixin<TabScreens> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    createBloc.allPopularCategory("");
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return StreamBuilder<List<PopularCategoryModel>>(
      stream: createBloc.getPopularCategory,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PopularCategoryModel> data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              return SearchTaskWidget(
                text: data[index].category.name,
                onTap: () {
                  createBloc.saveCategory(data[index].category);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateMainScreen(
                        categoryId: data[index].categoryId,
                        categoryName: data[index].category.name,
                        name: data[index].category.name,
                      ),
                    ),
                  );
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
