import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:pmms/view/tasks/bottomsheet/filter_token_bottomsheet.dart';
import '../../../gen/assets.gen.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/core/environment/env.dart';
import '../../../helper/enum.dart';
import '../../tasks/bottomsheet/filter_story_bottomsheet.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? action;
  final bool isToken;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isToken,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColorHelper().cardColor,
      ),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
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
          hintStyle: TextStyle(
            letterSpacing: 0,
            fontSize: isTablet ? 16 : 13,
            color: AppColorHelper().primaryTextColor.withOpacity(0.6),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Image.asset(
              Assets.icons.search.path,
              scale: 3.8,
              color: AppColorHelper().primaryTextColor.withValues(alpha: 0.4),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 30,
            minHeight: 30,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 0, // reduce left/right padding
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
                    child: widget.isToken
                        ? const FilterTokenBottomsheet()
                        : const FilterStoryBottomsheet(),
                  );
                },
              );
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
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
