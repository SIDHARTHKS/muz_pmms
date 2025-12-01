import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/settings_controller.dart';
import 'package:pmms/gen/assets.gen.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/core/base/app_base_view.dart';
import 'package:pmms/helper/core/environment/env.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/helper/sizer.dart';
import '../widget/common_widget.dart';

class SettingsScreen extends AppBaseView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(
        canpop: true,
        body: appFutureBuilder<void>(
            () => controller.fetchInitData(), (context, snapshot) => _body(),
            loaderWidget: fullScreenloader()),
      );
  Scaffold _body() {
    return appScaffold(
      appBar: customAppBar(settings.tr),
      body: appContainer(
        child: Obx(() {
          return Column(
            children: [
              height(15),
              _userDetails(),
              height(4),
              _changePass(),
              _darkMode(),
              _notification(),
              _info(),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  await controller.resetPreference();
                  navigateToAndRemoveAll(loginPageRoute);
                },
                child: Container(
                  child: appText(logout.tr,
                      color: AppColorHelper().primaryTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Container _info() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 6),
      height: 60,
      decoration: BoxDecoration(
          color: AppColorHelper().cardColor,
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                Assets.icons.info.path,
                scale: 4,
              ),
              width(10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                appText(appInfo.tr,
                    color: AppColorHelper().primaryTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
                height(3),
                Row(children: [
                  appText(latestVersion.tr,
                      color: AppColorHelper()
                          .primaryTextColor
                          .withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                  appText(AppEnvironment.config.version,
                      color: AppColorHelper()
                          .primaryTextColor
                          .withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ]),
              ])
            ],
          ),
        ],
      ),
    );
  }

  Container _notification() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 6),
      height: 60,
      decoration: BoxDecoration(
          color: AppColorHelper().cardColor,
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                Assets.icons.notificationSettings.path,
                scale: 4,
              ),
              width(10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                appText(notification.tr,
                    color: AppColorHelper().primaryTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
                height(3),
                Row(
                  children: [
                    appText(yourNotification.tr,
                        color: AppColorHelper()
                            .primaryTextColor
                            .withValues(alpha: 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                    appText(
                        controller.rxNotificationsEnabled.value
                            ? enabled.tr
                            : disabled.tr,
                        color: AppColorHelper().primaryTextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                    appText(now.tr,
                        color: AppColorHelper()
                            .primaryTextColor
                            .withValues(alpha: 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ],
                ),
              ])
            ],
          ),
          _buildToggleSwitch(controller.rxNotificationsEnabled.value,
              controller.toggleNotifications)
        ],
      ),
    );
  }

  Container _darkMode() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: const EdgeInsets.symmetric(vertical: 6),
      height: 60,
      decoration: BoxDecoration(
          color: AppColorHelper().cardColor,
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                Assets.icons.darkmode.path,
                scale: 4,
              ),
              width(10),
              appText(darkTheme.tr,
                  color: AppColorHelper().primaryTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)
            ],
          ),
          _buildToggleSwitch(
              controller.rxDarkmodeEnabled.value, controller.toggleDarkmode)
        ],
      ),
    );
  }

  GestureDetector _changePass() {
    return GestureDetector(
      onTap: () {
        navigateTo(changePasswordPageRoute);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 6),
        height: 60,
        decoration: BoxDecoration(
            color: AppColorHelper().cardColor,
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  Assets.icons.changePass.path,
                  scale: 4,
                ),
                width(10),
                appText(changePass.tr,
                    color: AppColorHelper().primaryTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColorHelper().primaryTextColor,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  Container _userDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image
          CircleAvatar(
            radius: 24,
            child: (Center(
              child: appText("T",
                  fontWeight: FontWeight.w500,
                  color: AppColorHelper().primaryColor.withValues(
                        alpha: 0.5,
                      ),
                  fontSize: 25),
            )),
          ),
          width(10),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(1),
                appText('Test User',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColorHelper().primaryTextColor),
                height(10),
                appText('User ID : 1252 | UI/UX Designer',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColorHelper()
                        .primaryTextColor
                        .withValues(alpha: 0.6)),
                Divider(
                  color: AppColorHelper().dividerColor.withValues(alpha: 0.2),
                  thickness: 0.5,
                  height: 12,
                ),
                appText('testuser@gmail.com',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColorHelper()
                        .primaryTextColor
                        .withValues(alpha: 0.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSwitch(bool value, VoidCallback ontap) => GestureDetector(
        onTap: ontap,
        child: SizedBox(
            width: 54,
            child: Padding(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: GestureDetector(
                  onTap: ontap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 50,
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: value
                          ? AppColorHelper().primaryColor.withValues(alpha: 0.1)
                          : AppColorHelper()
                              .primaryTextColor
                              .withValues(alpha: 0.1),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment:
                          value ? Alignment.centerRight : Alignment.centerLeft,
                      //thumb
                      child: Container(
                        width: 23,
                        height: 23,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: value
                              ? AppColorHelper().primaryColor
                              : AppColorHelper()
                                  .primaryTextColor
                                  .withValues(alpha: 0.1),
                          boxShadow: [
                            BoxShadow(
                              color: AppColorHelper()
                                  .boxShadowColor
                                  .withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))),
      );
}
