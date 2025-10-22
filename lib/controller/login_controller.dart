import 'dart:async';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
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

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool rxRememberMe = false.obs;
  Rxn<LoginResponse> rxLoginData = Rxn<LoginResponse>();

  late SharedPreferenceHelper? _preference;

  late GlobalKey<FormState> form;
  final FocusNode userFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  Rxn<LoginResponse> rxLoginResponse = Rxn<LoginResponse>();
  Rxn<UserLoginResponse> rxUserLoginResponse = Rxn<UserLoginResponse>();

  @override
  Future<void> onInit() async {
    form = GlobalKey<FormState>();
    super.onInit();
  }

  void _devEnvSetup() {
    if (AppEnvironment.isDevMode()) {
      // userController.text = '1316';
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

  void onRememberMeChange(bool value) async {
    if (_preference != null) {
      await _preference!.setBool(rememberMeKey, value);
      rxRememberMe(
          _preference != null ? _preference!.getBool(rememberMeKey) : false);
    }
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
    if (isStringNullOrEmpty(email) || isStringNullOrEmpty(password)) {
      return false;
    }
    return true;
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

        // if (rxProfileResponse.value != null) {
        //   rxRememberMe.value = true;
        //   await _saveLoginDataToPref();
        //   userController.clear();
        //   passwordController.clear();

        //   return true;
        // }
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

  Future<bool> fetchInitData() async {
    await _loadStartup();
    _devEnvSetup();
    // await delay(milliseconds: 10000);
    return true;
  }

  @override
  void onClose() {
    form = GlobalKey<FormState>(); // 🧹 cleanup just in case
    super.onClose();
  }
}
