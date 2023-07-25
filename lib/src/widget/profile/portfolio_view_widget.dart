import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/more/screens/profile/portfolio/update_screen.dart';
import 'package:youdu/src/ui/main/my_task/product/item/image_view.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';

class PortfolioViewWidget extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final List<String> image;
  final int user;

  const PortfolioViewWidget({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.user,
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
              Text(title, style: AppTypography.h2SmallDark00Medium),
              user != -1
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdatePortfolioScreen(
                              id: id,
                              title: title,
                              content: content,
                              image: image,
                              user: user,
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
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTypography.pSmall3Dark00,
          ),
          const SizedBox(height: 16),
          image.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageView(
                            data: image,
                          ),
                        ),
                      );
                    },
                    child: CustomNetworkImage(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      image: image[0],
                    ),
                  ),
                )
              : Container(),
          const SizedBox(
            height: 16,
          ),
          image.length > 1
              ? SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: image.length - 1,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageView(
                                data: image,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomNetworkImage(
                              height: 100,
                              width: 100,
                              image: image[index + 1],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
