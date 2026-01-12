import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../helper/color_helper.dart';
import '../../helper/sizer.dart';

class TlTokenDetailLoader extends StatelessWidget {
  const TlTokenDetailLoader({super.key});

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
              Row(
                children: [
                  width(38),
                  _shimmerBox(90, 15, radius: 8),
                  width(5),
                  _shimmerBox(80, 25, radius: 4),
                ],
              ),
              height(25),
              Row(
                children: [
                  _shimmerBox(40, 40, radius: 100),
                  width(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(170, 10, radius: 4),
                      height(10),
                      _shimmerBox(70, 10, radius: 4),
                    ],
                  ),
                ],
              ),
              height(15),
              _shimmerBox(Get.width, 200, radius: 4),
              height(25),
              _shimmerBox(Get.width / 3, 10, radius: 8),
              height(25),
              _shimmerBox(Get.width, 350, radius: 4),
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
