import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/create_token_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/view/widget/common_widget.dart';
import 'package:pmms/view/widget/dropdown/custom_dropdown.dart';
import 'package:pmms/view/widget/radiobutton/custom_radio_button.dart';
import 'package:pmms/view/widget/textfield/common_textfield.dart';
import 'package:pmms/view/widget/toggle/custom_toggle_button.dart';

class CreateTokenPage1 extends AppBaseView<CreateTokenController> {
  const CreateTokenPage1({super.key});

  @override
  Widget buildView() => _widgetView();

  Widget _widgetView() {
    return SizedBox(
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
                createTokenDialogue.tr,
                color: AppColorHelper().primaryTextColor,
                fontWeight: FontWeight.w400,
                fontSize: 13),
            height(4),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: divider(
                  color: AppColorHelper().borderColor.withValues(alpha: 0.5)),
            ),
            CustomDropdown<FiltersResponse>(
              label: project.tr,
              widgetHeight: 52,
              isRequired: true,
              items: controller.rxProjectsList,
              selectedValue: controller.rxSelectedProject.value,
              onChanged: (value) async {
                controller.rxSelectedProject.value = value;
                await controller.fetchProjectBasedDropdown(
                    controller.rxSelectedProject.value?.mccId ?? '',
                    "",
                    "",
                    true);
              },
              itemLabelBuilder: (item) => item.mccName ?? '',
            ),
            height(10),
            CustomRadioButton<FiltersResponse>(
              label: requestType.tr,
              widgetHeight: 35,
              widgetWidth: (Get.width / 3) - 20,
              isRequired: true,
              items: controller.rxRequestList,
              selectedValue: controller.rxSelectedRequest.value,
              onChanged: (value) {
                controller.rxSelectedRequest.value = value;
              },
              itemLabelBuilder: (item) =>
                  capitalizeFirstOnly(item.mccName ?? ''),
              itemIdBuilder: (item) => item.mccId,
              bgColor: AppColorHelper().primaryColor.withValues(alpha: 0.2),
              textColor: AppColorHelper().primaryColor,
            ),
            height(10),
            _descritpionField(),
            height(10),
            _moreDescriptionField(),
            height(16),
            CustomRadioButton<FiltersResponse>(
              label: priority.tr,
              widgetHeight: 35,
              isRequired: true,
              items: controller.rxPriorityList,
              selectedValue: controller.rxSelectedPriority.value,
              onChanged: (value) {
                controller.rxSelectedPriority.value = value;
              },
              itemLabelBuilder: (item) => item.mccName ?? '',
              itemIdBuilder: (item) => item.mccId,
              bgColor: _getPriorityColor(
                      controller.rxSelectedPriority.value?.mccName ?? "High")
                  .withValues(alpha: 0.2),
              textColor: _getPriorityTextColor(
                  controller.rxSelectedPriority.value?.mccName ?? "High"),
              borderColor: AppColorHelper().transparentColor,
              widgetWidth: 90,
            ),
          ],
        );
      }),
    );
  }

  Column _moreDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomToggleButton(
          label: addMoreDescription.tr,
          value: controller.rxToggle.value,
          onChanged: (val) => controller.rxToggle.value = val,
        ),
        height(10),

        /// Smooth iOS-style expand from top → bottom
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SizeTransition(
              sizeFactor: animation,
              axis: Axis.vertical,
              axisAlignment: -1.0, // 👈 makes it expand downward from top
              child: child,
            );
          },
          child: controller.rxToggle.value
              ? Column(
                  key: const ValueKey('expanded'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextfield(
                      label: description.tr,
                      controller: controller.additionaldescriptionController,
                      maxLines: 3,
                    ),
                    height(2),
                  ],
                )
              : const SizedBox(
                  key: ValueKey('collapsed'),
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
              tokenDescription.tr,
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

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return AppColorHelper().statusHighColor;
      case "medium":
        return AppColorHelper().statusMediumColor;
      case "low":
        return AppColorHelper().statusLowColor;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityTextColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return AppColorHelper().statusHighTextColor;
      case "medium":
        return AppColorHelper().statusMediumTextColor;
      case "low":
        return AppColorHelper().statusLowTextColor;
      default:
        return Colors.grey;
    }
  }
}
