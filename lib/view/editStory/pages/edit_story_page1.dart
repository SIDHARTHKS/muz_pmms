import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/edit_story_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/view/widget/common_widget.dart';
import 'package:pmms/view/widget/dropdown/custom_dropdown.dart';
import 'package:pmms/view/widget/textfield/common_textfield.dart';
import 'package:pmms/view/widget/textfield/timefield.dart';

import '../../widget/datepicker/custom_datepicker.dart';

class EditStoryPage1 extends AppBaseView<EditStoryController> {
  const EditStoryPage1({super.key});

  @override
  Widget buildView() => _widgetView();

  Widget _widgetView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        child: SizedBox(
          width: Get.width,
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                height(6),
                _descritpionField(),
                height(12),
                CustomDropdown<FiltersResponse>(
                  label: storyType.tr,
                  widgetHeight: 52,
                  isRequired: true,
                  items: controller.rxStoryTypeList,
                  selectedValue: controller.rxSelectedStoryType.value,
                  onChanged: (value) async {
                    controller.rxSelectedStoryType.value = value;
                    await controller.fetchAssignee();
                  },
                  itemLabelBuilder: (item) => item.mccName ?? '',
                ),
                height(12),
                CustomDropdown<DropDownResponse>(
                  label: assignee.tr,
                  widgetHeight: 52,
                  isRequired: true,
                  items: controller.rxAssigneeList,
                  selectedValue: controller.rxSelectedAsignee.value,
                  onChanged: (value) {
                    controller.rxSelectedAsignee.value = value;
                  },
                  itemLabelBuilder: (item) => item.name ?? '',
                ),
                height(12),
                _timeSelector(),
                height(18),
                CustomDatePicker(
                  widgetHeight: 55,
                  label: ogStartDate.tr,
                  isRequired: false,
                  selectedDate: controller.rxPlannedStartDate.value,
                  onDateChanged: (date) {
                    controller.rxPlannedStartDate.value = date!;
                  },
                ),
                height(18),
                CustomDatePicker(
                  widgetHeight: 55,
                  label: ogEndDate.tr,
                  isRequired: false,
                  selectedDate: controller.rxPlannedEndDate.value,
                  onDateChanged: (date) {
                    controller.rxPlannedEndDate.value = date!;
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Column _timeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            width(2),
            appText(
              estimateTime.tr,
              fontSize: 13,
              color: AppColorHelper().lightTextColor,
              fontWeight: FontWeight.w400,
            ),
            appText(
              " *",
              color: AppColorHelper().errorColor,
              fontSize: 18,
            ),
          ],
        ),
        height(2),
        SizedBox(
          width: 170,
          child: Row(
            children: [
              Timefield(
                  controller1: controller.hoursController,
                  controller2: controller.minutesController)
            ],
          ),
        ),
      ],
    );
  }

  Column _descritpionField() {
    return Column(
      children: [
        Row(
          children: [
            width(2),
            appText(
              shortDescription.tr,
              fontSize: 13,
              color: AppColorHelper().lightTextColor,
              fontWeight: FontWeight.w400,
            ),
            appText(
              " *",
              color: AppColorHelper().errorColor,
              fontSize: 18,
            ),
          ],
        ),
        height(2),
        CommonTextfield(
          label: description.tr,
          controller: controller.descriptionController,
          maxLines: 3,
        )
      ],
    );
  }
}
