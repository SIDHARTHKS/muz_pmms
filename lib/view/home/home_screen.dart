import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/helper/sizer.dart';
import '../../controller/home_controller.dart';
import '../../helper/core/base/app_base_view.dart';
import '../widget/common_widget.dart';

class HomeScreen extends AppBaseView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget buildView() {
    return appScaffold(
      canpop: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return appBar(
      leadingWidget: width(0),
      titleText: home.tr,
      showbackArrow: false,
      leadingWidgetPressed: () {},
    );
  }

  Widget _buildBody() {
    return appContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              appText("Welcome to pmms",
                  fontSize: 18, color: AppColorHelper().primaryTextColor),
              height(20),
              buttonContainer(
                  appText(mytask.tr,
                      color: AppColorHelper().primaryColor,
                      fontWeight: FontWeight.w500), onPressed: () {
                navigateTo(tasksPageRoute);
              }),
              height(20),
              buttonContainer(
                  color: AppColorHelper().primaryColor,
                  appText(createtoken.tr, fontWeight: FontWeight.w500),
                  onPressed: () {
                navigateTo(createTokenPageRoute);
              }),
              height(20),
              buttonContainer(
                  appText(
                    createstory.tr,
                    color: AppColorHelper().primaryColor,
                    fontWeight: FontWeight.w500,
                  ), onPressed: () {
                navigateTo(createStoryPageRoute);
              }),
              height(20),
              buttonContainer(
                  color: AppColorHelper().primaryColor,
                  appText(settings.tr, fontWeight: FontWeight.w500),
                  onPressed: () {
                navigateTo(settingsPageRoute);
              }),
              height(20),
              buttonContainer(
                  appText(notification.tr,
                      color: AppColorHelper().primaryColor,
                      fontWeight: FontWeight.w500), onPressed: () {
                navigateTo(notificationsPageRoute);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
