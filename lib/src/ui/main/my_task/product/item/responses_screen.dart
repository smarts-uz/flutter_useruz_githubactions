import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/task/task_view_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/otklik_model.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/widget/app/loading_widget.dart';
import 'package:youdu/src/widget/my_task/product/response_item_widget.dart';

class ResponsesScreen extends StatefulWidget {
  final int id;
  final bool isMine;
  final int status;
  final TaskModel data;
  final bool selectedMe;

  const ResponsesScreen({
    super.key,
    required this.id,
    required this.isMine,
    required this.data,
    required this.status,
    required this.selectedMe,
  });

  @override
  State<ResponsesScreen> createState() => _ResponsesScreenState();
}

class _ResponsesScreenState extends State<ResponsesScreen> {
  int selected = 0;
  List<String> filter = ["rating", "price", "date"];
  final ScrollController _controller = ScrollController();
  int page = 1;
  bool view = true;
  bool isLoading = false;

  @override
  void initState() {
    taskViewBloc.getOtklik(widget.id, filter[selected], page, context);
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (!isLoading) {
          taskViewBloc.getOtklik(widget.id, filter[selected], page, context);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAF8F5),
      child: StreamBuilder(
        stream: taskViewBloc.otklikInfo,
        builder: (context, AsyncSnapshot<OtklikModel> snapshot) {
          if (snapshot.hasData) {
            OtklikModel data = snapshot.data!;
            if (data.meta.lastPage == page) {
              isLoading = true;
            }
            return ListView(
              padding: EdgeInsets.zero,
              controller: _controller,
              children: [
                widget.data.performer.id == 0 || !widget.isMine
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(
                            left: 16, top: 16, bottom: 16),
                        child: Text(
                          translate("my_task.selected"),
                          style: AppTypography.pSmall3Dark33H15.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                widget.data.performer.id == 0 || !widget.isMine
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ResponseItemWidget(
                            view: true,
                            data: Datum(
                              id: widget.data.performer.id,
                              user: User(
                                id: widget.data.performer.id,
                                name: widget.data.performer.name,
                                avatar: widget.data.performer.avatar,
                                phoneNumber: widget.data.performer.phoneNumber,
                                degree: widget.data.performer.degree,
                                likes: widget.data.performer.likes,
                                dislikes: widget.data.performer.dislikes,
                                stars: widget.data.performer.stars,
                                lastSeen: widget.data.performer.lastSeen,
                              ),
                              budget: widget.data.performer.price,
                              description: widget.data.performer.description,
                              createdAt: widget.data.performer.createdAt,
                              notFree: 0,
                            ),
                            taskModel: widget.data,
                            taskId: widget.id,
                            isMine: false,
                            status: widget.status,
                          ),
                        ),
                      ),
                widget.data.performer.id == 0 || !widget.isMine
                    ? Container()
                    : const SizedBox(
                        height: 28,
                      ),
                widget.data.performer.id == 0 || !widget.isMine
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              translate("my_task.others"),
                              style: AppTypography.pSmall3Dark33H15.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                view = !view;
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                color: Colors.transparent,
                                child: Text(
                                  view
                                      ? translate("my_task.hide")
                                      : translate("my_task.show"),
                                  style: const TextStyle(
                                    fontFamily: AppTypography.fontFamilyProxima,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    height: 1.5,
                                    color: AppColors.yellow00,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                !view
                    ? Container()
                    : Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(
                          widget.selectedMe
                              ? translate("my_task.selected_me")
                              : "${translate("my_task.job")} ${widget.data.responsesCount} ${translate("my_task.feedback")}",
                          style: AppTypography.pSmall3Dark33H15.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                view && widget.selectedMe
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ResponseItemWidget(
                            view: false,
                            data: Datum(
                              id: widget.data.performer.id,
                              user: User(
                                id: widget.data.performer.id,
                                name: widget.data.performer.name,
                                avatar: widget.data.performer.avatar,
                                phoneNumber: widget.data.performer.phoneNumber,
                                degree: widget.data.performer.degree,
                                likes: widget.data.performer.likes,
                                dislikes: widget.data.performer.dislikes,
                                stars: widget.data.performer.stars,
                                lastSeen: widget.data.performer.lastSeen,
                              ),
                              budget: widget.data.performer.price,
                              description: widget.data.performer.description,
                              createdAt: widget.data.performer.createdAt,
                              notFree: 0,
                            ),
                            taskModel: widget.data,
                            taskId: widget.id,
                            isMine: false,
                            status: widget.status,
                          ),
                        ),
                      )
                    : const SizedBox(),
                !view || !widget.data.isMine
                    ? Container()
                    : Padding(
                        padding:
                            const EdgeInsets.only(top: 8, left: 16, right: 16),
                        child: Text(
                          translate("my_task.sort"),
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamilyProxima,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.3,
                            color: AppColors.dark33,
                          ),
                        ),
                      ),
                !view || !widget.data.isMine
                    ? Container()
                    : SizedBox(
                        height: 58,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
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
                                page = 1;
                                setState(() {});
                                taskViewBloc.getOtklik(
                                    widget.id, filter[selected], page, context);
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
                                        ? translate("my_task.sorted.one")
                                        : index == 1
                                            ? translate("my_task.sorted.two")
                                            : translate("my_task.sorted.three"),
                                    style: TextStyle(
                                      fontFamily:
                                          AppTypography.fontFamilyProxima,
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
                !view
                    ? Container()
                    : Container(
                        color: Colors.transparent,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index == data.data.length) {
                              return LoadingWidget(
                                key: Key(isLoading.toString()),
                                isLoading: isLoading,
                              );
                            }
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ResponseItemWidget(
                                view: false,
                                data: data.data[index],
                                status: widget.status,
                                taskId: widget.data.performer.id == 0
                                    ? widget.id
                                    : 0,
                                isMine: widget.data.performer.id == 0
                                    ? widget.isMine
                                    : false,
                                taskModel: widget.data,
                              ),
                            );
                          },
                          itemCount: data.data.length,
                        ),
                      ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.yellow79,
              ),
            );
          }
        },
      ),
    );
  }
}
