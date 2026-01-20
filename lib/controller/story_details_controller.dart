import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
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
  late TasksController tasksController = Get.find<TasksController>();
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

  // Future<void> _setArguments() async {
  //   var arguments = Get.arguments;
  //   var data = arguments[selectedViewStoryKey];

  //   if (arguments != null) {
  //     TaskResponse story = TaskResponse.fromJson(data);
  //     rxSelectedStory.value = story;
  //     await fetchStory(false);
  //   } else {
  //     showErrorSnackbar(
  //         message: "Unable To Fetch Task Details. Please Login Again");
  //     goBack();
  //   }
  // }

  Future<void> _setArguments() async {
    final arguments = Get.arguments;

    if (arguments == null) {
      _handleInvalidArgs();
      return;
    }
    // CASE 1: Nav from Stories List
    if (arguments.containsKey(selectedViewStoryKey)) {
      final data = arguments[selectedViewStoryKey];

      if (data == null) {
        _handleInvalidArgs();
        return;
      }

      final TaskResponse story = TaskResponse.fromJson(data);
      rxSelectedStory.value = story;

      await fetchStory(false);
      return;
    }

    // CASE 2: Nav from Stories in Tokens
    if (arguments.containsKey(selectedViewStoryListKey)) {
      final data = arguments[selectedViewStoryListKey];

      if (data == null) {
        _handleInvalidArgs();
        return;
      }

      final StoryList story = StoryList.fromJson(data);
      rxFetchedStory.value = story;
      return;
    }

    _handleInvalidArgs();
  }

  void _handleInvalidArgs() {
    showErrorSnackbar(
      message: "Unable to fetch story details. Please try again.",
    );
    goBack();
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
        rxFetchedStory.refresh();
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

  Future<bool> fetchStoryAfterReuturn(StoryList story, bool loader) async {
    try {
      if (loader) {
        showLoader();
      }
      await Future.delayed(const Duration(milliseconds: 300));
      String id = myApp.preferenceHelper!.getString(employeeIdKey);
      var tkn = story;
      var approveList = [
        CommonRequest(attribute: "Description", value: ""),
        CommonRequest(attribute: "EstimateTime", value: ""),
        CommonRequest(attribute: "RequestDate", value: ""),
        CommonRequest(attribute: "PlannedStartDate", value: ""),
        CommonRequest(attribute: "PlannedEndDate", value: ""),
        CommonRequest(attribute: "RequestID", value: tkn.requestId.toString()),
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
        rxFetchedStory.refresh();
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

  //////////////////////////////// HOLD STORY  ////////////////////////////////

  Future<bool> holdStory(bool loader) async {
    try {
      if (loader) {
        showLoader();
      }
      await Future.delayed(const Duration(milliseconds: 300));
      String id = myApp.preferenceHelper!.getString(employeeIdKey);
      var stry = rxFetchedStory.value;

      var holdList = [
        CommonRequest(attribute: "transType", value: "INSERT"),
        CommonRequest(attribute: "transSubType", value: "HOLD"),
        CommonRequest(attribute: "Description", value: stry?.description ?? ""),
        CommonRequest(
            attribute: "EstimateTime", value: stry?.estimateTime ?? ""),
        CommonRequest(
            attribute: "RequestDate", value: stry?.requestDateTime ?? ""),
        CommonRequest(
            attribute: "PlannedStartDate", value: stry?.plannedStartDate ?? ""),
        CommonRequest(
            attribute: "PlannedEndDate", value: stry?.plannedEndDate ?? ""),
        CommonRequest(attribute: "RequestID", value: stry?.requestId ?? ""),
        CommonRequest(
            attribute: "StoryTypeMccID",
            value: stry?.requestTypeId.toString() ?? ""), /////////doubt
        CommonRequest(
            attribute: "ModuleID", value: stry?.moduleId.toString() ?? ""),
        CommonRequest(
            attribute: "OptionID", value: stry?.optionId.toString() ?? ""),
        CommonRequest(
            attribute: "CurrentStatusMccID",
            value: stry?.currentStatusId.toString() ?? ""),
        CommonRequest(
            attribute: "ParentRequestID",
            value: stry?.parentRequestId.toString() ?? ""),
        CommonRequest(
            attribute: "AssigneeID", value: stry?.assigneeId.toString() ?? ""),
        CommonRequest(attribute: "LoginEmpID", value: id),
        CommonRequest(
            attribute: "OrginalStratDate", value: stry?.startDate ?? ""),
        CommonRequest(attribute: "OrginalEndDate", value: stry?.endDate ?? ""),
        CommonRequest(attribute: "Attachments", value: stry?.attachment ?? ""),
        CommonRequest(attribute: "Links", value: stry?.attachment ?? ""),
      ];
      bool? response = await _taskServices.holdStory(holdList);
      if (response != null) {
        return response;
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

  //////////////////////////////// HOLD STORY  ////////////////////////////////

  Future<bool> rejectStory(bool loader) async {
    try {
      if (loader) {
        showLoader();
      }
      await Future.delayed(const Duration(milliseconds: 300));
      String id = myApp.preferenceHelper!.getString(employeeIdKey);
      var stry = rxFetchedStory.value;

      var holdList = [
        CommonRequest(attribute: "transType", value: "INSERT"),
        CommonRequest(attribute: "transSubType", value: "REJECT"),
        CommonRequest(attribute: "Description", value: stry?.description ?? ""),
        CommonRequest(
            attribute: "EstimateTime", value: stry?.estimateTime ?? ""),
        CommonRequest(
            attribute: "RequestDate", value: stry?.requestDateTime ?? ""),
        CommonRequest(
            attribute: "PlannedStartDate", value: stry?.plannedStartDate ?? ""),
        CommonRequest(
            attribute: "PlannedEndDate", value: stry?.plannedEndDate ?? ""),
        CommonRequest(attribute: "RequestID", value: stry?.requestId ?? ""),
        CommonRequest(
            attribute: "StoryTypeMccID",
            value: stry?.requestTypeId.toString() ?? ""), /////////doubt
        CommonRequest(
            attribute: "ModuleID", value: stry?.moduleId.toString() ?? ""),
        CommonRequest(
            attribute: "OptionID", value: stry?.optionId.toString() ?? ""),
        CommonRequest(
            attribute: "CurrentStatusMccID",
            value: stry?.currentStatusId.toString() ?? ""),
        CommonRequest(
            attribute: "ParentRequestID",
            value: stry?.parentRequestId.toString() ?? ""),
        CommonRequest(
            attribute: "AssigneeID", value: stry?.assigneeId.toString() ?? ""),
        CommonRequest(attribute: "LoginEmpID", value: id),
        CommonRequest(
            attribute: "OrginalStratDate", value: stry?.startDate ?? ""),
        CommonRequest(attribute: "OrginalEndDate", value: stry?.endDate ?? ""),
        CommonRequest(attribute: "Attachments", value: stry?.attachment ?? ""),
        CommonRequest(attribute: "Links", value: stry?.attachment ?? ""),
      ];
      bool? response = await _taskServices.holdStory(holdList);
      if (response != null) {
        return response;
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

    return true;
  }
}
