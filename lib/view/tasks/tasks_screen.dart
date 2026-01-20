import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/refresh/common_refresh_indicator.dart';
import 'package:pmms/view/widget/searchbar/custom_searchbar.dart';
import '../widget/common_widget.dart';

class TasksScreen extends AppBaseView<TasksController> {
  const TasksScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(
        canpop: true,
        body: CommonRefreshIndicator(
          controller: controller.pullController,
          onRefresh: () {
            controller.refreshTasks(true);
          },
          child: _body(),
        ),
      );
  Obx _body() {
    return Obx(() {
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
                child: Column(
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
                )),
          ),
        ),
      );
    });
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
            appText("${controller.totalFilterCount} ${filtersApplied.tr}",
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
        child: controller.rxIsLoading.value
            ? Center(
                child: CupertinoActivityIndicator(
                radius: 11,
                color: AppColorHelper().primaryColor,
              ))
            : controller.rxTabScreens[controller.rxTabIndex.value]);
  }

  Widget _tabBar() {
    return Obx(() {
      return Container(
        width: Get.width,
        height: 50,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColorHelper().primaryTextColor.withValues(alpha: 0.07),
              width: 1,
            ),
          ),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.rxTabLabel.length,
          itemBuilder: (context, index) {
            final title = controller.rxTabLabel[index];
            final isSelected = controller.rxTabIndex.value == index;

            final count = index == 0
                ? controller.rxTokens.length
                : controller.rxStory.length;

            return Padding(
              padding: const EdgeInsets.only(right: 35.0),
              child: _tabContainer(
                title,
                count.toString(),
                isSelected,
                index,
              ),
            );
          },
        ),
      );
    });
  }

  Widget _tabContainer(
    String title,
    String count,
    bool selected,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        controller.switchTab(index);
        controller.resetHorizontalScrollState();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  selected ? AppColorHelper().primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            appText(
              title,
              color: selected
                  ? AppColorHelper().primaryTextColor
                  : AppColorHelper().primaryTextColor.withValues(alpha: 0.5),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            width(6),
            Container(
              width: 23,
              height: 23,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColorHelper().primaryColor
                    : AppColorHelper().primaryTextColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4),
              ),
              child: appText(
                count,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: selected
                    ? AppColorHelper().textColor
                    : AppColorHelper().primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _searchBar() {
    return SizedBox(
      height: 55,
      child: CustomSearchBar(
        onChanged: (value) {
          controller.onSearchChanged(value);
        },
        controller: controller.searchController,
        hintText: searchTokensProjects.tr,
      ),
    );
  }
}
