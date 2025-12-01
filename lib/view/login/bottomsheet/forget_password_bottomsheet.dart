import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/login_controller.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/helper/sizer.dart';
import 'package:pmms/view/widget/common_widget.dart';
import 'package:pmms/view/widget/otp/otp_widget.dart';

class ForgetPasswordBottomsheet extends AppBaseView<LoginController> {
  // final ScrollController? scrollController;
  const ForgetPasswordBottomsheet({super.key});

  @override
  Widget buildView() => _widgetView();

  Widget _widgetView() {
    return appScaffold(body: _buildBody());
  }

  Widget _buildBody() => Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(forgetPassword.tr,
                    color: AppColorHelper().primaryTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColorHelper().primaryColor,
                  ),
                  child: iconWidget(Icons.close,
                      color: AppColorHelper().textColor, onPressed: goBack),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: divider(
                  color: AppColorHelper().borderColor.withValues(alpha: 0.4)),
            ),
            height(12),
            Center(
              child: appText(sentVerificationDialogue.tr,
                  textAlign: TextAlign.center,
                  color: AppColorHelper().primaryTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            height(25),
            Center(
              child: appText("an************90@gmail.com",
                  color: AppColorHelper().primaryTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            height(43),
            Center(
              child: appText(otp.tr,
                  color:
                      AppColorHelper().primaryTextColor.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            height(20),
            OTPField(
              controllers: [
                controller.otpcontroller1,
                controller.otpcontroller2,
                controller.otpcontroller3,
                controller.otpcontroller4
              ],
            ),
            height(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appText(didntRecieve.tr,
                    color: AppColorHelper()
                        .primaryTextColor
                        .withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: 13),
                width(2),
                GestureDetector(
                  onTap: () {},
                  child: appText(resend.tr,
                      color: AppColorHelper().primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ),
              ],
            ),
            height(40),
            SafeArea(
              child: buttonContainer(
                onPressed: () {
                  navigateToAndRemoveAll(createPasswordPageRoute);
                },
                color: AppColorHelper().primaryColor,
                appText(verifyOtp.tr,
                    color: AppColorHelper().textColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
}
