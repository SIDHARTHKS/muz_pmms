import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/date_helper.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/text/app_text.dart';
import '../dialogues/rejected_dialogue.dart';
import '../dialogues/success_dialogue.dart';
import '../widget/common_widget.dart';

class TaskDetailsScreen extends AppBaseView<TasksController> {
  const TaskDetailsScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(
        canpop: true,
        body: appFutureBuilder<void>(
          () => controller.fetchInitData(),
          (context, snapshot) => _body(),
        ),
      );
  GestureDetector _body() {
    var task = controller.rxTaskDetail.value!;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: appScaffold(
        bottomNavigationBar: _bottomButtons(),
        body: appContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  height(10),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColorHelper()
                            .circleAvatarBgColor
                            .withValues(alpha: 0.1),
                        radius: 24,
                        child: appText(
                          task.title.substring(0, 1),
                          color: AppColorHelper().primaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      width(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: AppColorHelper().primaryTextColor,
                                  fontSize: 13,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Requested by ",
                                    style: textStyle(
                                      12,
                                      AppColorHelper()
                                          .primaryTextColor
                                          .withValues(alpha: 0.5),
                                      FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: task.requestedBy,
                                    style: textStyle(
                                      13,
                                      AppColorHelper().primaryTextColor,
                                      FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ", ${DateHelper.formatToShortMonthDateYear(task.requestedDate)}",
                                    style: textStyle(
                                      13,
                                      AppColorHelper().primaryTextColor,
                                      FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            height(4),
                            RichText(
                              text: TextSpan(
                                style: textStyle(
                                  14,
                                  AppColorHelper().primaryTextColor,
                                  FontWeight.w700,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Client Ref ID: ",
                                    style: textStyle(
                                      12,
                                      AppColorHelper()
                                          .primaryTextColor
                                          .withValues(alpha: 0.5),
                                      FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: task.clientRefId,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColorHelper().cardColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              appText("Token ID : ",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: AppColorHelper()
                                      .primaryTextColor
                                      .withValues(alpha: 0.5)),
                              appText(task.tokenId,
                                  color: AppColorHelper().primaryTextColor,
                                  fontWeight: FontWeight.w800)
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(task.priority)
                                  .withValues(alpha: 0.17),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: appText(
                              task.priority,
                              color: _getPriorityColor(task.priority),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double
                        .infinity, // takes full width, but height adapts to content
                    child: appText(
                      task.description,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColorHelper().primaryTextColor,
                    ),
                  ),
                  height(15),
                  divider(
                      color: AppColorHelper()
                          .dividerColor
                          .withValues(alpha: 0.14)),
                  height(20),
                  _editableDetails("Project", task.project),
                  _editableDetails("Team", task.team),
                  _editableDetails("Module", task.module),
                  _editableDetails("Option", task.option),
                  _editableDetails("Assignee", task.assignee),
                  SizedBox(
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appText("Attachments",
                            color: AppColorHelper()
                                .primaryTextColor
                                .withValues(alpha: 0.7),
                            fontSize: 14),
                        height(20),
                        Row(
                          children: [
                            Container(
                              width: 70,
                              height: 75,
                              decoration: BoxDecoration(
                                  color: AppColorHelper()
                                      .circleAvatarBgColor
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 30,
                                  color: AppColorHelper()
                                      .iconColor
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _bottomButtons() {
    return Container(
      padding: const EdgeInsets.only(bottom: 40, left: 15, right: 15),
      child: Row(
        children: [
          Expanded(
            child: buttonContainer(
              height: 40,
              color: AppColorHelper().cardColor,
              borderColor: AppColorHelper().borderColor.withValues(alpha: 0.3),
              onPressed: () {
                showDialog(
                  context: Get.context!,
                  barrierDismissible: true,
                  builder: (_) => const RejectedDialogue(),
                );
                Future.delayed(const Duration(seconds: 1), () {
                  if (Navigator.canPop(Get.context!)) {
                    Navigator.of(Get.context!).pop();
                  }
                });
              },
              appText(
                reject.tr,
                color: AppColorHelper().primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          width(12),
          Expanded(
            child: buttonContainer(
              height: 40,
              color: AppColorHelper().primaryColor.withValues(alpha: 0.9),
              onPressed: () {
                showDialog(
                  context: Get.context!,
                  barrierDismissible: true,
                  builder: (_) => const SuccessDialogue(),
                );
                Future.delayed(const Duration(seconds: 1), () {
                  if (Navigator.canPop(Get.context!)) {
                    Navigator.of(Get.context!).pop();
                  }
                });
              },
              appText(
                approve.tr,
                color: AppColorHelper().textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _editableDetails(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appText(title,
                    color: AppColorHelper()
                        .primaryTextColor
                        .withValues(alpha: 0.7),
                    fontSize: 13),
                appText(subtitle,
                    color: AppColorHelper().primaryTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)
              ],
            ),
            Image.asset(
              Assets.icons.edit.path,
              height: 18,
              width: 18,
            )
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return AppColorHelper().statusHighColor;
      case "medium":
        return AppColorHelper().statusMediumColor;
      case "low":
        return AppColorHelper().statusLowColor;
      default:
        return Colors.grey;
    }
  }
}
