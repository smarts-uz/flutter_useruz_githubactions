// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';

import '../bloc/guest/performers/performers_bloc.dart';
import '../utils/utils.dart';
import 'dialog/center_dialog.dart';

class ReportScreen extends StatefulWidget {
  final int id;

  const ReportScreen({
    super.key,
    required this.id,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController controller = TextEditingController();
  bool empty = true, loading = false;

  @override
  void initState() {
    controller.addListener(() {
      if (controller.text.isNotEmpty) {
        empty = false;
        setState(() {});
      } else {
        empty = true;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const Spacer(),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: translate("message"),
            ),
          ),
          const SizedBox(
            height: 42,
          ),
          GestureDetector(
            onTap: () async {
              if (!empty) {
                loading = true;
                setState(() {});
                HttpResult response =
                    await Repository().reportUser(widget.id, controller.text);
                loading = false;
                setState(() {});
                if (response.isSuccess && response.result["success"] == true) {
                  performersBloc.allPerformers(false, 1, context);

                  Navigator.popUntil(context, (route) => route.isFirst);
                } else if (response.status == -1) {
                  CenterDialog.errorDialog(
                    context,
                    Utils.serverErrorText(response),
                    response.result.toString(),
                  );
                } else {
                  CenterDialog.errorDialog(
                    context,
                    Utils.serverErrorText(response),
                    response.result.toString(),
                  );
                }
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: empty
                    ? AppColors.dark00.withOpacity(0.1)
                    : AppColors.blue32,
              ),
              child: Center(
                child: loading
                    ? const CircularProgressIndicator.adaptive(
                        backgroundColor: AppColors.white,
                      )
                    : Text(
                        translate("jaloba"),
                        style: AppTypography.pSmallRegularWhite,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
