import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/date_helper.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/dialogues/success_dialogue.dart';
import 'package:pmms/view/widget/common_widget.dart';
import 'package:pmms/view/widget/text/app_text.dart';

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
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.rxStory.length,
                itemBuilder: (context, index) {
                  final task = controller.rxStory[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 15),
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
                            appText(
                                "TKN-${task.tokenId ?? "--"}-${task.tokenId ?? "--"}",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColorHelper().primaryTextColor),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                  color:
                                      getStatusColor(task.currentStatus ?? "--")
                                          .withValues(alpha: 0.30),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: getStatusTextColor(
                                          task.currentStatus ?? "--"))),
                              child: appText(
                                capitalizeFirstOnly(task.currentStatus ?? "--"),
                                color: getStatusTextColor(
                                    task.currentStatus ?? "--"),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        height(6),
                        appText(capitalizeFirstOnly(task.requestType ?? "--"),
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
                        height(6),
                        height(16),
                        appText(task.description ?? "--",
                            fontSize: 13,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                            color: AppColorHelper().primaryTextColor),
                        _divider(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _infoColums(
                                  project.tr,
                                  capitalizeFirstOnly(
                                      task.projectName ?? "--")),
                              width(40),
                              _infoColums(module.tr,
                                  capitalizeFirstOnly(task.module ?? "--")),
                              width(40),
                              _infoColums(assignee.tr,
                                  capitalizeFirstOnly(task.assignee ?? "--")),
                              // width(40),
                              // _infoColums(createdBy.tr, task),
                              width(40),
                            ],
                          ),
                        ),
                        height(18),
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
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (_) => const SuccessDialogue(
                                      title: "Approved \n Successfully",
                                      subtitle:
                                          "This token request has been  \n approved successfully.",
                                    ),
                                  );
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.of(context).pop();
                                    }
                                  });
                                },
                                appText(
                                  viewThisStory.tr,
                                  color: AppColorHelper()
                                      .secondaryTextColor
                                      .withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
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

  Padding _divider() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child:
          divider(color: AppColorHelper().dividerColor.withValues(alpha: 0.2)),
    );
  }
}
