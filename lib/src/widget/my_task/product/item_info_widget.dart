// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';

class ItemInfoWidget extends StatelessWidget {
  final String description;
  final List<CreateRouteCustomField> data;

  const ItemInfoWidget({
    super.key,
    required this.description,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          translate("my_task.info"),
          style: AppTypography.pTinyGreyAD,
        ),
        Linkify(
          onOpen: (link) async {
            try {
              await launchUrl(Uri.parse(link.url));
            } catch (_) {}
          },
          text: description,
          style: const TextStyle(
            fontFamily: AppTypography.fontFamilyProxima,
            fontWeight: FontWeight.w400,
            fontSize: 15,
            height: 1.4,
            color: AppColors.dark33,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          translate("my_task.options"),
          style: AppTypography.pTinyGreyAD,
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < data.length; i++)
          data[i].type == "checkbox"
              ? checkbox(data[i].options, data[i].label)
              : data[i].type == "input" && data[i].dataType == "int"
                  ? dottedField(data[i].label, data[i].taskValue)
                  : data[i].type == "input" && data[i].taskValue != ""
                      ? customField(context, data[i].label, data[i].taskValue)
                      : options(data[i].options, data[i].label),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget dottedField(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2, top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: AppTypography.fontFamilyProxima,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              // height: 1.6,
              color: AppColors.dark33.withOpacity(0.8),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          const Expanded(
            child: DottedDashedLine(
              height: 0,
              axis: Axis.horizontal,
              dashHeight: 6,
              dashWidth: 2,
              width: 1000,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            description,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: AppTypography.fontFamilyProxima,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              // height: 1.5,
              color: AppColors.dark33,
            ),
          ),
        ],
      ),
    );
  }

  Widget customField(BuildContext context, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title + ":",
            style: TextStyle(
              fontFamily: AppTypography.fontFamilyProxima,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.6,
              color: AppColors.dark33.withOpacity(0.8),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Container(
            margin: const EdgeInsets.only(left: 0),
            child: Text(
              description,
              textAlign: TextAlign.right,
              style: AppTypography.pDark33SemiBoldPro,
            ),
          ),
        ],
      ),
    );
  }

  Widget options(List<CustomFieldType> type, String name) {
    return ListView.builder(
      itemCount: type.length,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return type[index].selected && type[index].value != ""
            ? customField(context, name, type[index].value)
            : Container();
      },
    );
  }

  Widget checkbox(List<CustomFieldType> type, String name) {
    return ListView.builder(
      itemCount: type.length,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(bottom: type[index].selected ? 16 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index == 0
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child:
                          Text(name, style: AppTypography.pDark33SemiBoldPro),
                    )
                  : Container(),
              !type[index].selected && type[index].value != ""
                  ? Container()
                  : Row(
                      children: [
                        const Icon(
                          Icons.check,
                          color: AppColors.yellow00,
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: Text(
                            type[index].value,
                            style: const TextStyle(
                              fontFamily: AppTypography.fontFamilyProxima,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              height: 1.5,
                              color: AppColors.dark33,
                            ),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        );
      },
    );
  }
}
