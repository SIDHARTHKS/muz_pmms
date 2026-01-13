import 'package:get/get.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/enum.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/model/app_model.dart';
import 'package:pmms/service/task_services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../helper/app_message.dart';
import '../helper/core/base/app_base_controller.dart';
import '../model/task_model.dart';

class StoryDetailsController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final TaskServices _taskServices = Get.find<TaskServices>();
  final RefreshController pullController = RefreshController();
  //
  final isInitCalled = false.obs;

  // selected story details

  Rxn<TaskResponse> rxSelectedStory = Rxn<TaskResponse>();
  Rxn<StoryList> rxFetchedStory = Rxn<StoryList>();

  @override
  Future<void> onInit() async {
    isInitCalled(true);

    super.onInit();
  }

  //////////////////////////////// FETCHING/SETTING TASK ////////////////////////////////

  Future<void> _setArguments() async {
    var arguments = Get.arguments;
    var data = arguments[selectedViewStoryKey];
    if (arguments != null) {
      TaskResponse story = TaskResponse.fromJson(data);
      rxSelectedStory.value = story;
    } else {
      showErrorSnackbar(
          message: "Unable To Fetch Task Details. Please Login Again");
      goBack();
    }
  }

  //////////////////////////////// STORY FETCH  ////////////////////////////////

  Future<bool> fetchStory(bool loader) async {
    try {
      if (loader) {
        showLoader();
      }
      await Future.delayed(const Duration(milliseconds: 300));
      String id = myApp.preferenceHelper!.getString(employeeIdKey);
      var tkn = rxSelectedStory.value;
      var approveList = [
        CommonRequest(attribute: "Description", value: ""),
        CommonRequest(attribute: "EstimateTime", value: ""),
        CommonRequest(attribute: "RequestDate", value: ""),
        CommonRequest(attribute: "PlannedStartDate", value: ""),
        CommonRequest(attribute: "PlannedEndDate", value: ""),
        CommonRequest(
            attribute: "RequestID", value: tkn?.requestId.toString() ?? "0"),
        CommonRequest(attribute: "StoryTypeMccID", value: ""),
        CommonRequest(attribute: "ModuleID", value: ""),
        CommonRequest(attribute: "OptionID", value: ""),
        CommonRequest(attribute: "CurrentStatusMccID", value: ""),
        CommonRequest(attribute: "ParentRequestID", value: "0"),
        CommonRequest(attribute: "AssigneeID", value: ""),
        CommonRequest(attribute: "LoginEmpID", value: id),
      ];
      List<StoryResponse>? response = await _taskServices.getStory(approveList);
      if (response != null &&
          response.isNotEmpty &&
          response.first.storyList != null &&
          response.first.storyList!.isNotEmpty) {
        rxFetchedStory.value = response.first.storyList!.first;
        return true;
      } else {
        goBack();
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  Future<bool> fetchStoryDetailsInitData() async {
    await _setArguments();
    await fetchStory(false);
    return true;
  }
}
