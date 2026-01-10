import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/edit_story_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/view/widget/common_widget.dart';
import 'package:pmms/view/widget/datepicker/custom_datepicker.dart';
import 'package:pmms/view/widget/dropdown/custom_dropdown.dart';

class EditStoryPage2 extends AppBaseView<EditStoryController> {
  const EditStoryPage2({super.key});

  @override
  Widget buildView() => _widgetView();

  Widget _widgetView() {
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          children: [
            _selectedDetailsSection(),
            _horizontalDisplay(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
              child: divider(
                  color: AppColorHelper().dividerColor.withValues(alpha: 0.2)),
            ),
            CustomDropdown<DropDownResponse>(
              label: module.tr,
              widgetHeight: 55,
              isRequired: false,
              items: controller.rxModuleList,
              selectedValue: controller.rxSelectedModule.value,
              onChanged: (value) {
                controller.rxSelectedModule.value = value;
              },
              itemLabelBuilder: (item) => item.name ?? '',
            ),
            height(15),
            CustomDropdown<DropDownResponse>(
              label: option.tr,
              widgetHeight: 55,
              isRequired: false,
              items: controller.rxOptionsList,
              selectedValue: controller.rxSelectedOption.value,
              onChanged: (value) {
                controller.rxSelectedOption.value = value;
              },
              itemLabelBuilder: (item) => item.name ?? '',
            ),
            height(18),
            CustomDatePicker(
              widgetHeight: 55,
              label: requestDate.tr,
              isRequired: false,
              selectedDate: controller.rxRequestDate,
              onDateChanged: (date) {
                controller.rxRequestDate = date!;
              },
            ),
            height(18),
            CustomDatePicker(
              widgetHeight: 55,
              label: plannedStartDate.tr,
              isRequired: false,
              selectedDate: controller.rxPlannedStartDate,
              onDateChanged: (date) {
                controller.rxPlannedStartDate = date!;
              },
            ),
            height(18),
            CustomDatePicker(
              widgetHeight: 55,
              label: plannedEndDate.tr,
              isRequired: false,
              selectedDate: controller.rxPlannedEndDate,
              onDateChanged: (date) {
                controller.rxPlannedEndDate = date!;
              },
            ),
            height(18),
            _attatchmentsSection()
          ],
        ),
      );
    });
  }

  SizedBox _attatchmentsSection() {
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText(
            "Attachments",
            fontSize: 13,
            color: AppColorHelper().lightTextColor,
            fontWeight: FontWeight.w400,
          ),
          height(10),
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

  SingleChildScrollView _horizontalDisplay() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _horizontalContainer(storyTitle.tr, "Sample"),
          width(10),
          _horizontalContainer(
              type.tr, controller.rxSelectedStoryType.value!.mccId ?? ""),
          width(10),
          _horizontalContainer(
              assignee.tr, controller.rxSelectedAsignee.value!.id ?? ""),
        ],
      ),
    );
  }

  Container _horizontalContainer(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      decoration: BoxDecoration(
          color: AppColorHelper().secondaryTextColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Row(
          children: [
            appText("$title : ",
                color: AppColorHelper().primaryTextColor.withValues(alpha: 0.5),
                fontSize: 13,
                fontWeight: FontWeight.w400),
            appText(subtitle,
                color: AppColorHelper().primaryTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ],
        ),
      ),
    );
  }

  Row _selectedDetailsSection() {
    return Row(
      children: [
        // _selectedContainer(
        //     project.tr, controller.rxSelectedProject.value?.mccName ?? "--"),
        width(10),
        // _selectedContainer(
        //     type.tr, controller.rxSelectedRequest.value?.mccName ?? "--")
      ],
    );
  }
}
