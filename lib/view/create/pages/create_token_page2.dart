import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';
import 'package:pmms/controller/create_token_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/common_widget.dart';
import 'package:pmms/view/widget/text/app_text.dart';

import '../../../model/dropdown_model.dart';
import '../../widget/dropdown/custom_dropdown.dart';

class CreateTokenPage2 extends AppBaseView<CreateTokenController> {
  const CreateTokenPage2({super.key});

  @override
  Widget buildView() => _widgetView();

  Widget _widgetView() {
    return Obx(() {
      return Column(
        children: [
          _selectedDetailsSection(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
            child: divider(
                color: AppColorHelper().dividerColor.withValues(alpha: 0.2)),
          ),
          CustomDropdown<CommonDropdownResponse>(
            label: team.tr,
            widgetHeight: 53,
            isRequired: false,
            items: controller.teamList,
            selectedValue: controller.rxSelectedTeam.value,
            onChanged: (value) {
              controller.rxSelectedTeam.value = value;
            },
            itemLabelBuilder: (item) => item.mccName ?? '',
          ),
          height(15),
          CustomDropdown<CommonDropdownResponse>(
            label: module.tr,
            widgetHeight: 53,
            isRequired: false,
            items: controller.moduleList,
            selectedValue: controller.rxSelectedModule.value,
            onChanged: (value) {
              controller.rxSelectedModule.value = value;
            },
            itemLabelBuilder: (item) => item.mccName ?? '',
          ),
          height(15),
          CustomDropdown<CommonDropdownResponse>(
            label: option.tr,
            widgetHeight: 53,
            isRequired: false,
            items: controller.optionList,
            selectedValue: controller.rxSelectedOption.value,
            onChanged: (value) {
              controller.rxSelectedOption.value = value;
            },
            itemLabelBuilder: (item) => item.mccName ?? '',
          ),
          height(15),
          CustomDropdown<CommonDropdownResponse>(
            label: assignee.tr,
            widgetHeight: 53,
            isRequired: false,
            items: controller.assigneeList,
            selectedValue: controller.rxSelectedAsignee.value,
            onChanged: (value) {
              controller.rxSelectedAsignee.value = value;
            },
            itemLabelBuilder: (item) => item.mccName ?? '',
          )
        ],
      );
    });
  }

  Row _selectedDetailsSection() {
    return Row(
      children: [
        _selectedContainer(
            project.tr, controller.rxSelectedProject.value?.mccName ?? "--"),
        width(10),
        _selectedContainer(
            type.tr, controller.rxSelectedRequest.value?.mccName ?? "--")
      ],
    );
  }

  Container _selectedContainer(String heading, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColorHelper().circleAvatarBgColor,
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$heading : ",
                  style: textStyle(
                    13,
                    AppColorHelper().lightTextColor,
                    FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: textStyle(
                    13,
                    AppColorHelper().primaryTextColor, // slightly darker
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
