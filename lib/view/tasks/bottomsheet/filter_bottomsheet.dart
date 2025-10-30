import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/date_helper.dart';
import 'package:pmms/view/widget/datepicker/custom_daterangepicker.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/navigation.dart';
import '../../../helper/sizer.dart';
import '../../widget/common_widget.dart';

class FilterBottomsheet extends StatefulWidget {
  const FilterBottomsheet({super.key});

  @override
  State<FilterBottomsheet> createState() => _FilterBottomsheetState();
}

class _FilterBottomsheetState extends State<FilterBottomsheet> {
  final TasksController controller = Get.find<TasksController>();
  final appColor = AppColorHelper();

  // local temp map to store selected items (copied from controller)
  late Map<String, RxList<String>> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = {
      "Token Type": RxList<String>.from(controller.rxSelectedTokenTypes),
      "Project": RxList<String>.from(controller.rxSelectedProjects),
      "Priority": RxList<String>.from(controller.rxSelectedPriority),
      "Request Type": RxList<String>.from(controller.rxSelectedRequestTypes),
    };
  }

  void _toggleSelection(String group, String value) {
    final list = selectedItems[group]!;
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    setState(() {});
  }

  Widget _buildCheckboxOption(String group, String option, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleSelection(group, option),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7.5),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: isSelected
                    ? appColor.primaryColor
                    : appColor.primaryColor.withValues(alpha: 0.01),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isSelected
                      ? appColor.primaryColor
                      : appColor.primaryColor.withValues(alpha: 0.1),
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
            width(12),
            Expanded(
              child: appText(
                option,
                color: appColor.primaryTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    final selectedGroup = selectedItems[title] ?? RxList<String>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height(10),
        Divider(
            color: appColor.dividerColor.withValues(alpha: 0.2), thickness: 1),
        height(10),
        appText(title,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColorHelper().primaryTextColor.withValues(alpha: 0.65)),
        height(8),
        Column(
          children: options.map((option) {
            final isSelected = selectedGroup.contains(option);
            return _buildCheckboxOption(title, option, isSelected);
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = {
      "Token Type": controller.tokenTypes,
      "Project": controller.projects,
      "Priority": controller.priority,
      "Request Type": controller.requestTypes,
    };

    return Container(
      width: Get.width,
      height: Get.height * 0.86,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: appColor.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText("Filter Tokens",
                    color: appColor.primaryTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColorHelper().primaryColor),
                  child: iconWidget(Icons.close,
                      color: appColor.textColor, onPressed: goBack),
                ),
              ],
            ),
          ),
          height(8),
          Divider(
              color: appColor.dividerColor.withValues(alpha: 0.3),
              thickness: 1),

          // Date Range
          height(10),
          appText("Date Range",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColorHelper().primaryTextColor.withValues(alpha: 0.65)),
          height(15),
          GestureDetector(
            onTap: () async {
              final selectedRange = await showCustomDateRangePicker(
                context,
                primaryColor: AppColorHelper().primaryColor,
                backgroundColor: AppColorHelper().cardColor,
                textColor: AppColorHelper().primaryTextColor,
                initialRange: DateTimeRange(
                  start: controller.selectedDateRange!.start,
                  end: controller.selectedDateRange!.end,
                ),
              );

              if (selectedRange != null) {
                setState(() {
                  controller.selectedDateRange = selectedRange;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: appColor.cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: appColor.borderColor.withValues(alpha: 0)),
              ),
              child: Row(
                children: [
                  Image.asset(
                    Assets.icons.calander.path,
                    scale: 3.6,
                  ),
                  width(15),
                  appText(
                      "${DateHelper().formatDate(controller.selectedDateRange!.start)}  -  ${DateHelper().formatDate(controller.selectedDateRange!.end)}", //"01 August 2025  -  31 September 2025"
                      color: appColor.primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ],
              ),
            ),
          ),

          // Filters List
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: filters.entries
                    .map((entry) => _buildFilterSection(entry.key, entry.value))
                    .toList(),
              ),
            ),
          ),

          // Apply Button
          height(10),
          buttonContainer(
            color: appColor.primaryColor,
            appText("Apply Filters",
                fontWeight: FontWeight.w500, color: AppColorHelper().textColor),
            onPressed: () {
              controller.rxSelectedTokenTypes
                  .assignAll(selectedItems["Token Type"]!);
              controller.rxSelectedProjects
                  .assignAll(selectedItems["Project"]!);
              controller.rxSelectedPriority
                  .assignAll(selectedItems["Priority"]!);
              controller.rxSelectedRequestTypes
                  .assignAll(selectedItems["Request Type"]!);

              goBack();
            },
            height: 42,
            width: double.infinity,
          ),
          height(5),
        ],
      ),
    );
  }
}
