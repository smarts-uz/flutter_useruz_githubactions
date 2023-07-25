// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';

class SelectWidget extends StatefulWidget {
  final List<CustomFieldType> options;
  final Function(String _options) choose;

  const SelectWidget({super.key, required this.options, required this.choose});

  @override
  State<SelectWidget> createState() => _SelectWidgetState();
}

class _SelectWidgetState extends State<SelectWidget> {
  String chooseData = "";
  int selectedIndex = 0;

  @override
  void initState() {
    for (int i = 0; i < widget.options.length; i++) {
      if (widget.options[i].selected) {
        chooseData = widget.options[i].value;
      } else {
        chooseData = widget.options[0].value;
      }
    }
    widget.choose(chooseData);
    setState(() {});
    super.initState();
  }

  void showBottomSheet(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext ctx) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(left: 3),
          title: Text(chooseData, style: AppTypography.pTiny2Dark00),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          onTap: () => showBottomSheet(
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                      child: Text(
                        translate('cancel'),
                        style: const TextStyle(
                          fontFamily: AppTypography.fontFamilyProxima,
                          color: AppColors.grey85,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        setState(() {
                          chooseData = widget.options[selectedIndex].value;
                          widget.choose(chooseData);
                        });
                        Navigator.of(context).pop();
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                      child: Text(
                        translate('confirm'),
                        style: const TextStyle(
                          fontFamily: AppTypography.fontFamilyProxima,
                          color: AppColors.blueE6,
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 35,
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int index) {
                      selectedIndex = index;
                    },
                    children: List<Widget>.generate(widget.options.length,
                        (int index) {
                      return Center(
                        child: Text(
                          widget.options[index].value,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: AppColors.greyAD,
          thickness: 1,
        )
      ],
    );
  }
}
