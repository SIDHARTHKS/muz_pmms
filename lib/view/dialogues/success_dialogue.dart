import 'package:flutter/material.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/view/widget/common_widget.dart';

class SuccessDialogue extends StatelessWidget {
  final double width;
  final double height;

  const SuccessDialogue({
    super.key,
    this.width = 350,
    this.height = 470,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColorHelper().cardColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              appText(
                "Approved \n Successfully",
                textAlign: TextAlign.center,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColorHelper().primaryColor,
              ),
              const SizedBox(height: 30),
              Image.asset(
                Assets.icons.success.path,
                scale: 2.5,
              ),
              const SizedBox(height: 30),
              appText(
                "This token request has been  \n approved successfully.",
                textAlign: TextAlign.center,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColorHelper().primaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
