import 'package:academ_gora_release/features/main_screen/ui/screens/main_screen/widgets/local_image_widget.dart';
import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageViewWidget extends StatelessWidget {
  const ImageViewWidget(
      {Key? key, required this.imageUrl, required this.assetPath})
      : super(key: key);
  final String imageUrl;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    double? height = screenWidth * 0.4;
    double? width = screenWidth * 0.75;
    return imageUrl == "" || imageUrl.isEmpty
        ? LocalImageWidget(
            assetPath: assetPath,
          )
        : CachedNetworkImage(
            width: width,
            height: height,
            fit: BoxFit.fill,
            imageUrl: imageUrl,
            placeholder: (context, url) {
              return LocalImageWidget(
                assetPath: assetPath,
              );
            },
          );
  }
}
