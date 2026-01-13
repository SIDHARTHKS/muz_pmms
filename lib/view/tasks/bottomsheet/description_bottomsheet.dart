import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/edit_token_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/common_widget.dart';
import 'package:pmms/view/widget/text/app_text.dart';

class DescriptionBottomSheet extends StatelessWidget {
  final EditTokenController _editTokenController =
      Get.find<EditTokenController>();

  final String title;
  final String hintText;
  final TextEditingController? controller;
  final VoidCallback onClose;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSave;

  DescriptionBottomSheet({
    super.key,
    required this.title,
    required this.hintText,
    required this.onClose,
    required this.onSave,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: AppColorHelper().cardColor,
        ),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appText(
                      title,
                      color: AppColorHelper().primaryTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColorHelper().primaryColor,
                      ),
                      child: iconWidget(
                        Icons.close,
                        color: AppColorHelper().textColor,
                        onPressed: onClose,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                color: AppColorHelper().dividerColor.withValues(alpha: 0.3),
                thickness: 1,
              ),
              height(10),

              TextField(
                autofocus: true,
                controller: controller,
                decoration: _normalFieldDecoration(),
                maxLines: 3,
                onChanged: onChanged,
                style: textStyle(
                    14, AppColorHelper().primaryTextColor, FontWeight.w500),
              ),
              height(15),
              SafeArea(
                  child: _editTokenController.rxDescriptionChanged.value
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: buttonContainer(
                              onPressed: onSave,
                              color: AppColorHelper().primaryColor,
                              appText(
                                save.tr,
                                color: AppColorHelper().textColor,
                                fontWeight: FontWeight.w500,
                              )),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: buttonContainer(
                              color: AppColorHelper()
                                  .primaryColor
                                  .withValues(alpha: 0.5),
                              appText(
                                save.tr,
                                color: AppColorHelper().textColor,
                                fontWeight: FontWeight.w500,
                              )),
                        ))
            ],
          );
        }),
      ),
    );
  }

  InputDecoration _normalFieldDecoration() => InputDecoration(
        contentPadding: const EdgeInsets.all(8),
        border:
            _border(color: AppColorHelper().borderColor.withValues(alpha: 0.5)),
        labelText: '',
        counterText: '',
        hintText: '',
        enabledBorder:
            _border(color: AppColorHelper().borderColor.withValues(alpha: 0.5)),
        disabledBorder:
            _border(color: AppColorHelper().borderColor.withValues(alpha: 0.5)),
        errorBorder: _border(color: AppColorHelper().errorColor),
        focusedBorder:
            _border(color: AppColorHelper().borderColor.withValues(alpha: 0.5)),
        filled: true,
        fillColor: AppColorHelper().cardColor,
        errorStyle: TextStyle(color: AppColorHelper().errorColor),
      );
  _border({required Color color}) => OutlineInputBorder(
        borderSide: _borderSide(color: color),
        borderRadius: _borderRadius(),
      );
  _borderSide({required Color color}) => BorderSide(color: color);
  _borderRadius() => BorderRadius.circular(6);
}
