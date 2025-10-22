import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import '../../controller/login_controller.dart';
import '../../gen/assets.gen.dart';
import '../../helper/app_string.dart';
import '../../helper/color_helper.dart';
import '../../helper/core/base/app_base_view.dart';
import '../../helper/enum.dart';
import '../../helper/environment/env.dart';
import '../../helper/navigation.dart';
import '../../helper/route.dart';
import '../../helper/sizer.dart';
import '../../service/auth_service.dart';
import '../widget/common_widget.dart';
import '../widget/textformfield/app_textformfield_widget.dart';

class LoginScreen extends AppBaseView<LoginController> {
  final AuthService _authService = Get.find<AuthService>();
  LoginScreen({super.key});

  @override
  Widget buildView() => _buildScaffold();

  Scaffold _buildScaffold() => appScaffold(
      bgcolor: AppColorHelper().primaryColor,
      body: appFutureBuilder<void>(
        () => controller.fetchInitData(),
        (context, snapshot) => _buildBody(),
      ),
      bottomNavigationBar: muzBottomLogo());

  Widget _buildBody() => Obx(() {
        bool isTablet = AppEnvironment.deviceType == UserDeviceType.tablet;
        return controller.rxIsLoading.value
            ? fullScreenloader()
            : Container(
                height: Get.height,
                decoration: BoxDecoration(
                  color: AppColorHelper().primaryColor,
                  // image: DecorationImage(
                  //     image: AssetImage(Assets.images.backgrnd.path),
                  //     fit: BoxFit.cover,
                  //     opacity: 0.05),
                ),
                child: SafeArea(
                  child: KeyboardAvoider(
                    autoScroll: true, // Moves screen automatically
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: isTablet ? _tabletView() : _mobileView(),
                    ),
                  ),
                ),
              );
      });

  Center _tabletView() {
    return Center(
      child: Container(
        width: Get.width * 0.70,
        height: Get.height * 0.50,
        decoration: BoxDecoration(
            color: AppColorHelper().cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                spreadRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: AppColorHelper().borderColor.withValues(alpha: 0.2))),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appText(
                welcome.tr,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColorHelper().textColor,
              ),
              appText(
                welcome.tr,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColorHelper().textColor,
              ),
              height(10),
              Form(
                key: controller.form,
                child: Column(
                  children: [
                    logoImage(),
                    height(130),
                    _buildUsernameField(),
                    height(10),
                    _buildPasswordField(),
                    height(25),
                    _rememberMeContainer(),
                    height(40),
                    buttonContainer(
                        controller.rxIsLoading.value
                            ? buttonLoader()
                            : appText(signIn.tr,
                                color: AppColorHelper().textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                        onPressed: () async {
                      await controller.signIn().then((success) {
                        if (success) {
                          Map<String, dynamic> arguments = {};

                          navigateToAndRemoveAll(homePageRoute,
                              arguments: arguments);
                        }
                      });
                    }),
                    height(10),
                    appText(
                      AppEnvironment.config.version,
                      color: AppColorHelper().primaryTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _mobileView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoImage(),
        height(130),
        height(10),
        appText(
          welcome.tr,
          fontSize: 30,
          fontWeight: FontWeight.w500,
          color: AppColorHelper().textColor,
        ),
        height(10),
        appText(
          textAlign: TextAlign.center,
          login.tr,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColorHelper().textColor,
        ),
        height(10),
        Form(
          key: controller.form,
          child: Column(
            children: [
              _buildUsernameField(),
              height(5),
              _buildPasswordField(),
              height(15),
              _rememberMeContainer(),
              height(20),
              buttonContainer(
                  controller.rxIsLoading.value
                      ? buttonLoader()
                      : appText(signIn.tr,
                          fontSize: 18,
                          color: AppColorHelper().textColor,
                          fontWeight: FontWeight.w600), onPressed: () async {
                await controller.signIn().then((success) {
                  if (success) {
                    Map<String, dynamic> arguments = {};

                    navigateToAndRemoveAll(homePageRoute, arguments: arguments);
                  }
                });
                // navigateToAndRemoveAll(homePageRoute);
              }),
              height(20),
              appText(
                AppEnvironment.config.version,
                color: AppColorHelper().primaryTextColor,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
        height(30),
      ],
    );
  }

  Row _rememberMeContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: Row(
            children: [
              _buildRememberMeSwitch(
                  controller.rxRememberMe.value,
                  () => controller
                      .onRememberMeChange(controller.rxRememberMe.value)),
              width(20),
              SizedBox(
                child: appText("Remember Me",
                    color: AppColorHelper().primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        // GestureDetector(
        //   onTap: () {
        //     navigateTo(forgetPageRoute);
        //   },
        //   child: SizedBox(
        //     child: appText(
        //       forgetPassworddialogue.tr,
        //       color: AppColorHelper().primaryTextColor,
        //       fontSize: 12,
        //       fontWeight: FontWeight.w400,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildUsernameField() => TextFormWidget(
        height: 50,
        enabled: !controller.rxIsLoading.value,
        focusNode: controller.userFocusNode,
        controller: controller.userController,
        borderColor: AppColorHelper().focusedBorderColor,
        label: username.tr,
        // validator: (value) =>
        //     value!.trim().isEmpty ? enterMobileEmailMsg.tr : null,
        validator: (value) => value!.trim().isEmpty ? null : null,
        nextFocusNode: controller.passwordFocusNode,
      );

  Widget _buildPasswordField() => TextFormWidget(
        enabled: !controller.rxIsLoading.value,
        controller: controller.passwordController,
        focusNode: controller.passwordFocusNode,
        borderColor: AppColorHelper().focusedBorderColor,
        label: password.tr,
        // validator: (value) =>
        //     value!.trim().isEmpty ? enterPasswordMsg.tr : null,
        validator: (value) => value!.trim().isEmpty ? null : null,
        obscureText: true,
      );

  Widget _buildRememberMeSwitch(bool value, VoidCallback ontap) =>
      GestureDetector(
        onTap: ontap,
        child: SizedBox(
            width: 25,
            height: 25, // match thumb size for better centering
            child: GestureDetector(
              onTap: ontap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: value
                      ? AppColorHelper().primaryColor
                      : AppColorHelper().transparentColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColorHelper().borderColor,
                    width: 1,
                  ),
                ),
                child: value
                    ? Icon(
                        Icons.check,
                        color: AppColorHelper().textColor,
                        size: 18,
                      )
                    : null,
              ),
            )),
      );
}
