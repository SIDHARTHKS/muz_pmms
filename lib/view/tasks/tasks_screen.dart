import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/searchbar/custom_searchbar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../widget/common_widget.dart';

class TasksScreen extends AppBaseView<TasksController> {
  const TasksScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(
        canpop: true,
        body: appFutureBuilder<void>(
            () => controller.fetchInitData(),
            (context, snapshot) => SmartRefresher(
                controller: controller.pullController,
                onRefresh: controller.refreshTasks,
                child: _body()),
            loaderWidget: fullScreenloader()),
      );
  GestureDetector _body() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: appScaffold(
        appBar: customAppBar(
          mytask.tr,
          onTap: () {
            controller.setToDefault();
            goBack();
          },
        ),
        body: appContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Obx(() {
              return Column(
                children: [
                  height(15),
                  _tabBar(),
                  height(15),
                  _searchBar(),
                  controller.totalFilterCount.value != 0
                      ? _filterDetails()
                      : height(0),
                  _tabView(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Padding _filterDetails() {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0, bottom: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 38,
        width: Get.width,
        decoration: BoxDecoration(
            color: AppColorHelper().primaryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appText("${controller.totalFilterCount} Filters Applied",
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColorHelper().primaryTextColor),
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      AppColorHelper().primaryTextColor.withValues(alpha: 0.4)),
              child: GestureDetector(
                onTap: () {
                  controller.resetsetFilters();
                },
                child: Center(
                  child: Icon(
                    Icons.close,
                    color: AppColorHelper().textColor,
                    size: 15,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Expanded _tabView() {
    return Expanded(
        child: controller.rxPlTabScreens[controller.rxTabIndex.value]);
  }

  Container _tabBar() {
    return Container(
      width: Get.width,
      height: 50,
      decoration: BoxDecoration(
          color: AppColorHelper().transparentColor,
          border: Border(
              bottom: BorderSide(
                  color:
                      AppColorHelper().primaryTextColor.withValues(alpha: 0.07),
                  width: 1))),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: controller.rxTabLabel.length,
          itemBuilder: (context, index) {
            final screen = controller.rxTabLabel[index];
            bool isSelected = (controller.rxTabIndex.value == index);
            return Padding(
              padding: const EdgeInsets.only(right: 35.0),
              child: _tabContainer(
                  screen,
                  index == 0
                      ? controller.rxTokens.length.toString()
                      : controller.rxStory.length.toString(),
                  isSelected,
                  index),
            );
          }),
    );
  }

  Obx _tabContainer(String title, String count, bool selected, int index) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          controller.switchTab(index);
        },
        child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: selected
                            ? AppColorHelper().primaryColor
                            : Colors.transparent,
                        width: 2))),
            child: Row(
              children: [
                appText(title,
                    color: selected
                        ? AppColorHelper().primaryTextColor
                        : AppColorHelper()
                            .primaryTextColor
                            .withValues(alpha: 0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
                width(6),
                Container(
                  width: 23,
                  height: 23,
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                      color: selected
                          ? AppColorHelper().primaryColor
                          : AppColorHelper()
                              .primaryTextColor
                              .withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: appText(count,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: selected
                            ? AppColorHelper().textColor
                            : AppColorHelper().primaryTextColor),
                  ),
                )
              ],
            )),
      );
    });
  }

  SizedBox _searchBar() {
    return SizedBox(
      height: 55,
      child: CustomSearchBar(
        onChanged: (value) {
          controller.onSearchChanged(value);
        },
        controller: controller.searchController,
        hintText: "Search tokens, projects, modules",
      ),
    );
  }
}
