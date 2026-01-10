import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../helper/color_helper.dart';
import '../../helper/sizer.dart';

class TaskLoader extends StatelessWidget {
  const TaskLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = Get.width;

    return SizedBox(
      width: Get.width,
      height: Get.height,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.images.gradientbg2.path),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: Column(
            children: [
              Platform.isAndroid ? height(60) : height(70),
              _shimmerBox(100, 12, radius: 8),
              height(25),
              // List shimmer
              Column(
                children: List.generate(
                  11,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: _holidayCardShimmer(width),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _holidayCardShimmer(double width) {
    return Shimmer.fromColors(
      baseColor: AppColorHelper().primaryTextColor.withOpacity(0.08),
      highlightColor: AppColorHelper().primaryTextColor.withOpacity(0.2),
      period: const Duration(milliseconds: 1200),
      child: Container(
        height: 78,
        width: width,
        decoration: BoxDecoration(
          color: AppColorHelper().cardColor.withOpacity(0.4),
          border: Border.all(
            color: AppColorHelper().borderColor.withOpacity(0.2),
            width: 0.8,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            // Left side shimmer for date (e.g., 25th DEC)
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _shimmerBox(width, 40, radius: 4),
                ],
              ),
            ),
            // Divider
            Container(
              width: 0.6,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: AppColorHelper().primaryTextColor.withOpacity(0.2),
            ),
            // Right side shimmer for name + weekday
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(width * 0.2, 14, radius: 14),
                  height(8),
                  _shimmerBox(width * 0.35, 10, radius: 10),
                ],
              ),
            ),
          ],
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
