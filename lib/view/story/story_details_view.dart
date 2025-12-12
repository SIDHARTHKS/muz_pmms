import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
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
import '../widget/common_widget.dart';

class StoryDetailsView extends AppBaseView<TasksController> {
  const StoryDetailsView({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(canpop: true, body: _body());

  GestureDetector _body() {
    var task = controller.rxStoryDetail.value!;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: appScaffold(
        appBar: customAppBar(
            "TKN-${task.tokenId ?? "--"}-${task.tokenId ?? "--"}",
            actions: [_dotMenu()]),
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
                  task.attachment != " " ? _attatchmentsSection() : height(0),
                  height(15),
                  Row(
                    children: [
                      Container(
                        height: 31,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColorHelper().transparentColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColorHelper()
                                .borderColor
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                color: AppColorHelper()
                                    .primaryColor
                                    .withValues(alpha: 0.3),
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
                            color: AppColorHelper()
                                .borderColor
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                color: AppColorHelper()
                                    .primaryColor
                                    .withValues(alpha: 0.3),
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
                  ),
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
                      _dropItem("Hold Story", () {}),
                      divider(
                          color: AppColorHelper()
                              .dividerColor
                              .withValues(alpha: 0.2)),
                      _dropItem("Edit Story", () {
                        Map<String, dynamic> arg = {
                          currentStoryKey: controller.rxStoryDetail.value
                        };
                        navigateTo(editStoryPageRoute, arguments: arg);
                      }),
                      divider(
                          color: AppColorHelper()
                              .dividerColor
                              .withValues(alpha: 0.2)),
                      _dropItem("Reject Story", () {}),
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

  Container _loggedDetails(TaskResponse task) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppColorHelper().transparentColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              color: AppColorHelper().borderColor.withValues(alpha: 0.4))),
      child: Column(
        children: [
          _logDetails(),
          height(15),
          _progressBar(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: divider(
                color: AppColorHelper().dividerColor.withValues(alpha: 0.1)),
          ),
          _logText(),
          height(20),
          _logContainer(task)
        ],
      ),
    );
  }

  Column _logContainer(TaskResponse task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${task.assignee} - ",
                style: textStyle(
                    14, AppColorHelper().primaryTextColor, FontWeight.w500),
              ),
              TextSpan(
                text: 'Logged work on 21 Nov 2025, 05:30 pm',
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
                text: '07:30 h',
                style: textStyle(
                    14, AppColorHelper().primaryTextColor, FontWeight.w500),
              )
            ],
          ),
        ),
        height(6),
        ///////////////
        appText(
            "Payment method clutter if all options appear at once without grouping.",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColorHelper().primaryTextColor),
        divider(color: AppColorHelper().dividerColor.withValues(alpha: 0.2))
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
              fontSize: 11,
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

  Row _progressBar() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: Get.width * 0.95,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Obx(() {
                const loggedTime = 9.5;
                const estimatedTime = 12;
                final ratio = (loggedTime / estimatedTime).clamp(0.0, 1.0);
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
        appText("${90} %",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColorHelper().primaryTextColor)
      ],
    );
  }

  Row _logDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appText("9:30",
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
            appText("12:00",
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

  Padding _datesSection(TaskResponse task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoColums(
              requestDate.tr,
              (DateHelper.formatToShortMonthDateYear(
                  task.requestDateTime ?? DateTime(0000)))),
          verticalDivider(),
          _infoColums(startaDate.tr,
              (DateHelper.formatToShortMonthDateYear(DateTime(0000)))),
          verticalDivider(),
          _infoColums(endDate.tr,
              (DateHelper.formatToShortMonthDateYear(DateTime(0000)))),
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

  Container _assigneeBox(TaskResponse task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      height: 50,
      decoration: BoxDecoration(
          color: AppColorHelper().cardColor,
          borderRadius: BorderRadius.circular(3),
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

  Column _descriptionBox(TaskResponse task) {
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

  SingleChildScrollView _horizontalDetailBox(TaskResponse task) {
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
          _infoColums(plannedStartDate.tr, capitalizeFirstOnly("00/00/0000")),
          width(40),
          _infoColums(plannedEndDate.tr, capitalizeFirstOnly("00/00/0000")),
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

  Container _statusContainer(TaskResponse task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: getStatusColor(task.currentStatus ?? "--"),
        borderRadius: BorderRadius.circular(3),
      ),
      child: appText(
        capitalizeFirstOnly(task.currentStatus ?? "--"),
        color: AppColorHelper().textColor,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    );
  }

  Container _typeContainer(TaskResponse task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColorHelper().primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
      ),
      child: appText(
        "UIUX",
        color: AppColorHelper().primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    );
  }
}
