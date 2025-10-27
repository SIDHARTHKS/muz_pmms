import 'package:flutter/material.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/view/widget/text/app_text.dart';

class CommonTextfield extends StatelessWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final TextInputType inputType;
  final bool readOnly;
  final Function(String)? onChanged;

  const CommonTextfield({
    super.key,
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.hintText,
    this.maxLines = 1,
    this.inputType = TextInputType.text,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColor = AppColorHelper();

    return TextField(
      controller: controller,
      keyboardType: inputType,
      readOnly: readOnly,
      maxLines: maxLines,
      onChanged: onChanged,
      style: textStyle(12, AppColorHelper().primaryTextColor, FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textStyle(
            13,
            AppColorHelper().primaryTextColor.withValues(alpha: 0.5),
            FontWeight.w500),
        filled: true,
        fillColor: AppColorHelper().cardColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: appColor.borderColor.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: appColor.borderColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
