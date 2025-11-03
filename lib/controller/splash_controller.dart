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
    initAnimations();
    startBackgroundAnimation();
    startTextAnimation();

    super.onInit();
  }

  Future<int> fetchUserProfile() async {
    _preference = myApplication.preferenceHelper;
    await Future.delayed(const Duration(seconds: 5));
    bool isLoggedIn = myApp.preferenceHelper != null
        ? (myApp.preferenceHelper!.getBool(rememberMeKey) &&
            myApp.preferenceHelper!.getString(emailKey).isNotEmpty)
        : false;

    if (isLoggedIn) {
      if (myApp.preferenceHelper == null) {
        return 2;
      } else {
        // await fetchCompanies().then((success) {
        //   if (success) {
        //     fetchLocations();
        //   }
        // });
        return 1;
      }
    }
    return 2;
  }

  Future<void> resetPref() async {
    _preference!.remove(accessTokenKey);
    _preference!.remove(passwordKey);
  }

  void initAnimations() {
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    );

    // slide up
    final slideIn = Tween<Offset>(
      begin: const Offset(0, 1.5), // start further down
      end: const Offset(0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 1.8, curve: Curves.easeOutCubic),
      ),
    );

    // slide down
    final floatDown = Tween<Offset>(
      begin: const Offset(0, 0.0),
      end: const Offset(0, 0.05), // small downward drift
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(1.8, 2.9, curve: Curves.easeInOut),
      ),
    );

    // Combine both using TweenSequence or AnimatedBuilder logic
    textSlide = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, 1.5), end: const Offset(0, 0.0))
              .chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 60),
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, 0.0), end: const Offset(0, 0.05))
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 40),
    ]).animate(_textController);

    _textController.forward();
  }

  /// 🌄 Simple background fade transition
  void startBackgroundAnimation() async {
    await Future.delayed(const Duration(milliseconds: 600));
    rxShowSecondImage(true);
  }

  /// 🕊️ Simple text float-in animation
  void startTextAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _textController.forward();
    });
  }
}
