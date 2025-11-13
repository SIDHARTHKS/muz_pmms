import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/change_password_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/view/dialogues/success_dialogue.dart';
import 'package:pmms/view/widget/textformfield/app_textformfield_widget.dart';
import '../../helper/color_helper.dart';
import '../../helper/route.dart';
import '../../helper/sizer.dart';
import '../widget/common_widget.dart';

class ChangePasswordScreen extends AppBaseView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(canpop: true, body: _body());
  GestureDetector _body() {
    final formKey = GlobalKey<FormState>();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: appScaffold(
        appBar: customAppBar(changePass.tr),
        body: appContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Form(
              key: formKey,
              child: Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height(15),
                    appText(
                      passwordDialogue.tr,
                      textAlign: TextAlign.left,
                      color: AppColorHelper().primaryTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    height(30),
                    _buildCurrentPassField(),
                    height(22),
                    _buildNewPassField(),
                    height(22),
                    _buildConfirmNewPassField(),
                    height(20),
                    appText(
                      passwordMustContain,
                      textAlign: TextAlign.left,
                      color: AppColorHelper().primaryTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                    height(15),
                    Row(
                      children: [
                        _checkbox(controller.isSixChar),
                        width(8),
                        appText(
                          sixChar.tr,
                          textAlign: TextAlign.left,
                          color: controller.isSixChar.value
                              ? AppColorHelper().primaryTextColor
                              : AppColorHelper()
                                  .primaryTextColor
                                  .withValues(alpha: 0.7),
                          fontWeight: controller.isSixChar.value
                              ? FontWeight.w500
                              : FontWeight.w400,
                          fontSize: 13,
                        ),
                      ],
                    ),
                    height(10),
                    Row(
                      children: [
                        _checkbox(controller.isCaps),
                        width(8),
                        appText(
                          capitalAndSmall.tr,
                          textAlign: TextAlign.left,
                          color: controller.isCaps.value
                              ? AppColorHelper().primaryTextColor
                              : AppColorHelper()
                                  .primaryTextColor
                                  .withValues(alpha: 0.7),
                          fontWeight: controller.isCaps.value
                              ? FontWeight.w500
                              : FontWeight.w400,
                          fontSize: 13,
                        ),
                      ],
                    ),
                    height(10),
                    Row(
                      children: [
                        _checkbox(controller.isSpecial),
                        width(8),
                        appText(
                          specialChar.tr,
                          textAlign: TextAlign.left,
                          color: controller.isSpecial.value
                              ? AppColorHelper().primaryTextColor
                              : AppColorHelper()
                                  .primaryTextColor
                                  .withValues(alpha: 0.7),
                          fontWeight: controller.isSpecial.value
                              ? FontWeight.w500
                              : FontWeight.w400,
                          fontSize: 13,
                        ),
                      ],
                    ),
                    height(10),
                    Row(
                      children: [
                        _checkbox(controller.isdigits),
                        width(10),
                        appText(
                          digits.tr,
                          textAlign: TextAlign.left,
                          color: controller.isdigits.value
                              ? AppColorHelper().primaryTextColor
                              : AppColorHelper()
                                  .primaryTextColor
                                  .withValues(alpha: 0.7),
                          fontWeight: controller.isdigits.value
                              ? FontWeight.w500
                              : FontWeight.w400,
                          fontSize: 13,
                        ),
                      ],
                    ),
                    const Spacer(),
                    buttonContainer(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // ✅ Show success dialog
                          controller.resetValidation();
                          await showDialog(
                            context: Get.context!,
                            barrierDismissible:
                                false, // prevents user from closing early
                            builder: (_) => const SuccessDialogue(
                              title: passwordresetSuccessfully,
                              subtitle: passwordresetSuccessfullyDialogue,
                            ),
                          );

                          // ✅ Navigate after dialog auto-dismisses
                          navigateToAndRemoveAll(loginPageRoute);
                        }
                      },
                      color: AppColorHelper().primaryColor,
                      appText(
                        updatePass.tr,
                        color: AppColorHelper().textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    height(10),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkbox(RxBool condition) {
    return Obx(() {
      return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: condition.value
              ? AppColorHelper().checkColor
              : AppColorHelper().primaryColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: condition.value
            ? Center(
                child: Icon(
                  CupertinoIcons.check_mark,
                  color: AppColorHelper().textColor,
                  size: 12,
                ),
              )
            : null,
      );
    });
  }

  /// Current Password Field with validation
  Widget _buildCurrentPassField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(
          currentPass.tr,
          color: AppColorHelper().primaryTextColor.withValues(alpha: 0.6),
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        height(4),
        Container(
          padding: const EdgeInsets.only(top: 7.0, bottom: 7.0, left: 8.0),
          decoration: BoxDecoration(
            color: AppColorHelper().cardColor,
            border: Border.all(
                color: AppColorHelper().borderColor.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextFormWidget(
            height: 40,
            focusNode: controller.currentpasswordFocusNode,
            controller: controller.currentPasswordController,
            floatType: FloatingLabelBehavior.never,
            borderColor: AppColorHelper().transparentColor,
            textColor: AppColorHelper().primaryTextColor,
            label: "",
            enableObscureToggle: true,
            localObscure: controller.newPassVisible.value,
            nextFocusNode: controller.confirmpasswordFocusNode,
          ),
        ),
      ],
    );
  }

  /// New Password Field with validation
  Widget _buildNewPassField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(
          newPass.tr,
          color: AppColorHelper().primaryTextColor.withValues(alpha: 0.6),
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        height(4),
        Container(
          padding: const EdgeInsets.only(top: 7.0, bottom: 7.0, left: 8.0),
          decoration: BoxDecoration(
            color: AppColorHelper().cardColor,
            border: Border.all(
                color: AppColorHelper().borderColor.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextFormWidget(
            height: 40,
            focusNode: controller.newpasswordFocusNode,
            controller: controller.newPasswordController,
            floatType: FloatingLabelBehavior.never,
            borderColor: AppColorHelper().transparentColor,
            textColor: AppColorHelper().primaryTextColor,
            label: "",
            onChanged: (value) {
              controller.isValidPass(value);
            },
            enableObscureToggle: true,
            localObscure: controller.newPassVisible.value,
            nextFocusNode: controller.confirmpasswordFocusNode,
          ),
        ),
      ],
    );
  }

  /// Confirm New Password Field
  Widget _buildConfirmNewPassField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(
          confirmNewPass.tr,
          color: AppColorHelper().primaryTextColor.withValues(alpha: 0.6),
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        height(4),
        Container(
          padding: const EdgeInsets.only(top: 7.0, bottom: 7.0, left: 8.0),
          decoration: BoxDecoration(
            color: AppColorHelper().cardColor,
            border: Border.all(
                color: AppColorHelper().borderColor.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextFormWidget(
            height: 40,
            focusNode: controller.confirmpasswordFocusNode,
            controller: controller.confirmNewPasswordController,
            floatType: FloatingLabelBehavior.never,
            borderColor: AppColorHelper().transparentColor,
            textColor: AppColorHelper().primaryTextColor,
            enableObscureToggle: true,
            localObscure: controller.confirmNewPassVisible.value,
            label: "",
          ),
        ),
      ],
    );
  }
}
