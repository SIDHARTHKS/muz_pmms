import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../helper/color_helper.dart';
import '../../helper/sizer.dart';

class StoryDetailsLoader extends StatelessWidget {
  const StoryDetailsLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(color: AppColorHelper().backgroundColor),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Platform.isAndroid ? height(60) : height(70),
              Padding(
                padding: const EdgeInsets.only(left: 45.0),
                child: _shimmerBox(120, 15, radius: 8),
              ),
              height(25),
              Row(
                children: [
                  _shimmerBox(80, 25, radius: 4),
                  width(10),
                  _shimmerBox(110, 25, radius: 4),
                ],
              ),
              height(15),
              _shimmerBox(Get.width, 10, radius: 8),
              height(10),
              _shimmerBox(Get.width / 2, 10, radius: 8),
              height(47),
              Row(
                children: [
                  _shimmerBox(55, 35, radius: 4),
                  width(30),
                  _shimmerBox(55, 35, radius: 4),
                  width(30),
                  _shimmerBox(55, 35, radius: 4),
                  width(30),
                  _shimmerBox(100, 35, radius: 4),
                ],
              ),
              height(31),
              _shimmerBox(Get.width, 47, radius: 2),
              height(30),
              Row(
                children: [
                  _shimmerBox(Get.width / 4, 35, radius: 4),
                  width(30),
                  _shimmerBox(Get.width / 4, 35, radius: 4),
                  width(30),
                  _shimmerBox(Get.width / 4, 35, radius: 4),
                ],
              ),
              height(105),
              _shimmerBox(Get.width, 300, radius: 4),

              // List shimmer
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox(double width, double height, {double radius = 6}) {
    return Shimmer.fromColors(
      baseColor: AppColorHelper().primaryColorDark.withOpacity(0.08),
      highlightColor: AppColorHelper().primaryTextColor.withOpacity(0.2),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColorHelper().cardColor.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
