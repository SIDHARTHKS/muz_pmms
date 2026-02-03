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
import '../../../loaders/tl_token_detail_loader.dart';
import '../../../widget/common_widget.dart';

class TlTaskDetailScreen extends AppBaseView<TasksController> {
  const TlTaskDetailScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(
        canpop: true,
        body: appFutureBuilder<void>(
            () => controller.fetchTokenDetailsInitData(),
            (context, snapshot) => Obx(() {
                  return _body();
                }),
            loaderWidget: const TlTokenDetailLoader()),
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
                  controller.rxFetchedStories.isEmpty
                      ? _noStoryBox()
                      : _storyBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _storyBox() {
    final stories =
        controller.getStoriesByIndex(controller.rxStoryFilterIndex.value);
    return SizedBox(
      child: Column(
        children: [
          ///////////////////////// filter part //////////////////////////////
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              height: 35,
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColorHelper().cardColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: _allButton(-1, all.tr,
                            controller.rxFetchedStories.length.toString()),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          height: 20,
                          width: 1,
                          color: AppColorHelper()
                              .primaryTextColor
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      Flexible(
                        flex: 10,
                        child: SizedBox(
                          height: 35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.rxStoryStatusFilter.length,
                            itemBuilder: (context, index) {
                              var item = controller.rxStoryStatusFilter[index];
                              bool isSelected =
                                  index == controller.rxStoryFilterIndex.value;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: _filterButton(
                                    index,
                                    item.mccName ?? "",
                                    controller.getStoryCountByIndex(index),
                                    isSelected),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ///////////////////////// LitView part //////////////////////////////

          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                var story = stories[index];
                return _storiesList(story);
              })
        ],
      ),
    );
  }

  GestureDetector _storiesList(StoryList story) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: AppColorHelper().cardColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: AppColorHelper().borderColor.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(
                  "TKN-${story.tokenId ?? "--"}",
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColorHelper().primaryTextColor,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                          color: getStatusColor(story.currentStatus ?? "--")
                              .withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color: getStatusTextColor(
                                  story.currentStatus ?? "--"))),
                      child: appText(
                        capitalizeFirstOnly(story.currentStatus ?? "--"),
                        color: getStatusTextColor(story.currentStatus ?? "--"),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    width(10),
                    GestureDetector(
                      onTap: () {
                        Map<String, dynamic> arg = {
                          selectedViewStoryListKey: story.toJson(),
                        };

                        navigateTo(storyDetailsPageRoute, arguments: arg);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColorHelper()
                              .primaryColor
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            height(12),
            Divider(
              color: AppColorHelper().borderColor.withValues(alpha: 0.2),
            ),
            height(12),
            appText(story.description ?? "--",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColorHelper().primaryTextColor,
                overflow: TextOverflow.ellipsis),

            height(8),

            /// Assignee + role
            Row(
              children: [
                Image.asset(
                  Assets.icons.userIcon.path,
                  scale: 4,
                ),
                width(6),
                appText(story.assignee ?? "",
                    fontSize: 13,
                    color: AppColorHelper().primaryTextColor,
                    fontWeight: FontWeight.w400),
                width(16),
                Image.asset(
                  Assets.icons.typeIcon.path,
                  scale: 4,
                ),
                width(6),
                appText(story.storyType ?? "",
                    fontSize: 13,
                    color: AppColorHelper().primaryTextColor,
                    fontWeight: FontWeight.w400),
              ],
            ),
            height(16),

            /// Log box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              decoration: BoxDecoration(
                color: AppColorHelper().backgroundColor.withValues(alpha: 0.8),
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
                            .withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(text: "${loggedTime.tr} : "),
                        TextSpan(
                          text: story.loggedTime,
                          style: TextStyle(
                            color: AppColorHelper().primaryTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColorHelper()
                            .primaryTextColor
                            .withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(text: "${estimateTime.tr} : "),
                        TextSpan(
                          text: story.estimateTime,
                          style: TextStyle(
                            color: AppColorHelper().primaryTextColor,
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
      ),
    );
  }

  GestureDetector _allButton(int index, String type, String count) {
    bool isActive = index == controller.rxStoryFilterIndex.value;

    return GestureDetector(
      onTap: () => controller.toggleStoryFilter(index),
      child: Row(
        children: [
          appText(type,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: AppColorHelper().primaryTextColor),
          width(8),
          Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
                color: AppColorHelper().primaryColor.withValues(alpha: 0.1),
                border: Border.all(color: AppColorHelper().transparentColor),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: appText(count,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColorHelper().primaryTextColor),
            ),
          )
        ],
      ),
    );
  }

  GestureDetector _filterButton(
      int index, String type, String count, bool isActive) {
    Color activeClr = getStatusTextColor(type);
    return GestureDetector(
      onTap: () => controller.toggleStoryFilter(index),
      child: Row(
        children: [
          appText(type.capitalizeFirst ?? "",
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
              color: isActive
                  ? activeClr
                  : AppColorHelper().primaryTextColor.withValues(alpha: 0.7)),
          width(6),
          Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
                color: isActive
                    ? activeClr.withValues(alpha: 0.2)
                    : AppColorHelper().primaryColor.withValues(alpha: 0.1),
                border: Border.all(
                    color: isActive
                        ? activeClr
                        : AppColorHelper().transparentColor),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: appText(count,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? activeClr
                      : AppColorHelper()
                          .primaryTextColor
                          .withValues(alpha: 0.6)),
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
        controller.rxFetchedStories.isEmpty
            ? Image.asset(
                Assets.icons.filter.path,
                scale: 4,
              )
            : Row(
                children: [
                  _addStoryButton(),
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
              task.clientRefId != ""
                  ? RichText(
                      text: TextSpan(
                        style: textStyle(
                          14,
                          AppColorHelper().primaryTextColor,
                          FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: clientRefID.tr,
                            style: textStyle(
                              12,
                              AppColorHelper()
                                  .primaryTextColor
                                  .withValues(alpha: 0.5),
                              FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: task.clientRefId ?? "--",
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
