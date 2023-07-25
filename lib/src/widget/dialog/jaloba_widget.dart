import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/status_model.dart';

class JalobaWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String text) onTap;
  final Function(int id) onTapId;
  final StatusModel statusModel;

  const JalobaWidget({
    super.key,
    required this.controller,
    required this.onTap,
    required this.statusModel,
    required this.onTapId,
  });

  @override
  State<JalobaWidget> createState() => _JalobaWidgetState();
}

class _JalobaWidgetState extends State<JalobaWidget> {
  Status? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.statusModel.data[0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: TextField(
              controller: widget.controller,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: const InputDecoration(),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<List<Status>>(
                      dropdownColor: Colors.white,
                      style: AppTypography.pSmallBlack,
                      hint: Text(
                        selectedValue!.name,
                        style: AppTypography.pSmallBlack,
                      ),
                      isExpanded: true,
                      isDense: true,
                      onChanged: (List<Status>? newValue) {},
                      items: widget.statusModel.data
                          .map<DropdownMenuItem<List<Status>>>(
                        (Status valueItem) {
                          return DropdownMenuItem(
                            onTap: () {
                              selectedValue = valueItem;
                              setState(() {});
                            },
                            value: widget.statusModel.data,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  valueItem.name,
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 56,
          ),
          GestureDetector(
            onTap: () {
              widget.onTap(widget.controller.text);
              widget.onTapId(selectedValue!.id);
              Navigator.pop(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.blue32,
              ),
              child: Center(
                child: Text(
                  translate("complain"),
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
