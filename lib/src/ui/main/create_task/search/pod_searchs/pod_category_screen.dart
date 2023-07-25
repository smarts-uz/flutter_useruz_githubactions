import 'package:flutter/material.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/bloc/guest/category/category_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/ui/main/create_task/create/create_main_screen.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/create_task/tasks/search_task_widget.dart';

class PodCategoryScreen extends StatefulWidget {
  final String name;
  final int id;
  final bool myTask;

  const PodCategoryScreen({
    super.key,
    required this.name,
    required this.id,
    required this.myTask,
  });

  @override
  State<PodCategoryScreen> createState() => _PodCategoryScreenState();
}

class _PodCategoryScreenState extends State<PodCategoryScreen> {
  @override
  void initState() {
    categoryBloc.allSubCategory(widget.id, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        title: Text(
          widget.name,
          style: AppTypography.pSmallRegularDark33.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            color: AppColors.greyE9,
          ),
          Expanded(
            child: StreamBuilder<List<CategoryModel>>(
              stream: categoryBloc.getSubCategory,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      return SearchTaskWidget(
                        text: snapshot.data![index].name,
                        onTap: () {
                          createBloc.saveCategory(snapshot.data![index]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateMainScreen(
                                categoryId: snapshot.data![index].id,
                                categoryName: snapshot.data![index].name,
                                myTask: widget.myTask,
                                name: snapshot.data![index].name,
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
            ),
          ),
        ],
      ),
    );
  }
}
