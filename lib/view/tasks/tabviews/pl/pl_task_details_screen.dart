import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/date_helper.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/model/task_model.dart';
import 'package:pmms/view/tasks/bottomsheet/description_bottomsheet.dart';
import 'package:pmms/view/tasks/bottomsheet/edit_bottomsheet.dart';
import 'package:pmms/view/widget/text/app_text.dart';
import '../../../dialogues/rejected_dialogue.dart';
import '../../../dialogues/success_dialogue.dart';
import '../../../widget/common_widget.dart';

class PlTaskDetailsScreen extends AppBaseView<TasksController> {
  const PlTaskDetailsScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(
        canpop: true,
        body: appFutureBuilder<void>(
          () => controller.fetchInitData(),
          (context, snapshot) => Obx(() {
            return _body();
          }),
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
        appBar: customAppBar(capitalizeFirstOnly(task.requestType ?? "")),
        bottomNavigationBar: _bottomButtons(),
        body: appContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ProgressLoader(
                  //   color: AppColorHelper().primaryColor,
                  //   height: 3,
                  // ),

                  height(10),
                  _avatarSection(task),
                  _tokenSection(task),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appText(description.tr,
                          color: AppColorHelper()
                              .primaryTextColor
                              .withValues(alpha: 0.7),
                          fontSize: 13),
                      height(6),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double
                                  .infinity, // takes full width, but height adapts to content
                              child: appText(
                                task.description ?? "",
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColorHelper().primaryTextColor,
                              ),
                            ),
                          ),
                          width(10),
                          GestureDetector(
                            onTap: () {
                              controller.handleDescription(task);
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: Get.context!,
                                builder: (context) {
                                  return DescriptionBottomSheet(
                                    title: description.tr,
                                    hintText: "",
                                    controller:
                                        controller.descriptionController,
                                    onClose: () {
                                      controller.descriptionController.text =
                                          controller.actualDescription.value;
                                      goBack();
                                    },
                                    onChanged: (value) {
                                      controller.verifyDescriptionEdit(value);
                                    },
                                  );
                                },
                              );
                            },
                            child: Image.asset(
                              Assets.icons.edit.path,
                              height: 18,
                              width: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  height(15),
                  divider(
                      color: AppColorHelper()
                          .dividerColor
                          .withValues(alpha: 0.14)),
                  height(20),
                  _editableDetails(
                      "Project",
                      task.projectName ?? "x",
                      controller
                          .projectList), ///////////////////////use id when response is available
                  _editableDetails(
                      "Team", task.team ?? "--", controller.teamList),
                  _editableDetails(
                      "Module", task.module ?? "--", controller.moduleList),
                  _editableDetails(
                      "Option", task.optionName ?? "--", controller.optionList),
                  _editableDetails("Assignee", task.assignee ?? "--",
                      controller.assigneeList),
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
                              width: 75,
                              height: 82,
                              decoration: BoxDecoration(
                                  color: AppColorHelper().circleAvatarBgColor,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Center(
                                child: Icon(
                                  Icons.add_rounded,
                                  size: 35,
                                  color: AppColorHelper()
                                      .primaryTextColor
                                      .withValues(alpha: 0.5),
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

  Padding _tokenSection(TaskResponse task) {
    return Padding(
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
                appText(task.tokenId ?? "--",
                    color: AppColorHelper().primaryTextColor,
                    fontWeight: FontWeight.w800)
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: getPriorityColor(task.priority ?? "Medium")
                    .withValues(alpha: 0.30),
                borderRadius: BorderRadius.circular(5),
              ),
              child: appText(
                task.priority ?? "Medium",
                color: getPriorityTextColor(task.priority ?? "Medium"),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _avatarSection(TaskResponse task) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColorHelper().circleAvatarBgColor,
          radius: 20,
          child: appText(
            (task.projectName ?? "x").substring(0, 1),
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
                        FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text:
                          ", ${DateHelper.formatToShortMonthDateYear(task.requestDateTime ?? DateTime.now())}",
                      style: textStyle(
                        13,
                        AppColorHelper().primaryTextColor,
                        FontWeight.w500,
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  SafeArea _bottomButtons() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
        child: Row(
          children: [
            Expanded(
              child: buttonContainer(
                height: 42,
                color: AppColorHelper().cardColor,
                borderColor:
                    AppColorHelper().borderColor.withValues(alpha: 0.3),
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
                height: 42,
                color: AppColorHelper().primaryColor.withValues(alpha: 0.9),
                onPressed: () {
                  showDialog(
                      context: Get.context!,
                      barrierDismissible: true,
                      builder: (_) => const SuccessDialogue(
                            title: "Approved \n Successfully",
                            subtitle1: "This token request has been",
                            subtitle2: "",
                            subtitle3: "approved successfully.",
                          ));
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
      ),
    );
  }

  Padding _editableDetails(
      String title, String subtitle, List<FiltersResponse> list) {
    FiltersResponse selected = FiltersResponse();
    for (var i in list) {
      if (i.mccName!.toLowerCase() == subtitle.toLowerCase()) {
        selected = i;
        break;
      }
    }
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
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: Get.context!,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: EditBottomsheet(
                        label: title,
                        list: list,
                        selectedItem: selected,
                      ),
                    );
                  },
                );
              },
              child: Image.asset(
                Assets.icons.edit.path,
                height: 18,
                width: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
