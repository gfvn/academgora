import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';

class LocalImageWidget extends StatelessWidget {
  const LocalImageWidget({Key? key, required this.assetPath}) : super(key: key);
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    double? height = screenWidth * 0.5;
    double? width = screenWidth * 0.8;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(assetPath), fit: BoxFit.fill),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
