import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/create_token_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/view/widget/datepicker/custom_datepicker.dart';
import 'package:pmms/view/widget/text/app_text.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/sizer.dart';
import '../../../model/dropdown_model.dart';
import '../../widget/common_widget.dart';
import '../../widget/dropdown/custom_dropdown.dart';

class CreateTokenPage3 extends AppBaseView<CreateTokenController> {
  const CreateTokenPage3({super.key});

  @override
  Widget buildView() => _widgetView();

  Widget _widgetView() {
    return Obx(() {
      return Column(
        children: [
          _selectedDetailsSection(),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 6.0),
            child: divider(
                color: AppColorHelper().dividerColor.withValues(alpha: 0.2)),
          ),
          CustomDropdown<CommonDropdownResponse>(
            label: clientRefID.tr,
            widgetHeight: 53,
            isRequired: false,
            items: controller.clientRefIdList,
            selectedValue: controller.rxSelectedClientId.value,
            onChanged: (value) {
              controller.rxSelectedClientId.value = value;
            },
            itemLabelBuilder: (item) => item.mccName ?? '',
          ),
          height(15),
          CustomDropdown<CommonDropdownResponse>(
            label: requestBy.tr,
            widgetHeight: 53,
            isRequired: false,
            items: controller.requestedByList,
            selectedValue: controller.rxSelectedRequestedBy.value,
            onChanged: (value) {
              controller.rxSelectedRequestedBy.value = value;
            },
            itemLabelBuilder: (item) => item.mccName ?? '',
          ),
          height(15),
          CustomDatePicker(
            label: requestOn.tr,
            isRequired: false,
            selectedDate: controller.rxRequestedOn,
            onDateChanged: (date) {
              controller.rxRequestedOn = date!;
            },
          ),
          height(15),
          CustomDatePicker(
            label: dueDate.tr,
            isRequired: false,
            selectedDate: controller.rxRequestedOn,
            onDateChanged: (date) {
              controller.rxRequestedOn = date!;
            },
          ),
          height(15),
          SizedBox(
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appText(attachments.tr,
                    color: AppColorHelper()
                        .primaryTextColor
                        .withValues(alpha: 0.7),
                    fontSize: 14),
                height(5),
                Row(
                  children: [
                    Container(
                      width: 78,
                      height: 88,
                      decoration: BoxDecoration(
                          color: AppColorHelper().circleAvatarBgColor,
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Icon(
                          Icons.add_rounded,
                          size: 35,
                          color: AppColorHelper()
                              .primaryTextColor
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
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
