import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/date_helper.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/dialogues/success_dialogue.dart';
import 'package:pmms/view/widget/searchbar/custom_searchbar.dart';
import 'package:pmms/view/widget/text/app_text.dart';
import '../widget/common_widget.dart';

class TasksScreen extends AppBaseView<TasksController> {
  const TasksScreen({super.key});

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
        appBar: customAppBar(mytask.tr),
        body: appContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                height(12),
                _searchBar(),
                _listView(),
              ],
            ),
          ),
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
                itemCount: controller.mockTasks.length,
                itemBuilder: (context, index) {
                  final task = controller.mockTasks[index];
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
                        appText(task.type,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColorHelper().primaryTextColor),
                        height(12),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  AppColorHelper().circleAvatarBgColor,
                              radius: 20,
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
                                        color:
                                            AppColorHelper().primaryTextColor,
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
                                            FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                            text:
                                                ", ${DateHelper.formatToShortMonthDateYear(task.requestedDate)}"),
                                      ],
                                    ),
                                  ),
                                  height(4),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color:
                                            AppColorHelper().primaryTextColor,
                                        fontSize: 13,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Client Ref ID : ",
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
                                          style: textStyle(
                                            13,
                                            AppColorHelper().primaryTextColor,
                                            FontWeight.w500,
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
                        height(16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColorHelper().backgroundColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: AppColorHelper()
                                          .primaryTextColor
                                          .withValues(alpha: 0.5),
                                      fontSize: 13),
                                  children: [
                                    const TextSpan(text: "Token ID : "),
                                    TextSpan(
                                      text: task.tokenId,
                                      style: textStyle(
                                        14,
                                        AppColorHelper()
                                            .primaryTextColor
                                            .withValues(alpha: 0.9),
                                        FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(task.priority)
                                      .withValues(alpha: 0.30),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: appText(
                                  task.priority,
                                  color: _getPriorityTextColor(task.priority),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        height(16),
                        appText(task.description,
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                            color: AppColorHelper().primaryTextColor),
                        height(16),
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
                                    builder: (_) => const SuccessDialogue(),
                                  );
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.of(context).pop();
                                    }
                                  });
                                },
                                appText(
                                  approve.tr,
                                  color: AppColorHelper()
                                      .secondaryTextColor
                                      .withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            width(12),
                            Expanded(
                              child: buttonContainer(
                                height: 42,
                                color: AppColorHelper()
                                    .backgroundColor
                                    .withValues(alpha: 0.9),
                                borderColor: AppColorHelper()
                                    .borderColor
                                    .withValues(alpha: 0.30),
                                onPressed: () {
                                  controller.setTask(task);
                                  navigateTo(taskDetailsPageRoute);
                                },
                                appText(
                                  viewToken.tr,
                                  color: AppColorHelper().primaryTextColor,
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

  SizedBox _searchBar() {
    return SizedBox(
      height: 50,
      child: CustomSearchBar(
        controller: controller.searchController,
        hintText: "Search tokens, projects, modules",
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

  Color _getPriorityTextColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return AppColorHelper().statusHighTextColor;
      case "medium":
        return AppColorHelper().statusMediumTextColor;
      case "low":
        return AppColorHelper().statusLowTextColor;
      default:
        return Colors.grey;
    }
  }
}
