import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/edit_token_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/model/dropdown_model.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/navigation.dart';
import '../../../helper/sizer.dart';
import '../../widget/common_widget.dart';

class EditDropdownBottomsheet extends StatefulWidget {
  final String label;
  final List<DropDownResponse> list;
  final DropDownResponse selectedItem;

  const EditDropdownBottomsheet({
    super.key,
    required this.label,
    required this.list,
    required this.selectedItem,
  });

  @override
  State<EditDropdownBottomsheet> createState() => _FilterBottomsheetState();
}

class _FilterBottomsheetState extends State<EditDropdownBottomsheet> {
  final EditTokenController controller = Get.find<EditTokenController>();
  final appColor = AppColorHelper();

  // local temp map to store selected items (copied from controller)
  late DropDownResponse selectedItem;

  @override
  void initState() {
    selectedItem = widget.selectedItem;
    super.initState();
  }

  void _changeSelection(DropDownResponse value) {
    selectedItem = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double estimatedHeight = (widget.list.length * 70) + 150;
    double maxHeight = Get.height * 0.7;
    double sheetHeight =
        estimatedHeight > maxHeight ? maxHeight : estimatedHeight;
    return Container(
      width: Get.width,
      height: sheetHeight,
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
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
                appText(widget.label,
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

          Divider(
              color: appColor.dividerColor.withValues(alpha: 0.3),
              thickness: 1),
          height(10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                var item = widget.list[index];
                bool isSelected = item.name!.toLowerCase() ==
                    selectedItem.name!.toLowerCase();
                return GestureDetector(
                  onTap: () => _changeSelection(item),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.only(
                        left: 15, right: 5, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? appColor.primaryColor.withValues(alpha: 0.2)
                          : appColor.cardColor,
                      borderRadius: BorderRadius.circular(4),
                      // border: Border.all(
                      //   color: isSelected
                      //       ? appColor.primaryColor
                      //       : appColor.borderColor.withValues(alpha: 0.3),
                      //   width: 1,
                      // ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        appText(
                          item.name!,
                          color: isSelected
                              ? appColor.primaryColor
                              : appColor.primaryTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        Icon(Icons.check_rounded,
                            color: isSelected
                                ? appColor.primaryColor
                                : Colors.transparent),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          _button(),
        ],
      ),
    );
  }

  SafeArea _button() {
    return SafeArea(
      child: buttonContainer(
        onPressed: () {
          Navigator.pop(context, selectedItem);
        },
        color: appColor.primaryColor,
        appText(apply.tr,
            fontWeight: FontWeight.w500, color: AppColorHelper().textColor),
        width: double.infinity,
      ),
    );
  }
}
