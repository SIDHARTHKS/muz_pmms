import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:pmms/view/tasks/bottomsheet/filter_bottomsheet.dart';
import '../../../gen/assets.gen.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/core/environment/env.dart';
import '../../../helper/enum.dart';
import '../text/app_text.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? action;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onSubmit,
    this.validator,
    this.action,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool showClear = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateClearButton);
  }

  void _updateClearButton() {
    setState(() {
      showClear = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearButton);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = AppEnvironment.deviceType == UserDeviceType.tablet;
    return Container(
      color: AppColorHelper().cardColor,
      child: TextFormField(
        controller: widget.controller,
        textInputAction: TextInputAction.search,
        // keyboardType: TextInputType.number,
        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onFieldSubmitted: widget.onSubmit,
        onChanged: widget.onChanged,
        validator: widget.validator,
        decoration: InputDecoration(
          fillColor: AppColorHelper().cardColor,
          hintText: widget.hintText.tr,
          hintStyle: textStyle(
            isTablet ? 18 : 14,
            AppColorHelper().primaryTextColor.withOpacity(0.5),
            FontWeight.w500,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Image.asset(
              Assets.icons.search.path,
              scale: 3,
              color: AppColorHelper().primaryTextColor.withValues(alpha: 0.4),
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: const FilterBottomsheet(),
                  );
                },
              );
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Image.asset(Assets.icons.filter.path)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: AppColorHelper().borderColor.withOpacity(0.4),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: BorderSide(
              color: AppColorHelper().borderColor.withOpacity(0.7),
              width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: BorderSide(
              color: AppColorHelper().borderColor.withOpacity(0.6),
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
