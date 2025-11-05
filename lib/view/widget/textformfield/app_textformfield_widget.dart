// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import '../../../helper/color_helper.dart';
import '../common_widget.dart';
import '../text/app_text.dart';

class TextFormWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? nextFocusNode;
  final VoidCallback? onFieldSubmitted;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool optional;
  final FocusNode? focusNode;
  final Function(String)? onTextChanged;
  final Function(String)? onChanged;
  final IconData? prefixIcon;
  final String? prefixText;
  final Color? prefixIconColor;
  final IconData? suffixIcon;
  final String? suffixText;
  final VoidCallback? suffixIconPressed;
  final bool readOnly;
  final TextAlign textAlign;
  final Color? textColor;
  final RxBool? rxEnabled;
  final RxBool? rxObscureText; // <-- Reactive field
  final double? height;
  final bool digitsOnly;
  final VoidCallback? ontap;
  final Color? borderColor;
  final Widget? prefixIconWidget;
  final List<TextInputFormatter>? inputFormatters;
  final bool showcursor;

  const TextFormWidget({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.nextFocusNode,
    this.onFieldSubmitted,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.optional = false,
    this.focusNode,
    this.onTextChanged,
    this.onChanged,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.suffixIconPressed,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.textColor,
    this.height,
    this.digitsOnly = false,
    this.rxEnabled,
    this.rxObscureText, // <-- Reactive field
    this.ontap,
    this.borderColor,
    this.prefixIconWidget,
    this.inputFormatters,
    this.showcursor = true,
  });

  @override
  Widget build(BuildContext context) {
    final Debouncer debouncer =
        Debouncer(delay: const Duration(milliseconds: 500));

    return Obx(() {
      final bool isEnabled = rxEnabled?.value ?? true;
      final bool obscure = rxObscureText?.value ?? false;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height,
            child: TextFormField(
              showCursor: showcursor,
              obscureText: obscure,
              enabled: isEnabled,
              readOnly: readOnly,
              focusNode: focusNode,
              controller: controller,
              maxLines: maxLines,
              minLines: minLines,
              maxLength: maxLength,
              decoration: _normalFieldDecoration(),
              validator: validator,
              textAlign: textAlign,
              style: textStyle(
                  14, AppColorHelper().primaryTextColor, FontWeight.w500),
              textInputAction: nextFocusNode != null
                  ? TextInputAction.next
                  : TextInputAction.done,
              inputFormatters: inputFormatters,
              onChanged: (value) {
                debouncer.call(() {
                  onTextChanged?.call(value);
                  onChanged?.call(value);
                });
              },
              onFieldSubmitted: (_) {
                if (nextFocusNode != null) {
                  FocusScope.of(context).requestFocus(nextFocusNode);
                }
                onFieldSubmitted?.call();
              },
            ),
          ),
        ],
      );
    });
  }

  InputDecoration _normalFieldDecoration() => InputDecoration(
        labelText: label,
        labelStyle: textStyle(
            15,
            AppColorHelper().primaryTextColor.withValues(alpha: 0.7),
            FontWeight.w400),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border:
            _border(color: borderColor ?? AppColorHelper().transparentColor),
        enabledBorder:
            _border(color: borderColor ?? AppColorHelper().transparentColor),
        focusedBorder: _border(color: AppColorHelper().transparentColor),
        contentPadding: EdgeInsets.zero,
        counterText: '',
        prefixIcon: _getPrefixIcon(),
        suffixIcon: _getSuffixIcon(),
      );

  Widget? _getSuffixIcon() {
    if (suffixText != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 20),
        child: GestureDetector(
          onTap: ontap,
          child: appText(
            suffixText!,
            color: AppColorHelper().textColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
    return suffixIcon != null
        ? IconButton(
            icon: Icon(suffixIcon, color: AppColorHelper().iconColor),
            onPressed: suffixIconPressed,
          )
        : null;
  }

  Widget? _getPrefixIcon() {
    if (prefixIconWidget != null) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(height: 10, width: 10, child: prefixIconWidget),
      );
    }

    if (prefixText != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 20),
        child: appText(prefixText!,
            color: AppColorHelper().primaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      );
    }

    return prefixIcon != null
        ? Icon(prefixIcon, color: prefixIconColor ?? AppColorHelper().iconColor)
        : null;
  }

  OutlineInputBorder _border({required Color color}) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1.2),
        borderRadius: BorderRadius.circular(8),
      );
}
