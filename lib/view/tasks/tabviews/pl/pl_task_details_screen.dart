import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/edit_token_controller.dart';
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
import 'package:pmms/view/tasks/bottomsheet/edit_dropdown_bottomsheet.dart';
import 'package:pmms/view/widget/text/app_text.dart';
import '../../../dialogues/rejected_dialogue.dart';
import '../../../dialogues/success_dialogue.dart';
import '../../../widget/common_widget.dart';

class PlTaskDetailsScreen extends AppBaseView<EditTokenController> {
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
    var task = controller.rxSelectedToken.value!;
    bool isApproved = task.currentStatus?.toLowerCase() == "approved";
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
                                controller.actualDescription.value,
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
                                builder: (_) {
                                  return DescriptionBottomSheet(
                                    title: description.tr,
                                    hintText: "",
                                    controller:
                                        controller.descriptionController,
                                    onClose: () {
                                      controller.handleSaveDescription(task);
                                      goBack();
                                    },
                                    onSave: () {
                                      controller.handleSaveDescription(task);
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
                      height(15),
                      divider(
                          color: AppColorHelper()
                              .dividerColor
                              .withValues(alpha: 0.14)),
                      height(20),
                      isApproved
                          ? _nonEditableDetails(
                              "Project",
                              task.projectName ?? "--",
                            )
                          : _editableFilterDetails(
                              "Project",
                              controller.rxProjectsList,
                              controller.rxSelectedProject),
                      _editableDropdownDetails("Team", controller.rxTeamList,
                          controller.rxSelectedTeam),
                      _editableDropdownDetails("Module",
                          controller.rxModuleList, controller.rxSelectedModule),
                      _editableDropdownDetails(
                          "Option",
                          controller.rxOptionsList,
                          controller.rxSelectedOption),
                      _nonEditableDetails(
                        "Assignee",
                        task.assignee ?? "--",
                      )
                    ],
                  ),

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
    bool hasId = task.clientRefId != "";
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
                      text: requestBy.tr,
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
              hasId
                  ? RichText(
                      text: TextSpan(
                        style: textStyle(
                          14,
                          AppColorHelper().primaryTextColor,
                          FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: "${clientRefID.tr}:",
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
                    )
                  : width(0),
            ],
          ),
        ),
      ],
    );
  }

  SafeArea _bottomButtons() {
    return SafeArea(
      child: Container(
        padding:
            const EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 15),
        child: controller.rxEdited.value
            ? Row(
                children: [
                  Expanded(
                    child: buttonContainer(
                      height: 42,
                      color:
                          AppColorHelper().primaryColor.withValues(alpha: 0.9),
                      borderColor:
                          AppColorHelper().borderColor.withValues(alpha: 0.3),
                      onPressed: () async {
                        controller.callUpdateToken().then((success) async {
                          if (success) {
                            await showDialog(
                              context: Get.context!,
                              barrierDismissible:
                                  false, // prevents user from closing early
                              builder: (_) => SuccessDialogue(
                                title: tokenHasBeenUpdatedSuccessfully.tr,
                                subtitle1: "",
                                subtitle2: "",
                                subtitle3: "",
                              ),
                            );
                            controller.tasksController.refreshTasks(true);
                            controller.setEditedTask();
                          }
                        });
                      },
                      controller.rxIsLoading.value
                          ? buttonLoader()
                          : appText(
                              save.tr,
                              color: AppColorHelper().textColor,
                              fontWeight: FontWeight.w500,
                            ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: buttonContainer(
                      height: 42,
                      color: AppColorHelper().cardColor,
                      borderColor:
                          AppColorHelper().borderColor.withValues(alpha: 0.3),
                      onPressed: () async {
                        await controller.tasksController
                            .rejectToken()
                            .then((value) {
                          if (value) {
                            showDialog(
                              context: Get.context!,
                              barrierDismissible: true,
                              builder: (_) => const RejectedDialogue(),
                            );
                            Future.delayed(const Duration(seconds: 2), () {
                              if (Navigator.canPop(Get.context!)) {
                                Navigator.of(Get.context!).pop();
                              }
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              if (Navigator.canPop(Get.context!)) {
                                goBack();
                              }
                            });
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
                      color:
                          AppColorHelper().primaryColor.withValues(alpha: 0.9),
                      onPressed: () {
                        controller.tasksController
                            .approveToken()
                            .then((success) {
                          if (success) {
                            showDialog(
                              context: Get.context!,
                              barrierDismissible: true,
                              builder: (_) => const SuccessDialogue(
                                title: "Approved \n Successfully",
                                subtitle1: "This token request has been",
                                subtitle2: "",
                                subtitle3: "approved successfully.",
                              ),
                            );
                            Future.delayed(const Duration(seconds: 1), () {
                              if (Navigator.canPop(Get.context!)) {
                                Navigator.of(Get.context!).pop();
                              }
                            });
                            Future.delayed(const Duration(seconds: 1), () {
                              if (Navigator.canPop(Get.context!)) {
                                goBack();
                              }
                            });
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

  Padding _editableFilterDetails(
    String title,
    List<FiltersResponse> list,
    Rxn<FiltersResponse> selectedRx,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appText(
                  title,
                  color:
                      AppColorHelper().primaryTextColor.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
                appText(
                  selectedRx.value?.mccName ?? "--",
                  color: AppColorHelper().primaryTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ],
            );
          }),
          GestureDetector(
            onTap: () async {
              final oldValue = selectedRx.value;

              final result = await showModalBottomSheet<FiltersResponse>(
                isScrollControlled: true,
                context: Get.context!,
                builder: (_) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
                    ),
                    child: EditBottomsheet(
                      label: title,
                      list: list,
                      selectedItem: oldValue ?? FiltersResponse(),
                    ),
                  );
                },
              );

              if (result == null) return;

              final hasChanged = oldValue?.mccId != result.mccId;

              if (hasChanged) {
                selectedRx.value = result;
                controller.rxEdited(true);
                await controller.fetchProjectBasedDropdown(
                  result.mccId ?? "",
                  "",
                  "",
                  false,
                );
              }
            },
            child: Image.asset(
              Assets.icons.edit.path,
              height: 18,
              width: 18,
            ),
          ),
        ],
      ),
    );
  }

  Padding _editableDropdownDetails(
    String title,
    List<DropDownResponse> list,
    Rxn<DropDownResponse> selectedRx,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appText(
                  title,
                  color:
                      AppColorHelper().primaryTextColor.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
                appText(
                  selectedRx.value?.name ?? "--",
                  color: AppColorHelper().primaryTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ],
            );
          }),
          GestureDetector(
            onTap: () async {
              final result = await showModalBottomSheet<DropDownResponse>(
                isScrollControlled: true,
                context: Get.context!,
                builder: (_) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
                    ),
                    child: EditDropdownBottomsheet(
                      label: title,
                      list: list,
                      selectedItem: selectedRx.value ?? DropDownResponse(),
                    ),
                  );
                },
              );

              if (result != null) {
                selectedRx.value = result;
                controller.rxEdited(true);
              }
            },
            child: Image.asset(
              Assets.icons.edit.path,
              height: 18,
              width: 18,
            ),
          ),
        ],
      ),
    );
  }

  Padding _nonEditableDetails(
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appText(title,
                  color:
                      AppColorHelper().primaryTextColor.withValues(alpha: 0.7),
                  fontSize: 13),
              appText(subtitle,
                  color: AppColorHelper().primaryTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)
            ],
          ),
        ],
      ),
    );
  }
}
