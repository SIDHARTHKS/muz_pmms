import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/searchbar/custom_searchbar.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Obx(() {
              return Column(
                children: [
                  height(20),
                  _tabBar(),
                  _divider(),
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
        child: controller.rxTabScreens[controller.rxTabIndex.value]);
  }

  Padding _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child:
          divider(color: AppColorHelper().dividerColor.withValues(alpha: 0.2)),
    );
  }

  SizedBox _tabBar() {
    return SizedBox(
      width: Get.width,
      height: 30,
      child: ListView.builder(
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
            color: AppColorHelper().transparentColor,
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
                  width: 22,
                  height: 22,
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
                        fontSize: 15,
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
        controller: controller.searchController,
        hintText: "Search tokens, projects, modules",
      ),
    );
  }
}
