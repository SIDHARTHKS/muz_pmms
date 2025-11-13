import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/view/login/bottomsheet/change_password_bottomsheet.dart';
import '../helper/core/base/app_base_controller.dart';
import '../service/auth_service.dart';

class ChangePasswordController extends AppBaseController {
  final AuthService _authService = Get.find<AuthService>();

  //new pass fields
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final FocusNode currentpasswordFocusNode = FocusNode();
  final FocusNode newpasswordFocusNode = FocusNode();
  final FocusNode confirmpasswordFocusNode = FocusNode();
  RxBool isSixChar = false.obs;
  RxBool isCaps = false.obs;
  RxBool isSpecial = false.obs;
  RxBool isdigits = false.obs;

  RxBool newPassVisible = false.obs;
  RxBool confirmNewPassVisible = false.obs;

  //

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void isValidPass(String value) {
    final pass = value.trim();

    // ✅ Must have at least 6 characters
    isSixChar(pass.length >= 6);

    // ✅ Must have both uppercase and lowercase letters
    final hasUpper = pass.contains(RegExp(r'[A-Z]'));
    final hasLower = pass.contains(RegExp(r'[a-z]'));
    isCaps(hasUpper && hasLower);

    // ✅ Must have at least one digit
    isdigits(pass.contains(RegExp(r'[0-9]')));

    // ✅ Must have at least one special character
    isSpecial(pass.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')));
  }

  void resetValidation() {
    isSixChar(false);
    isCaps(false);
    isdigits(false);
    isSpecial(false);
  }

  void toggleVisibility() {
    newPassVisible.value = !newPassVisible.value;
  }

  Future<bool> callChangePassword() async {
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent, // Prevents the default white shade
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        return Padding(
          // This padding pushes the sheet up when the keyboard appears
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: SizedBox(
              height: Platform.isAndroid
                  ? (Get.height * 0.82)
                  : (Get.height * 0.82), // e.g., 75% of screen height
              child: const ChangePasswordBottomsheet(),
            ),
          ),
        );
      },
    );
    return true;
  }
}
