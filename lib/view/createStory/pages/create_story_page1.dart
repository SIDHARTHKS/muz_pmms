import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/create_story_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/view/widget/common_widget.dart';
import 'package:pmms/view/widget/dropdown/custom_dropdown.dart';
import 'package:pmms/view/widget/textfield/common_textfield.dart';
import 'package:pmms/view/widget/textfield/timefield.dart';

class CreateStoryPage1 extends AppBaseView<CreateStoryController> {
  const CreateStoryPage1({super.key});

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
                height(16),
                appText(letsstartwiththebasics.tr,
                    color: AppColorHelper().primaryTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
                height(5),
                appText(
                    height: 1.6,
                    createStoryDialogue.tr,
                    color: AppColorHelper().primaryTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 13),
                height(20),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 2),
                  child: divider(
                      color:
                          AppColorHelper().borderColor.withValues(alpha: 0.5)),
                ),
                _storyTitleField(),
                height(12),
                _descritpionField(),
                height(12),
                CustomDropdown<FiltersResponse>(
                  label: storyType.tr,
                  widgetHeight: 52,
                  isRequired: true,
                  items: controller.rxStoryTypeList,
                  selectedValue: controller.rxSelectedStoryType.value,
                  onChanged: (value) {
                    controller.rxSelectedStoryType.value = value;
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
                _timeSelector()
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

  Column _storyTitleField() {
    return Column(
      children: [
        Row(
          children: [
            width(2),
            appText(
              storyTitle.tr,
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
          height: 35,
          child: CommonTextfield(
            label: "",
            controller: controller.storyTiteController,
            maxLines: 1,
          ),
        )
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
