import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pmms/controller/edit_story_controller.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/createStory/bottomsheet/generate_story_bottomsheet.dart';
import 'package:pmms/view/dialogues/success_dialogue.dart';
import 'package:pmms/view/widget/common_widget.dart';

class EditStoryScreen extends AppBaseView<EditStoryController> {
  const EditStoryScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(
        canpop: true,
        body: appFutureBuilder<void>(
            () => controller.fetchInitData(), (context, snapshot) => _body(),
            loaderWidget: fullScreenloader()),
      );
  GestureDetector _body() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: appScaffold(
        resizeToAvoidBottomInset: true,
        appBar: customAppBar(
            "TKN-${controller.rxCurrentStoryDetail.value?.tokenId ?? "-"}"),
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
                          .editPageList[controller.rxCurrentPageIndex.value]),
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
                        color: AppColorHelper().primaryColor,
                        appText(update.tr,
                            color: AppColorHelper().textColor,
                            fontWeight: FontWeight.w500), onPressed: () async {
                        await controller.callEditStory().then(
                          (success) async {
                            if (success) {
                              await showDialog(
                                context: Get.context!,
                                barrierDismissible: true,
                                builder: (_) => SuccessDialogue(
                                  title: "Story Updated Successfully",
                                  subtitle1: "Your story",
                                  subtitle2:
                                      "TKN-${controller.rxCurrentStoryDetail.value?.tokenId ?? "-"}",
                                  subtitle3: "has been updated successfully",
                                ),
                              );
                              // await controller.tasksController
                              //     .refreshTasks(false);
                              await controller.storyDetailsController
                                  .fetchStoryAfterReuturn(
                                      controller.rxCurrentStoryDetail.value!,
                                      false);
                              goBack();
                            }
                          },
                        );
                      })
                    : Row(
                        children: [
                          buttonContainer(
                              borderColor: AppColorHelper().primaryColor,
                              color: AppColorHelper()
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                              appText(update.tr,
                                  color: AppColorHelper().secondaryTextColor,
                                  fontWeight: FontWeight.w500),
                              onPressed: () async {
                            await showModalBottomSheet(
                                context: Get.context!,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => GenerateStoryBottomsheet(
                                      onConfirm: () async {
                                        controller.callEditStory().then(
                                          (success) async {
                                            if (success) {
                                              await showDialog(
                                                context: Get.context!,
                                                barrierDismissible: true,
                                                builder: (_) => SuccessDialogue(
                                                  title:
                                                      "Story Updated Successfully",
                                                  subtitle1: "Your story",
                                                  subtitle2:
                                                      "TKN-${controller.rxCurrentStoryDetail.value?.tokenId ?? "-"}",
                                                  subtitle3:
                                                      "has been updated successfully",
                                                ),
                                              );
                                              // await controller.tasksController
                                              //     .refreshTasks(false);
                                              await controller
                                                  .storyDetailsController
                                                  .fetchStoryAfterReuturn(
                                                      controller
                                                          .rxCurrentStoryDetail
                                                          .value!,
                                                      false);

                                              goBack();
                                            }
                                            goBack();
                                          },
                                        );
                                      },
                                      isCreate: false,
                                    ));
                          }),
                          width(15),
                          buttonContainer(
                              width: 90,
                              color: AppColorHelper().primaryColor,
                              appText(next.tr,
                                  color: AppColorHelper().textColor,
                                  fontWeight: FontWeight.w500), onPressed: () {
                            controller.nextPage(true);
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
