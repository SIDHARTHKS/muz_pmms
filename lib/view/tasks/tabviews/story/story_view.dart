import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/common_widget.dart';

class StoryView extends AppBaseView<TasksController> {
  const StoryView({super.key});

  @override
  Widget buildView() => _widgetView();

  Widget _widgetView() => _body();

  GestureDetector _body() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: SizedBox(
        child: Column(
          children: [
            _listView(),
          ],
        ),
      ),
    );
  }

  Expanded _listView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            height(10),
            Obx(() {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.rxStory.length,
                  itemBuilder: (context, index) {
                    final task = controller.rxStory[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 18),
                      decoration: BoxDecoration(
                        color: AppColorHelper().cardColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: AppColorHelper()
                                .borderColor
                                .withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText("TKN-${task.tokenId ?? "--"}",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColorHelper().primaryTextColor),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                    color: getStatusColor(
                                            task.currentStatus ?? "--")
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                        color: getStatusTextColor(
                                            task.currentStatus ?? "--"))),
                                child: appText(
                                  capitalizeFirstOnly(
                                      task.currentStatus ?? "--"),
                                  color: getStatusTextColor(
                                      task.currentStatus ?? "--"),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          height(10),
                          appText(capitalizeFirstOnly(task.description ?? "--"),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColorHelper().primaryTextColor),
                          height(6),
                          Container(
                            height: 2,
                            width: Get.width,
                            color: AppColorHelper()
                                .borderColor
                                .withValues(alpha: 0.3),
                          ),
                          height(16),
                          Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: controller
                                      .getHorizontalScrollController(index),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _infoColums(
                                        project.tr,
                                        capitalizeFirstOnly(
                                            task.projectName ?? "--"),
                                      ),
                                      width(40),
                                      _infoColums(
                                        module.tr,
                                        capitalizeFirstOnly(
                                            task.module ?? "--"),
                                      ),
                                      width(40),
                                      _infoColums(
                                        assignee.tr,
                                        capitalizeFirstOnly(
                                            task.assignee ?? "--"),
                                      ),
                                      width(40),
                                    ],
                                  ),
                                ),
                              ),
                              Obx(() {
                                ScrollController thiController = controller
                                    .getHorizontalScrollController(index);
                                return controller.hasOverflow(index).value
                                    ? InkWell(
                                        onTap: () {
                                          thiController.animateTo(
                                            thiController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeOut,
                                          );
                                        },
                                        child: Image.asset(
                                          Assets.icons.overflowRight.path,
                                          scale: 4,
                                        ),
                                      )
                                    : const SizedBox();
                              }),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: AppColorHelper()
                                      .primaryColor
                                      .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      appText("Logged Time : ",
                                          color: AppColorHelper()
                                              .primaryTextColor
                                              .withValues(alpha: 0.6),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13),
                                      appText(task.loggedTime.toString(),
                                          color:
                                              AppColorHelper().primaryTextColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      appText("Estimated Time : ",
                                          color: AppColorHelper()
                                              .primaryTextColor
                                              .withValues(alpha: 0.6),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13),
                                      appText(task.estimateTime.toString(),
                                          color:
                                              AppColorHelper().primaryTextColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: buttonContainer(
                                  height: 42,
                                  color: AppColorHelper()
                                      .primaryColorLight
                                      .withValues(alpha: 0.9),
                                  borderColor: AppColorHelper()
                                      .primaryColor
                                      .withValues(alpha: 0.8),
                                  width: 0.1,
                                  onPressed: () async {
                                    Map<String, dynamic> arg = {
                                      selectedViewStoryKey: task.toJson(),
                                    };

                                    navigateTo(storyDetailsPageRoute,
                                        arguments: arg);
                                  },
                                  appText(
                                    viewThisStory.tr,
                                    fontSize: 13,
                                    color: AppColorHelper().secondaryTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            })
          ],
        ),
      ),
    );
  }

  Column _infoColums(String type, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(type,
            fontWeight: FontWeight.w400,
            fontSize: 13,
            color: AppColorHelper().primaryTextColor.withValues(alpha: 0.5)),
        appText(name,
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColorHelper().primaryTextColor)
      ],
    );
  }
}
