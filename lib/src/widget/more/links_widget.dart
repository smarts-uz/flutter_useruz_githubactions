import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youdu/src/constants/constants.dart';

class LinksWidget extends StatelessWidget {
  const LinksWidget({super.key, required this.icon, required this.link});
  final String icon;
  final String link;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchUrl(link),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: AppColors.yellow16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.greyB3,
              blurRadius: 15,
              offset: Offset(1.0, 2.0),
            )
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            color: AppColors.yellow16,
            width: 30,
            height: 30,
          ),
        ),
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
