import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/more/screens/profile/response_templates/update_template_screen.dart';

class TemplateWidget extends StatelessWidget {
  final int id;
  final String title;
  final String text;

  const TemplateWidget({
    super.key,
    required this.id,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.h2SmallDark00),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateTemplateScreen(
                        id: id,
                        title: title,
                        text: text,
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  child: SvgPicture.asset(AppAssets.editPort),
                ),
              ),
            ],
          ),
          Text(text, style: AppTypography.pSmall3Grey84),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
