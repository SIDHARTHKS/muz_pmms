import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/helper/date_helper.dart';
import '../helper/app_message.dart';
import '../helper/app_string.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/enum.dart';
import '../helper/shared_pref.dart';
import '../model/app_model.dart';
import '../model/task_model.dart';
import '../service/task_services.dart';

class SplashController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final TaskServices _taskServices = Get.find<TaskServices>();

  SharedPreferenceHelper? _preference;
  var rxUpdateRequired = false.obs;

  // animation
  late AnimationController _textController;
  late Animation<Offset> textSlide;
  RxBool rxShowSecondImage = false.obs;

  // tasks
  RxList<TaskResponse> rxTasksResponse = <TaskResponse>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    initTextAnimation();
    await startBackgroundAnimation();
    _textController.forward();
  }

  Future<int> fetchUserProfile() async {
    await Future.delayed(const Duration(
        seconds: 3)); // required for completing the anmtn----------
    var preference = myApp.preferenceHelper;
    if (preference != null) {
      final rememberMe = preference.getBool(rememberMeKey);
      final userId = preference.getString(employeeIdKey);
      final token = preference.getString(accessTokenKey);

      if (rememberMe && userId != "-1" && token.isNotEmpty) {
        //for version and early fetch and keep
        // bool mismatch =
        //     await getVersion(); ///////////////////////////////////////////////////////////////////version
        // RxBool(mismatch);
        final success = await fetchTasks();
        if (success) {
          return 1;
        }
      }
    }

    return 2; // fallback for all other cases
  }

  Future<bool> fetchTasks() async {
    try {
      showLoader();
      String id = myApp.preferenceHelper!.getString(employeeIdKey);
      String now = DateHelper().formatForApi(DateTime.now());
      var tasksRequestsList = [
        CommonRequest(attribute: "transType", value: "LIST"),
        CommonRequest(attribute: "transSubType", value: "MYTASK"),
        CommonRequest(attribute: "EmployeeID", value: id),
        CommonRequest(attribute: "dateFrom", value: ""),
        CommonRequest(attribute: "dateTo", value: now),
        CommonRequest(attribute: "StatusMccID", value: ""),
        CommonRequest(attribute: "ProjectID", value: ""),
        CommonRequest(attribute: "PriorityMccID", value: ""),
        CommonRequest(attribute: "RequestTypeMccID", value: ""),
      ];
      List<TaskResponse>? response =
          await _taskServices.getTasks(tasksRequestsList);
      if (response != null) {
        rxTasksResponse.value = response;
        return true;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  Future<void> resetPref() async {
    _preference?.remove(accessTokenKey);
    _preference?.remove(loginPasswordKey);
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
