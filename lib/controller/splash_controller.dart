import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/app_string.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/shared_pref.dart';
import '../helper/single_app.dart';

class SplashController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final MyApplication myApplication = Get.find<MyApplication>();
  SharedPreferenceHelper? _preference;
  var rxUpdateRequired = false.obs;

  late AnimationController _textController;
  late Animation<Offset> textSlide;

  RxBool rxShowSecondImage = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    initTextAnimation();
    await startBackgroundAnimation();

    _textController.forward();
  }

  Future<int> fetchUserProfile() async {
    _preference = myApplication.preferenceHelper;
    await Future.delayed(const Duration(seconds: 3));

    bool isLoggedIn = myApp.preferenceHelper != null
        ? (myApp.preferenceHelper!.getBool(rememberMeKey) &&
            myApp.preferenceHelper!.getString(emailKey).isNotEmpty)
        : false;

    return isLoggedIn ? 1 : 2;
  }

  Future<void> resetPref() async {
    _preference?.remove(accessTokenKey);
    _preference?.remove(passwordKey);
  }

  void initTextAnimation() {
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    textSlide = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 1.5), end: const Offset(0, 0))
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 0), end: const Offset(0, 0.05))
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_textController);
  }

  /// Background fade transition
  Future<void> startBackgroundAnimation() async {
    await Future.delayed(const Duration(milliseconds: 600));
    rxShowSecondImage(true);

    // Optional: wait extra time for fade to look smooth
    await Future.delayed(const Duration(milliseconds: 150));
  }

  @override
  void onClose() {
    _textController.dispose();
    super.onClose();
  }
}
