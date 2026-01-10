import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/create_story_controller.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/createStory/bottomsheet/generate_story_bottomsheet.dart';
import 'package:pmms/view/dialogues/success_dialogue.dart';
import '../widget/common_widget.dart';

class CreateStoryScreen extends AppBaseView<CreateStoryController> {
  const CreateStoryScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(canpop: true, body: _body()
      // appFutureBuilder<void>(
      //   () => controller.fetchInitData(), (context, snapshot) => _body(),
      //   // loaderWidget: fullScreenloader()
      // ),
      );
  GestureDetector _body() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: appScaffold(
        resizeToAvoidBottomInset: true,
        appBar: customAppBar(addNewStory.tr),
        body: appContainer(
          enableSafeArea: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Obx(() {
              final progress = (controller.rxCurrentPageIndex.value + 1) /
                  controller.pageList.length;

              return Column(
                children: [
                  height(20),
                  _progressBar(progress),
                  height(10),
                  Expanded(
                      child: controller
                          .pageList[controller.rxCurrentPageIndex.value]),
                  _navButtons(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Padding _navButtons() {
    bool showBack = controller.rxCurrentPageIndex.value > 0;
    bool isLast =
        controller.rxCurrentPageIndex.value == controller.pageList.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            showBack
                ? buttonContainer(
                    borderColor:
                        AppColorHelper().borderColor.withValues(alpha: 0.4),
                    color: AppColorHelper().cardColor.withValues(alpha: 0.9),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.asset(
                        Assets.icons.back.path,
                        scale: 3.5,
                      ),
                    ), onPressed: () {
                    controller.nextPage(false);
                  })
                : width(0),
            Row(
              children: [
                isLast
                    ? buttonContainer(
                        width: 130,
                        color: AppColorHelper().primaryColor,
                        appText(createstory.tr,
                            color: AppColorHelper().textColor,
                            fontWeight: FontWeight.w500), onPressed: () async {
                        if (controller.requiredDataSelected()) {
                          await controller
                              .callGenerateStory()
                              .then((success) async {
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
                              controller.rxCurrentPageIndex(0);
                              navigateToAndRemove(homePageRoute);
                            }
                          });
                        }
                      })
                    : Row(
                        children: [
                          buttonContainer(
                              borderColor: AppColorHelper().primaryColor,
                              color: AppColorHelper()
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                              appText(createstory.tr,
                                  color: AppColorHelper().secondaryTextColor,
                                  fontWeight: FontWeight.w500),
                              onPressed: () async {
                            if (controller.requiredDataSelected()) {
                              await showModalBottomSheet(
                                  context: Get.context!,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) =>
                                      GenerateStoryBottomsheet());
                            }
                          }),
                          width(15),
                          buttonContainer(
                              width: 90,
                              color: AppColorHelper().primaryColor,
                              appText(next.tr,
                                  color: AppColorHelper().textColor,
                                  fontWeight: FontWeight.w500), onPressed: () {
                            if (controller.requiredDataSelected()) {
                              controller.nextPage(true);
                            }
                          }),
                        ],
                      )
              ],
            )
          ],
        ),
      ),
    );
  }

  Row _progressBar(double progress) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Background bar
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: AppColorHelper().borderColor,
                ),
              ),

              // Animated progress bar
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                widthFactor: progress, // 0.33, 0.66, or 1.0
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColorHelper().primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        width(8),
        appText(
            "${controller.rxCurrentPageIndex.value + 1}/${controller.pageList.length}",
            color: AppColorHelper().primaryTextColor,
            fontSize: 15,
            fontWeight: FontWeight.w600)
      ],
    );
  }
}
