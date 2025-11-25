import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/state_manager.dart';
import 'package:pmms/controller/create_story_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/view/widget/common_widget.dart';
import 'package:pmms/view/widget/datepicker/custom_datepicker.dart';
import 'package:pmms/view/widget/dropdown/custom_dropdown.dart';

class CreateStoryPage2 extends AppBaseView<CreateStoryController> {
  const CreateStoryPage2({super.key});

  @override
  Widget buildView() => _widgetView();

  Widget _widgetView() {
    return Obx(() {
      return Column(
        children: [
          _selectedDetailsSection(),
          _horizontalDisplay(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
            child: divider(
                color: AppColorHelper().dividerColor.withValues(alpha: 0.2)),
          ),
          CustomDropdown<CommonDropdownResponse>(
            label: module.tr,
            widgetHeight: 52,
            isRequired: true,
            items: controller.moduleTypeList,
            selectedValue: controller.rxSelectedModule.value,
            onChanged: (value) {
              controller.rxSelectedModule.value = value;
            },
            itemLabelBuilder: (item) => item.mccName ?? '',
          ),
          height(12),
          CustomDropdown<CommonDropdownResponse>(
            label: option.tr,
            widgetHeight: 52,
            isRequired: true,
            items: controller.optionTypeList,
            selectedValue: controller.rxSelectedOption.value,
            onChanged: (value) {
              controller.rxSelectedOption.value = value;
            },
            itemLabelBuilder: (item) => item.mccName ?? '',
          ),
          height(12),
          CustomDatePicker(
            label: requestOn.tr,
            isRequired: false,
            selectedDate: controller.rxRequestDate,
            onDateChanged: (date) {
              controller.rxRequestDate = date!;
            },
          ),
          height(12),
          CustomDatePicker(
            label: plannedStartDate.tr,
            isRequired: false,
            selectedDate: controller.rxPlannedStartDate,
            onDateChanged: (date) {
              controller.rxPlannedStartDate = date!;
            },
          ),
          height(12),
          CustomDatePicker(
            label: plannedEndDate.tr,
            isRequired: false,
            selectedDate: controller.rxPlannedEndDate,
            onDateChanged: (date) {
              controller.rxPlannedEndDate = date!;
            },
          ),
        ],
      );
    });
  }

  SingleChildScrollView _horizontalDisplay() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _horizontalContainer(
              storyType.tr, controller.storyTiteController.text),
          width(10),
          _horizontalContainer(
              type.tr, controller.rxSelectedStoryType.value!.mccName ?? ""),
          width(10),
          _horizontalContainer(
              assignee.tr, controller.rxSelectedAsignee.value!.mccName ?? ""),
        ],
      ),
    );
  }

  Container _horizontalContainer(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 35,
      decoration: BoxDecoration(
          color: AppColorHelper().secondaryTextColor.withValues(alpha: 0.08),
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
