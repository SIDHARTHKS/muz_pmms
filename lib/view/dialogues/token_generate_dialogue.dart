import 'package:flutter/material.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/view/widget/common_widget.dart';
import 'package:pmms/view/widget/text/app_text.dart';

class TokenGenerateDialogue extends StatelessWidget {
  final double width;
  final double height;
  final String id;

  const TokenGenerateDialogue(
      {super.key, this.width = 350, this.height = 470, required this.id});

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
              appText("Token  generated \n Successfully",
                  textAlign: TextAlign.center,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColorHelper().primaryColor,
                  height: 1.3),
              const SizedBox(height: 30),
              Image.asset(
                Assets.icons.success.path,
                scale: 3.7,
              ),
              const SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: textStyle(
                    16,
                    AppColorHelper().primaryTextColor,
                    FontWeight.w500,
                    // highlight the token
                  ),
                  children: [
                    const TextSpan(text: "Your new token "),
                    TextSpan(
                      text: "$id \n",
                      style: textStyle(
                        16,
                        AppColorHelper().primaryColor,
                        FontWeight.w600,
                        // highlight the token
                      ),
                    ),
                    const TextSpan(text: " has been generated successfully."),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
