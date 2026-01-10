import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/create_story_controller.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/common_widget.dart';

import '../../../helper/navigation.dart';
import '../../../helper/route.dart';
import '../../dialogues/success_dialogue.dart';

class GenerateStoryBottomsheet extends StatelessWidget {
  final bool isCreate;
  final CreateStoryController _storyController =
      Get.find<CreateStoryController>();
  GenerateStoryBottomsheet({this.isCreate = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(
          top: 40.0, bottom: 40.0, left: 25.0, right: 25.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // makes sheet height wrap content
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColorHelper().primaryColor),
                child: iconWidget(Icons.close,
                    color: AppColorHelper().textColor, onPressed: goBack),
              ),
            ],
          ),
          height(25),
          Image.asset(
            Assets.images.generateToken.path,
            scale: 3.7,
          ),
          height(40),
          appText(isCreate ? generateStoryNow.tr : updateStoryNow.tr,
              height: 1.2,
              textAlign: TextAlign.center,
              color: AppColorHelper().primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.w800),
          height(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: appText(
                textAlign: TextAlign.center,
                generateTokenNowDialogue.tr,
                color: AppColorHelper().primaryTextColor,
                fontSize: 13,
                height: 1.6,
                fontWeight: FontWeight.w500),
          ),
          height(30),
          buttonContainer(onPressed: () async {
            if (_storyController.requiredDataSelected()) {
              await _storyController.callGenerateStory().then((success) async {
                if (success) {
                  await showDialog(
                    context: Get.context!,
                    barrierDismissible: true,
                    builder: (_) => const SuccessDialogue(
                      title: "Story Created Successfully",
                      subtitle1: "Your new story ",
                      subtitle2: "TKN -782-12 ",
                      subtitle3: "has been created successfully",
                    ),
                  );
                  _storyController.rxCurrentPageIndex(0);
                  navigateToAndRemove(homePageRoute);
                }
              });
            }
          },
              color: AppColorHelper().primaryColor,
              appText(isCreate ? createstory.tr : updatestory.tr,
                  color: AppColorHelper().textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          height(12),
          buttonContainer(
              onPressed: goBack,
              color: AppColorHelper().cardColor,
              borderColor: AppColorHelper().borderColor.withValues(alpha: 0.3),
              appText(fillRemainingFields.tr,
                  color: AppColorHelper().primaryTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500))
        ],
      ),
    );
  }
}
