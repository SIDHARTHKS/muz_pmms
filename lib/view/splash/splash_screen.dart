import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/splash_controller.dart';
import '../../gen/assets.gen.dart';
import '../../helper/app_string.dart';
import '../../helper/color_helper.dart';
import '../../helper/core/base/app_base_view.dart';
import '../../helper/core/environment/env.dart';
import '../../helper/navigation.dart';
import '../../helper/route.dart';
import '../../helper/sizer.dart';
import '../widget/common_widget.dart';

class SplashScreen extends AppBaseView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(
        topSafe: false,
        bottomNavigationBar: muzBottomLogo(),
        body: appFutureBuilder<int>(
          () => controller.fetchUserProfile(),
          (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While loading, show loader
              return _loaderWidget();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              // Perform navigation in a microtask after build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (controller.rxUpdateRequired.value) {
                  _openAppUpdateDialog();
                } else {
                  Map<String, dynamic> arguments = {};
                  if (snapshot.data == 1) {}
                  navigateToAndRemoveAll(
                    // snapshot.data == 1 ? homePageRoute : loginPageRoute,
                    snapshot.data == 1 ? homePageRoute : homePageRoute,
                    arguments: arguments,
                  );
                }
              });
              // Show loader while navigating
              return _loaderWidget();
            } else {
              return _loaderWidget();
            }
          },
          loaderWidget: _loaderWidget(),
        ),
      );

  SizedBox _loaderWidget() => appContainer(
        enableSafeArea: false,
        child: Container(
          decoration: BoxDecoration(
            color: AppColorHelper().primaryColor,
            // image: DecorationImage(
            //   image: AssetImage(Assets.images.backgrnd.path),
            //   fit: BoxFit.cover,
            //   opacity: 0.1,
            // ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(top: 100, left: 0, right: 0, child: logoImage()),
              Center(child: loader()),
              height(40),
              Positioned(
                bottom: 300,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    appText(
                      settings.tr,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColorHelper().textColor,
                    ),
                    height(5),
                    appText(
                      settings.tr,
                      textAlign: TextAlign.center,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColorHelper().textColor,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  void _openAppUpdateDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Widget okButton = TextButton(
          child: Text(ok.tr),
          onPressed: () {
            if (AppEnvironment.isAndroid()) {
              SystemNavigator.pop();
            } else if (AppEnvironment.isIos()) {
              exit(0);
            }
          },
        );
        return AlertDialog(
          title: Text(unSupportedAppVersionTitle.tr),
          content: Text(updateAppDialogMsg.tr),
          actions: [
            okButton,
          ],
        );
      },
    );
  }
}
