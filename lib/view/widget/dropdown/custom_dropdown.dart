import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/common_widget.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String label;
  final bool isRequired;
  final List<T> items;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabelBuilder;
  final String? hintText;
  final double? widgetHeight;
  final Color? selectionColor;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.selectedValue,
    this.isRequired = false,
    this.hintText,
    this.widgetHeight,
    this.selectionColor,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorHelper();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            width(2),
            appText(
              widget.label,
              fontSize: 13,
              color: colors.primaryTextColor.withOpacity(0.6),
              fontWeight: FontWeight.w400,
            ),
            if (widget.isRequired)
              appText(
                " *",
                color: Colors.red,
                fontSize: 18,
              ),
          ],
        ),
        height(2),

        // Dropdown container
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.widgetHeight ?? 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.cardColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _isOpen
                  ? colors.primaryColor.withOpacity(0.8)
                  : colors.borderColor.withOpacity(0.4),
              width: _isOpen ? 1.2 : 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              isExpanded: true,
              value: widget.selectedValue,
              hint: appText(
                widget.hintText ?? "Select ${widget.label}",
                color: colors.primaryTextColor.withOpacity(0.4),
                fontWeight: FontWeight.w400,
              ),
              iconStyleData: IconStyleData(
                icon: AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: colors.primaryTextColor.withOpacity(0.8),
                  ),
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 250,
                width: Get.width * 0.92,
                elevation: 1,
                offset: const Offset(-12, 0), // dropdown appears just below
                decoration: BoxDecoration(
                  color: colors.cardColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: colors.borderColor.withOpacity(0.3),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20), // ✅ horizontal padding for dropdown
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 42,
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
              items: widget.items.map((item) {
                final isSelected = item == widget.selectedValue;
                return DropdownMenuItem<T>(
                  value: item,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (widget.selectionColor ??
                              colors.primaryColor.withOpacity(0.0))
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: appText(
                      widget.itemLabelBuilder(item),
                      color: colors.primaryTextColor,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                widget.onChanged(val);
                setState(() => _isOpen = false);
              },
              onMenuStateChange: (isOpen) {
                setState(() => _isOpen = isOpen);
              },
            ),
          ),
        ),
      ],
    );
  }
}
