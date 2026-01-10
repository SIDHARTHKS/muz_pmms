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
import '../../../widget/common_widget.dart';

class TlTaskDetailScreen extends AppBaseView<TasksController> {
  const TlTaskDetailScreen({super.key});

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
    var task = controller.rxSelectedToken.value!;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: appScaffold(
        appBar: customStatusAppBar(
          capitalizeFirstOnly(task.requestType ?? ""),
          statusWidget: _statusContainer(task),
        ),
        body: appContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  height(20),
                  _primaryDetailsBox(task),
                  _tokenBox(task),
                  _storyTab(),
                  _noStoryBox(),
                  // _storyBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _storyBox() {
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              height: 40,
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColorHelper().cardColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    _filterButton("All", "12"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        height: 20,
                        width: 1,
                        color: AppColorHelper()
                            .primaryTextColor
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      width: Get.width * 0.65,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.rxTaskFilterTypeList.length -
                            1, // skip first
                        itemBuilder: (context, index) {
                          var item = controller
                              .rxTaskFilterTypeList[index + 1]; // shift index
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: _filterButton(item.mccName ?? "", "4"),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _filterButton(String type, String count) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          appText(type,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColorHelper().primaryTextColor),
          width(6),
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: AppColorHelper().primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: appText(count,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColorHelper().primaryTextColor),
            ),
          )
        ],
      ),
    );
  }

  Padding _noStoryBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        width: Get.width,
        height: 300,
        decoration: BoxDecoration(
            color: AppColorHelper().cardColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: AppColorHelper().borderColor.withValues(alpha: 0.4))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            appText(noStory.tr,
                color: AppColorHelper().primaryTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w400),
            height(10),
            _addStoryButton()
          ],
        ),
      ),
    );
  }

  Row _storyTab() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        appText(storiesInToken.tr,
            color: AppColorHelper().primaryTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 14),
        Row(
          children: [
            // _addStoryButton(),
            width(10),
            Image.asset(
              Assets.icons.filter.path,
              scale: 4,
            ),
          ],
        )
      ],
    );
  }

  GestureDetector _addStoryButton() {
    return GestureDetector(
      onTap: () {
        Map<String, dynamic> arguments = {
          selectedTaskKey: controller.rxSelectedToken.value?.toJson(),
        };

        navigateTo(createStoryPageRoute, arguments: arguments);
      },
      child: Container(
        height: 30,
        width: 100,
        decoration: BoxDecoration(
            color: AppColorHelper().cardColor,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
                color: AppColorHelper().borderColor.withValues(alpha: 0.5))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              appText("+",
                  color: AppColorHelper().primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              width(4),
              appText(newStory.tr,
                  color: AppColorHelper().primaryTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)
            ],
          ),
        ),
      ),
    );
  }

  Row _primaryDetailsBox(TaskResponse task) {
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

  Padding _tokenBox(TaskResponse task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: AppColorHelper().borderColor.withValues(alpha: 0.4))),
        child: Column(
          children: [
            _tokenDetailContainer(task),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Column(
                children: [
                  _descriptionBox(task),
                  _divider(),
                  _horizontalDetailBox(task),
                  height(15),
                ],
              ),
            ),
          ],
        ),
      ),
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
          _infoColums(assignee.tr, capitalizeFirstOnly(task.assignee ?? "--")),
          // width(40),
          // _infoColums(createdBy.tr, task),
          width(40),
        ],
      ),
    );
  }

  SizedBox _descriptionBox(TaskResponse task) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText(description.tr,
              color: AppColorHelper().primaryTextColor.withValues(alpha: 0.6),
              fontSize: 13,
              fontWeight: FontWeight.w400),
          SizedBox(
            width: double
                .infinity, // takes full width, but height adapts to content
            child: appText(
              task.description ?? "",
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColorHelper().primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Container _tokenDetailContainer(TaskResponse task) {
    return Container(
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
                  color:
                      AppColorHelper().primaryTextColor.withValues(alpha: 0.6)),
              appText("TKN-${task.tokenId ?? "--"}",
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

  Padding _divider() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child:
          divider(color: AppColorHelper().dividerColor.withValues(alpha: 0.2)),
    );
  }
}
