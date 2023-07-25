import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/profile/template_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/profile/template_model.dart';
import 'package:youdu/src/widget/profile/template_widget.dart';
import 'package:youdu/src/widget/shimmer/portfolio_shimmer.dart';

class UseTemplatesScreen extends StatefulWidget {
  final Function(String text)? onTapped;
  const UseTemplatesScreen({this.onTapped, super.key});

  @override
  State<UseTemplatesScreen> createState() => _UseTemplatesScreenState();
}

class _UseTemplatesScreenState extends State<UseTemplatesScreen> {
  @override
  void initState() {
    super.initState();
    templateBloc.getTemplates(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.transparent,
            child: SvgPicture.asset(AppAssets.back),
          ),
        ),
        title: Text(
          translate("profile.response_template"),
          style: AppTypography.pSmallRegularDark33Bold,
        ),
        actions: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: templateBloc.allTemplate,
              builder: (context, AsyncSnapshot<TemplateModel> snapshot) {
                if (snapshot.hasData) {
                  TemplateModel data = snapshot.data!;
                  return data.data.isNotEmpty
                      ? ListView.builder(
                          itemCount: data.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: widget.onTapped != null
                                  ? () {
                                      widget.onTapped!(data.data[index].text);
                                      Navigator.of(context).pop();
                                    }
                                  : () {},
                              child: TemplateWidget(
                                id: data.data[index].id,
                                title: data.data[index].title,
                                text: data.data[index].text,
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            translate("profile.no_templates"),
                          ),
                        );
                }
                return const PortfolioShimmer();
              },
            ),
          ),
        ],
      ),
    );
  }
}
