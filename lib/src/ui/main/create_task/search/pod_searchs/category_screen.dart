import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/guest/category/category_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/ui/main/create_task/search/pod_searchs/pod_category_screen.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/home/category_item_widget.dart';

class CategoryScreen extends StatefulWidget {
  final bool myTask;

  const CategoryScreen({super.key, this.myTask = false});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    categoryBloc.allCategory(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackWidget(),
        title: Text(
          translate("create_task.category"),
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
              stream: categoryBloc.getAllCategory,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<CategoryModel> data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, index) {
                      return Column(
                        children: [
                          CategoryItemWidget(
                            iconSize: 40,
                            image: data[index].ico,
                            title: data[index].name,
                            message: "",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PodCategoryScreen(
                                      name: data[index].name,
                                      id: data[index].id,
                                      myTask: widget.myTask,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          index == data.length - 1
                              ? Container()
                              : Container(
                                  height: 1,
                                  margin: const EdgeInsets.only(left: 56),
                                  width: MediaQuery.of(context).size.width,
                                  color: const Color(0xFFEFEDE9),
                                ),
                        ],
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
