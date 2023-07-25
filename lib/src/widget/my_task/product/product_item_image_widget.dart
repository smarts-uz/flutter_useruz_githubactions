import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/my_task/product/item/image_view.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';

class ProductItemImageWidget extends StatefulWidget {
  final List<String> image;

  const ProductItemImageWidget({
    super.key,
    required this.image,
  });

  @override
  State<ProductItemImageWidget> createState() => _ProductItemImageWidgetState();
}

class _ProductItemImageWidgetState extends State<ProductItemImageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 208,
      child: Stack(
        children: [
          widget.image.isEmpty
              ? SizedBox(
                  height: 208,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Center(
                      child: Image.asset(AppAssets.users),
                    ),
                  ),
                )
              : PageView.builder(
                  itemCount: widget.image.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageView(
                              data: widget.image,
                            ),
                          ),
                        );
                      },
                      child: CustomNetworkImage(
                        height: 208,
                        width: MediaQuery.of(context).size.width,
                        image: widget.image[index],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
