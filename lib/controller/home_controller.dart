import 'package:get/get.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/model/notification_model.dart';
import 'package:pmms/model/task_model.dart';
import 'package:pmms/service/notification_services.dart';
import '../helper/app_message.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/navigation.dart';

class HomeController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  //

  final NotificationServices _notificationServices =
      Get.find<NotificationServices>();

  //
  final isInitCalled = false.obs;
  RxString rxUserName = ''.obs;
  RxString rxUserImg = ''.obs;
  RxString rxUserId = "".obs;

  // tasks
  RxList<TaskResponse> rxTasksResponse = <TaskResponse>[].obs;

  @override
  Future<void> onInit() async {
    await _setArguments();
    // isInitCalled(true);
    super.onInit();
  }

  Future<void> _setArguments() async {
    var arguments = Get.arguments;
    var task = arguments[tasksDataKey];
    if (arguments != null) {
      rxTasksResponse(task);
    } else {
      showErrorSnackbar(
          message: "Unable To Fetch Task Details. Please Login Again");
      navigateToAndRemoveAll(loginPageRoute);
    }
    appLog("userid =${rxUserId.value}");
  }

  // Future<bool> fetchNotifications() async {
  //   try {
  //     showLoader();
  //     String id = myApp.preferenceHelper!.getString(employeeIdKey);
  //     var notificationRequestList = [
  //       CommonRequest(attribute: "transType", value: "LIST"),
  //       CommonRequest(attribute: "transSubType", value: "ALERTS"),
  //       CommonRequest(attribute: "EmployeeID", value: id),
  //       CommonRequest(attribute: "AlternateKeyID", value: ""),
  //       CommonRequest(attribute: "Flag", value: ""),
  //       CommonRequest(attribute: "ApproveRejectionFlag", value: ""),
  //       CommonRequest(attribute: "ReadID", value: ""),
  //       CommonRequest(attribute: "AlternateKeyIDStr", value: ""),
  //     ];
  //     List<TaskResponse>? response =
  //         await _notificationServices.getNotifications(notificationRequestList);
  //     if (response != null) {
  //       rxTasksResponse.value = response;
  //       return true;
  //     }
  //   } catch (e) {
  //     appLog('$exceptionMsg $e', logging: Logging.error);
  //   } finally {
  //     hideLoader();
  //   }
  //   return false;
  // }

  // mock data
  List<NotificationModel> notifications = [
    NotificationModel(
      title: 'Mz.Ft',
      token: 'TKN-714',
      message: 'Your token has been approved successfully.',
      status: '',
      date: '4th Nov 2025',
      category: '',
      priority: '',
      isApproved: true,
    ),
    NotificationModel(
      title: 'Payroll Muziris',
      token: 'TKN-124',
      message: 'Get real-time updates through push and in-app alerts.',
      status: 'Pending for approval.',
      date: '3rd Nov 2025',
      category: 'Support',
      priority: 'Medium',
      isApproved: false,
    ),
    NotificationModel(
      title: 'Mz.Ft',
      token: 'TKN-321',
      message: 'Your token has been approved successfully.',
      status: '',
      date: '2nd Nov 2025',
      category: '',
      priority: '',
      isApproved: true,
    ),
    NotificationModel(
      title: 'Mz.Ft',
      token: 'TKN-114',
      message:
          'Create a comprehensive analytics dashboard module that ensures secure...',
      status: 'Pending for approval.',
      date: '31st Oct 2025',
      category: 'Error',
      priority: 'High',
      isApproved: false,
    ),
  ];

  Future<bool> fetchInitData() async {
    return true;
  }
}
