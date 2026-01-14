import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/date_helper.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/model/task_model.dart';
import 'package:pmms/view/widget/text/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/story_details_controller.dart';
import '../../../dialogues/success_dialogue.dart';
import '../../../loaders/story_details_loader.dart';
import '../../../widget/common_widget.dart';

class StoryDetailsView extends AppBaseView<StoryDetailsController> {
  const StoryDetailsView({super.key});

  @override
  Widget buildView() => _widgetView();

  Widget _widgetView() {
    return appFutureBuilder<void>(
        () => controller.fetchStoryDetailsInitData(),
        (context, snapshot) => Obx(() {
              return _body();
            }),
        loaderWidget: const StoryDetailsLoader());
  }

  GestureDetector _body() {
    var task = controller.rxFetchedStory.value!;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: appScaffold(
        appBar:
            customAppBar("TKN-${task.tokenId ?? "--"}", actions: [_dotMenu()]),
        body: appContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  height(18),
                  Row(
                    children: [
                      _statusContainer(task),
                      width(10),
                      _typeContainer(task)
                    ],
                  ),
                  height(10),
                  _descriptionBox(task),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: divider(
                        color: AppColorHelper()
                            .dividerColor
                            .withValues(alpha: 0.2)),
                  ),
                  height(10),
                  _horizontalDetailBox(task),
                  height(30),
                  _assigneeBox(task),
                  _datesSection(task),
                  height(15),
                  task.attachment != " "
                      ? SizedBox(
                          child: Column(
                            children: [
                              _attatchmentsSection(),
                              height(15),
                              _linksSection(),
                            ],
                          ),
                        )
                      : height(0),
                  height(15),
                  _loggedDetails(task)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _linksSection() {
    return Row(
      children: [
        Container(
          height: 31,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColorHelper().transparentColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppColorHelper().borderColor.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: AppColorHelper().primaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Center(
                  child: Image.asset(
                    Assets.icons.linkIcon.path,
                    scale: 5,
                  ),
                ),
              ),
              width(10),

              /// 👇 APPLY MAX WIDTH ONLY TO THE LINK
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: appLink(
                  "https://www.figma.com/design/kXcAF2WNsrCXhaMG5ZB9iH/PMMS-Mobile-App---Dev-Prototype?node-id=754-6655&t=NtfX1Qifpk754FSN-0",
                ),
              ),
            ],
          ),
        ),

        /////////////
        width(10),
        Container(
          height: 31,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColorHelper().transparentColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppColorHelper().borderColor.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: AppColorHelper().primaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Center(
                  child: Image.asset(
                    Assets.icons.linkIcon.path,
                    scale: 5,
                  ),
                ),
              ),
              width(10),

