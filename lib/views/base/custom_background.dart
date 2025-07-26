import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_images.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;
  const CustomBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(AppImages.bgImg), fit: BoxFit.cover)
      ),
      child: child,
    );
  }
}
