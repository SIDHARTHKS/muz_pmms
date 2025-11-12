import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/view/login/bottomsheet/change_password_bottomsheet.dart';
import '../helper/app_message.dart';
import '../helper/app_string.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/core/environment/env.dart';
import '../helper/deviceInfo.dart';
import '../helper/enum.dart';
import '../helper/shared_pref.dart';
import '../model/app_model.dart';
import '../model/login_model.dart';
import '../service/auth_service.dart';

class LoginController extends AppBaseController {
  final AuthService _authService = Get.find<AuthService>();

  late SharedPreferenceHelper? _preference;

  // fields
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isUserFieldFocused = false.obs;
  var isPasswordFieldFocused = false.obs;
  RxBool isUsernameValid = true.obs;
  RxBool isPasswordValid = true.obs;
  late GlobalKey<FormState> form;
  final FocusNode userFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  //new pass fields
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final FocusNode newpasswordFocusNode = FocusNode();
  final FocusNode confirmpasswordFocusNode = FocusNode();
  RxBool isSixChar = false.obs;
  RxBool isCaps = false.obs;
  RxBool isSpecial = false.obs;
  RxBool isdigits = false.obs;

  RxBool newPassVisible = false.obs;
  RxBool confirmNewPassVisible = false.obs;

  //

  // otp
  TextEditingController otpcontroller1 = TextEditingController();
  TextEditingController otpcontroller2 = TextEditingController();
  TextEditingController otpcontroller3 = TextEditingController();
  TextEditingController otpcontroller4 = TextEditingController();
  //

  RxBool rxRememberMe = false.obs;
  RxBool rxhidePassword = true.obs;

  //response
  Rxn<LoginResponse> rxLoginData = Rxn<LoginResponse>();
  Rxn<LoginResponse> rxLoginResponse = Rxn<LoginResponse>();
  Rxn<UserLoginResponse> rxUserLoginResponse = Rxn<UserLoginResponse>();

  @override
  Future<void> onInit() async {
    form = GlobalKey<FormState>();
    userFocusNode.addListener(() {
      isUserFieldFocused.value =
          (userFocusNode.hasFocus || userController.text.isNotEmpty);
    });
    passwordFocusNode.addListener(() {
      isPasswordFieldFocused.value =
          (passwordFocusNode.hasFocus || passwordController.text.isNotEmpty);
    });
    super.onInit();
  }

  void _devEnvSetup() {
    if (AppEnvironment.isDevMode()) {
      // userController.text = 'sidharthshibu@muziris.co.in';
      // passwordController.text = '123';
    }
  }

  Future<void> _loadStartup() async {
    _preference = myApp.preferenceHelper;
    rxRememberMe(
        _preference != null ? _preference!.getBool(rememberMeKey) : false);
    String? deviceId = await DeviceUtil.getDeviceId();
    if (_preference != null) {
      await _preference!.setString(deviceIdKey, deviceId ?? '');
      if (rxRememberMe.value) {
        userController.text = _preference!.getString(emailKey);
        passwordController.text = _preference!.getString(passwordKey);
      }
    }
  }

  void onShowPassChange() async {
    rxhidePassword.value = !rxhidePassword.value;
  }

  Future<bool> signIn() async {
    hideKeyboard();
    if (isValidCredentials()) {
      bool status = await _callSignInService();

      return status;
    }

    return false;
  }

  bool isValidCredentials() {
    String email = userController.text.trim();
    String password = passwordController.text.trim();

    // username validation
    if (isStringNullOrEmpty(email)) {
      isUsernameValid(false);
    } else {
      isUsernameValid(true);
    }

    // password validation
    if (isStringNullOrEmpty(password)) {
      isPasswordValid(false);
    } else {
      isPasswordValid(true);
    }

    // return true only if both are valid
    if (isUsernameValid.value && isPasswordValid.value) {
      return true;
    }
    return false;
  }

  Future<bool> _callSignInService() async {
    try {
      showLoader();
      await Future.delayed(const Duration(milliseconds: 150));
      String username = userController.text.trim();
      String password = passwordController.text.trim();
      if (!username.endsWith("@MUZIRIS")) {
        username += "@MUZIRIS";
      }
      LoginResponse? response = await _authService.login(LoginRequest(
        username: username,
        password: password,
      ));
      if (response != null) {
        rxLoginResponse.value = response;
        myApp.preferenceHelper!
            .setString(accessTokenKey, rxLoginResponse.value!.authToken ?? '');
        myApp.preferenceHelper!.setString(
            refreshTokenKey, rxLoginResponse.value!.refreshToken ?? '');
        bool setProfile = await _callUserSignIn(username, password);
        return setProfile;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  Future<bool> _callUserSignIn(String name, String pass) async {
    try {
      showLoader();
      var userLoginRequestList = [
        CommonRequest(attribute: "UserCode", value: name),
        CommonRequest(attribute: "UserPassword", value: pass),
      ];
      UserLoginResponse? response =
          await _authService.userLogin(userLoginRequestList);
      if (response != null) {
        rxUserLoginResponse.value = response;

        // Save login data here
        await _saveLoginDataToPref();

        // Clear controllers if needed
        userController.clear();
        passwordController.clear();

        return true;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  Future<void> _saveLoginDataToPref() async {
    if (myApp.preferenceHelper != null) {
      inspect(rxLoginResponse.value);
      //username & pass
      myApp.preferenceHelper!
          .setString(loginNameKey, userController.text.trim());
      myApp.preferenceHelper!
          .setString(passwordKey, passwordController.text.trim());
      //
      myApp.preferenceHelper!
          .setString(userImgKey, rxUserLoginResponse.value!.userImgUrl ?? '');

      //
      myApp.preferenceHelper!
          .setString(userNameKey, rxUserLoginResponse.value!.userName ?? '');
      myApp.preferenceHelper!.setString(employeeIdKey,
          (rxUserLoginResponse.value!.employeeId ?? "").toString());
      myApp.preferenceHelper!.setString(
          employeeTypeKey, rxUserLoginResponse.value!.employeeType ?? '');
      myApp.preferenceHelper!.setString(
          userTypeKey, rxUserLoginResponse.value!.employeeType ?? '');
      // token
      myApp.preferenceHelper!
          .setString(accessTokenKey, rxLoginResponse.value!.authToken ?? '');
      myApp.preferenceHelper!.setString(
          refreshTokenKey, rxLoginResponse.value!.refreshToken ?? '');
      //remember me
      myApp.preferenceHelper!.setBool(rememberMeKey, rxRememberMe.value);
    }
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

  Future<bool> fetchInitData() async {
    await _loadStartup();
    _devEnvSetup();

    return true;
  }

  // @override
  // void onClose() {
  //   userController.dispose();
  //   passwordController.dispose();
  //   // newPasswordController.dispose();
  //   // confirmNewPasswordController.dispose();
  //   otpcontroller1.dispose();
  //   otpcontroller2.dispose();
  //   otpcontroller3.dispose();
  //   otpcontroller4.dispose();

  //   userFocusNode.dispose();
  //   passwordFocusNode.dispose();
  //   // newpasswordFocusNode.dispose();
  //   // confirmpasswordFocusNode.dispose();

  //   super.onClose();
  // }
}