              /// 👇 APPLY MAX WIDTH ONLY TO THE LINK
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: appLink(
                  "https://www.figma.com/design/kXcAF2WNsrCXhaMG5ZB9iH/PMMS-Mobile-App---Dev-Prototype?node-id=754-6655&t=NtfX1Qifpk754FSN-0",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDropdownDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // No dim background
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: kToolbarHeight, // just below AppBar
              right: 15, // adjust as needed
              child: Material(
                color: Colors.white,
                elevation: 4,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: 150,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _dropItem("Hold Story", () async {
                        goBack(); //for closing menu
                        bool success = await controller.holdStory(false);
                        if (success) {
                          await showDialog(
                            context: Get.context!,
                            barrierDismissible: true,
                            builder: (_) => const SuccessDialogue(
                              title: "Story status updated to Hold",
                              subtitle1: "",
                              subtitle2: "",
                              subtitle3: "",
                            ),
                          );
                          controller.tasksController.fetchInitData();
                          goBack(); // for returning to task page
                        }
                      }),
                      divider(
                          color: AppColorHelper()
                              .dividerColor
                              .withValues(alpha: 0.2)),
                      _dropItem("Edit Story", () {
                        Map<String, dynamic> arg = {
                          currentStoryKey:
                              controller.rxFetchedStory.value?.toJson(),
                        };
                        navigateTo(editStoryPageRoute, arguments: arg);
                      }),
                      divider(
                          color: AppColorHelper()
                              .dividerColor
                              .withValues(alpha: 0.2)),
                      _dropItem("Reject Story", () async {
                        goBack(); //for closing menu
                        bool success = await controller.rejectStory(false);
                        if (success) {
                          await showDialog(
                            context: Get.context!,
                            barrierDismissible: true,
                            builder: (_) => const SuccessDialogue(
                              title: "Story Rejected Successfully",
                              subtitle1: "",
                              subtitle2: "",
                              subtitle3: "",
                            ),
                          );
                          controller.tasksController.fetchInitData();
                          goBack(); // for returning to task page
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  GestureDetector _dropItem(String item, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            appText(
              item,
              fontWeight: FontWeight.w500,
              color: AppColorHelper().primaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dotMenu() => Padding(
        padding: const EdgeInsets.only(right: 8.0, top: 15),
        child: GestureDetector(
            onTap: () {
              _showDropdownDialog(Get.context!);
            },
            child: const Icon(
              Icons.more_vert_outlined,
              size: 30,
            )),
      );

  Widget appLink(String text) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: AppColorHelper().primaryTextColor.withValues(alpha: 0.7),
          decoration: TextDecoration.underline,
          decorationThickness: 0.7,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            final uri = Uri.parse(text);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
      ),
    );
  }

  Widget _loggedDetails(StoryList task) {
    final logs = task.workLog ?? [];

    final loggedTime = task.loggedTime ?? "0.0";
    final estimateTime = task.estimateTime ?? "0.0";

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColorHelper().transparentColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColorHelper().borderColor.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          _logDetails(loggedTime, estimateTime),
          height(15),
          _progressBar(loggedTime, estimateTime),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: divider(
              color: AppColorHelper().dividerColor.withValues(alpha: 0.1),
            ),
          ),
          _logText(),
          height(20),
          if (logs.isEmpty)
            appText(
              "No work logs available",
              fontSize: 13,
              color: AppColorHelper().primaryTextColor.withValues(alpha: 0.6),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                bool isLast = index == logs.length - 1;
                return _logContainer(logs[index], isLast);
              },
            ),
        ],
      ),
    );
  }

  Column _logContainer(WorkLog logDetails, bool isLast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${logDetails.loggedEmpName} - ",
                style: textStyle(
                    14, AppColorHelper().primaryTextColor, FontWeight.w500),
              ),
              TextSpan(
                text: 'Logged work on ${logDetails.loggedDate}',
                style: textStyle(
                    14,
                    AppColorHelper().primaryTextColor.withValues(alpha: 0.5),
                    FontWeight.w500),
              ),
            ],
          ),
        ),
        height(6),
        ///////////////
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Time Spent : ",
                style: textStyle(
                    14,
                    AppColorHelper().primaryTextColor.withValues(alpha: 0.5),
                    FontWeight.w500),
              ),
              TextSpan(
                text: '${logDetails.loggedTime} h',
                style: textStyle(
                    14, AppColorHelper().primaryTextColor, FontWeight.w500),
              )
            ],
          ),
        ),
        height(6),
        ///////////////
        appText(logDetails.loggedDescription ?? "",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColorHelper().primaryTextColor),
        isLast
            ? width(0)
            : divider(
                color: AppColorHelper().dividerColor.withValues(alpha: 0.2))
      ],
    );
  }

  Row _logText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none, // allow divider to go outside
          children: [
            // Main text
            appText(
              viewWorkLog.tr,
              color: AppColorHelper().primaryTextColor,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),

            // Divider you can move freely
            Positioned(
              top: 10,
              child: SizedBox(
                width: 75,
                child: divider(
                    color: AppColorHelper()
                        .primaryTextColor
                        .withValues(alpha: 0.4)),
              ),
            ),
          ],
        ),
        width(5),
        Image.asset(
          Assets.icons.arrowup.path,
          scale: 4,
        )
      ],
    );
  }

  Row _progressBar(String loggedTime, String estimateTime) {
    double logged = double.tryParse(loggedTime) ?? 0.0;
    double estimated = double.tryParse(estimateTime) ?? 0.0;

    int percentage = 0;

    if (estimated > 0) {
      percentage = ((logged / estimated) * 100).round();
    }
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: Get.width * 0.95,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Obx(() {
                final ratio = (logged / estimated).clamp(0.0, 1.0);
                return LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(2),
                    value: ratio,
                    backgroundColor: const Color.fromARGB(255, 34, 34, 34)
                        .withValues(alpha: 0.1),
                    valueColor:
                        AlwaysStoppedAnimation(AppColorHelper().primaryColor),
                    minHeight: 10);
              }),
            ),
          ),
        ),
        width(12),
        appText("$percentage %",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColorHelper().primaryTextColor)
      ],
    );
  }

  Row _logDetails(String loggedTm, String estimateTm) {
    var loggedTim = DateHelper().formatTimeForUi(loggedTm);
    var estimateTim = DateHelper().formatTimeForUi(estimateTm);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appText(loggedTim,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColorHelper().primaryTextColor),
            height(5),
            appText(loggedTime.tr,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColorHelper().primaryTextColor.withValues(alpha: 0.7))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: verticalDivider(30),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            appText(estimateTim,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColorHelper().primaryTextColor),
            height(5),
            appText(estimatedTime.tr,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColorHelper().primaryTextColor.withValues(alpha: 0.7))
          ],
        )
      ],
    );
  }

  Padding _datesSection(StoryList task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoColums(
              requestDate.tr,
              (DateHelper.formatToShortMonthDateYear(
                  DateHelper().formatApiToDateTime(task.requestDateTime) ??
                      DateTime(0000)))),
          verticalDivider(),
          _infoColums(
              startaDate.tr,
              (DateHelper.formatToShortMonthDateYear(
                  DateHelper().formatApiToDateTime(task.startDate) ??
                      DateTime(0000)))),
          verticalDivider(),
          _infoColums(
              endDate.tr,
              (DateHelper.formatToShortMonthDateYear(
                  DateHelper().formatApiToDateTime(task.endDate) ??
                      DateTime(0000)))),
        ],
      ),
    );
  }

  SizedBox _attatchmentsSection() {
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText("Attachments",
              color: AppColorHelper().primaryTextColor,
              fontWeight: FontWeight.w500,
              fontSize: 14),
          height(20),
          Row(
            children: [
              Container(
                width: 85,
                height: 82,
                decoration: BoxDecoration(
                    color: AppColorHelper().circleAvatarBgColor,
                    borderRadius: BorderRadius.circular(4)),
                // child: Center(
                //   child: Icon(
                //     Icons.add_rounded,
                //     size: 35,
                //     color: AppColorHelper()
                //         .primaryTextColor
                //         .withValues(alpha: 0.5),
                //   ),
                // ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container verticalDivider([double? height]) {
    return Container(
      height: height ?? 60,
      width: 1,
      color: AppColorHelper().primaryTextColor.withValues(alpha: 0.07),
    );
  }

  Container _assigneeBox(StoryList task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      height: 50,
      decoration: BoxDecoration(
          color: AppColorHelper().cardColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: AppColorHelper().borderColor.withValues(alpha: 0.5))),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColorHelper().circleAvatarBgColor,
            radius: 20,
            child: appText(
              (task.assignee ?? "x").substring(0, 1),
              color: AppColorHelper().primaryTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          width(10),
          appText(assignedTo.tr,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColorHelper().primaryTextColor.withValues(alpha: 0.7)),
          width(5),
          appText(task.assignee ?? "--",
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColorHelper().primaryTextColor),
        ],
      ),
    );
  }

  Column _descriptionBox(StoryList task) {
    return Column(
      children: [
        SizedBox(
          width:
              double.infinity, // takes full width, but height adapts to content
          child: appText(
            task.description ?? "",
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColorHelper().primaryTextColor,
          ),
        ),
      ],
    );
  }

  SingleChildScrollView _horizontalDetailBox(StoryList task) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _infoColums(
              project.tr, capitalizeFirstOnly(task.projectName ?? "--")),
          width(40),
          _infoColums(module.tr, capitalizeFirstOnly(task.module ?? "--")),
          width(40),
          _infoColums(option.tr, capitalizeFirstOnly(task.optionName ?? "--")),
          width(40),
          _infoColums(plannedStartDate.tr,
              DateHelper().formatForUi(task.plannedStartDate ?? "0000-00-00")),
          width(40),
          _infoColums(plannedEndDate.tr,
              DateHelper().formatForUi(task.plannedEndDate ?? "0000-00-00")),
          width(40),
        ],
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
            color: AppColorHelper().primaryTextColor.withValues(alpha: 0.6)),
        appText(name,
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColorHelper().primaryTextColor)
      ],
    );
  }

  Container _statusContainer(StoryList task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
          color: getStatusColor(task.currentStatus ?? "--")
              .withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
              color: getStatusTextColor(task.currentStatus ?? "--"))),
      child: appText(
        capitalizeFirstOnly(task.currentStatus ?? "--"),
        color: getStatusTextColor(task.currentStatus ?? "--"),
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    );
  }

  Container _typeContainer(StoryList task) {
    final type = task.storyType?.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColorHelper().primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
      ),
      child: appText(
        (type?.isNotEmpty == true ? type! : "--").toUpperCase(),
        color: AppColorHelper().primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    );
  }
}
