import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/widget/app/back_widget.dart';

class ImageView extends StatefulWidget {
  final List<String> data;
  final File? file;

  const ImageView({super.key, required this.data, this.file});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark00,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        centerTitle: true,
        leading: const BackWidget(),
      ),
      body: PageView.builder(
        itemCount: widget.data.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dy > 0) {
                Navigator.of(context).pop();
              }
            },
            child: Center(
              child: widget.file != null
                  ? Image.file(
                      widget.file!,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    )
                  : CachedNetworkImage(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      imageUrl: widget.data[index],
                      fit: BoxFit.contain,
                    ),
            ),
          );
        },
      ),
    );
  }
}
