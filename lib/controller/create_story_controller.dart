import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pmms/helper/app_message.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/date_helper.dart';
import 'package:pmms/helper/enum.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/model/app_model.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/model/task_model.dart';
import 'package:pmms/service/task_services.dart';
import 'package:pmms/view/createStory/pages/create_story_page1.dart';
import 'package:pmms/view/createStory/pages/create_story_page2.dart';
import 'package:pmms/view/editStory/pages/edit_story_page1.dart';
import 'package:pmms/view/editStory/pages/edit_story_page2.dart';
import '../helper/core/base/app_base_controller.dart';

class CreateStoryController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final TaskServices _taskServices = Get.find<TaskServices>();
  //
  final isInitCalled = false.obs;

  // textfield
  final TextEditingController storyTiteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();

  // pages
  RxInt rxCurrentPageIndex = 0.obs;

  // toggle
  final RxBool rxToggle = false.obs;

  //filter
  Rxn<FiltersResponse> rxSelectedStoryType = Rxn<FiltersResponse>();
  Rxn<FiltersResponse> rxSelectedStoryStatus = Rxn<FiltersResponse>();
  Rxn<DropDownResponse> rxSelectedAsignee = Rxn<DropDownResponse>();
  Rxn<DropDownResponse> rxSelectedModule = Rxn<DropDownResponse>();
  Rxn<DropDownResponse> rxSelectedOption = Rxn<DropDownResponse>();

  //dates
  DateTime rxRequestedOn = DateTime.now();
  DateTime rxDueDate = DateTime.now();

  DateTime rxRequestDate = DateTime.now();
  DateTime rxPlannedStartDate = DateTime.now();
  DateTime rxPlannedEndDate = DateTime.now();

  // story
  Rxn<TaskResponse> rxCurrentTokenDetail = Rxn<TaskResponse>();
  Rxn<CreateStoryResponse> rxGenerateStoryResponse = Rxn<CreateStoryResponse>();

  //filter response
  RxList<FiltersResponse> rxStoryTypeList = <FiltersResponse>[].obs;
  RxList<FiltersResponse> rxStoryStatusList = <FiltersResponse>[].obs;
  RxList<DropDownResponse> rxAssigneeList = <DropDownResponse>[].obs;
  RxList<DropDownResponse> rxModuleList = <DropDownResponse>[].obs;
  RxList<DropDownResponse> rxOptionsList = <DropDownResponse>[].obs;

  @override
  Future<void> onInit() async {
    isInitCalled(true);
    _setArguments();
    await fetchDropdownForStory(
        (rxCurrentTokenDetail.value?.projectId ?? "").toString(),
        "",
        (rxCurrentTokenDetail.value?.teamId ?? "").toString(),
        false);
    super.onInit();
  }

  /////////////////////////////
  Future<void> _setArguments() async {
    final arguments = Get.arguments;

    if (arguments != null && arguments[selectedTaskKey] != null) {
      rxCurrentTokenDetail.value =
          TaskResponse.fromJson(arguments[selectedTaskKey]);
    }
    setDefaultFilters();
  }

  ////////////////////////////////////////////////////////////////////////////// pages

  List<Widget> pageList = [
    const CreateStoryPage1(),
    const CreateStoryPage2(),
  ];

  List<Widget> editPageList = [
    const EditStoryPage1(),
    const EditStoryPage2(),
  ];

  void nextPage(bool isForward) {
    if (isForward) {
      if (rxCurrentPageIndex.value != pageList.length) {
        rxCurrentPageIndex.value++;
      } else {
        navigateTo(homePageRoute);
      }
    } else {
      if (rxCurrentPageIndex.value != 0) {
        rxCurrentPageIndex.value--;
      }
    }
  }

////////////////////////////////////////////////////////////////////////////// filter

  void setDefaultFilters() {
    hoursController.text = "00";
    minutesController.text = "00";
  }

  //////////////////////////////// CREATE STORY /////////////////////////////////

  Future<bool> callGenerateStory() async {
    try {
      showLoader();
      String id = myApp.preferenceHelper!.getString(employeeIdKey);

      if (requiredDataSelected()) {
        var generateStoryRequestList = [
          CommonRequest(attribute: "transType", value: "INSERT"),
          CommonRequest(attribute: "transSubType", value: "INSERT"),
          CommonRequest(
              attribute: "Description", value: descriptionController.text),
          CommonRequest(
              attribute: "EstimateTime",
              value:
                  "${hoursController.text.trim()}.${minutesController.text.trim()}"),
          CommonRequest(
              attribute: "RequestDate",
              value: DateHelper().formatForApi(rxRequestDate)),
          CommonRequest(
              attribute: "PlannedStartDate",
              value: DateHelper().formatForApi(rxPlannedStartDate)),
          CommonRequest(
              attribute: "PlannedEndDate",
              value: DateHelper().formatForApi(rxPlannedEndDate)),
          CommonRequest(attribute: "RequestID", value: "0"),
          CommonRequest(
              attribute: "StoryTypeMccID",
              value: (rxSelectedStoryType.value?.mccId ?? "").toString()),
          CommonRequest(
              attribute: "ModuleID",
              value: (rxSelectedModule.value?.id ?? "").toString()),
          CommonRequest(
              attribute: "OptionID",
              value: (rxSelectedOption.value?.id ?? "").toString()),
          CommonRequest(
              attribute: "CurrentStatusMccID",
              value: (rxSelectedStoryStatus.value?.mccId ?? "").toString()),
          CommonRequest(
              attribute: "ParentRequestID",
              value: rxCurrentTokenDetail.value?.requestId ?? ""),
          CommonRequest(
              attribute: "AssigneeID",
              value: (rxSelectedAsignee.value?.id ?? "").toString()),
          CommonRequest(attribute: "LoginEmpID", value: id),
        ];
        CreateStoryResponse? response =
            await _taskServices.createStory(generateStoryRequestList);
        if (response != null) {
          rxGenerateStoryResponse.value = response;
          clearFieldsAfterStoryCreation();
          return true;
        }
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  bool requiredDataSelected() {
    if (isNullOrEmpty(descriptionController.text) ||
        isNullOrEmpty(hoursController.text) ||
        isNullOrEmpty(minutesController.text)) {
      showErrorSnackbar(message: "Missing Fields");
      return false;
    }

    return true;
  }

  bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  void clearFieldsAfterStoryCreation() {
    storyTiteController.clear();
    descriptionController.clear();
    hoursController.clear();
    minutesController.clear();
    rxDueDate = DateTime.now();
    rxRequestedOn = DateTime.now();
    rxCurrentPageIndex.value = 0;
  }

  ///////////////////////////////// DROPDOWNS ////////////////////////////////////

  Future<void> fetchDropdownForStory(String projectId, String moduelID,
      String teamID, bool loaderEnabled) async {
    await fetchFilters(
        "STORY_TYPE", rxStoryTypeList, rxSelectedStoryType, loaderEnabled);
    await fetchFilters("STORY_STATUS", rxStoryStatusList, rxSelectedStoryStatus,
        loaderEnabled);
    await fetchDropdowns(projectId, moduelID, teamID, "ASSIGNEE",
        rxAssigneeList, rxSelectedAsignee, "TOKEN", loaderEnabled);
    await fetchDropdowns(projectId, moduelID, teamID, "MODULE", rxModuleList,
        rxSelectedModule, "TOKEN", loaderEnabled);
    await fetchDropdowns(projectId, moduelID, teamID, "OPTION", rxOptionsList,
        rxSelectedOption, "TOKEN", loaderEnabled);
  }

  Future<bool> fetchDropdowns(
      String projectId,
      String moduleId,
      String teamId,
      String flag,
      RxList updateList,
      Rxn selectedList,
      String issueType,
      bool loaderEnabled) async {
    try {
      if (loaderEnabled) {
        showLoader();
      }
      if (projectId.isEmpty || projectId == "") {
        showErrorSnackbar(message: "Error finding project id");
        rxCurrentPageIndex.value = 0;
        return false;
      }
      String id = myApp.preferenceHelper!.getString(employeeIdKey);
      var dropdownRequestsList = [
        CommonRequest(attribute: "transType", value: "LIST"),
        CommonRequest(attribute: "transSubType", value: "DROP_DOWNS"),
        CommonRequest(attribute: "Date", value: ""),
        CommonRequest(attribute: "flag", value: flag),
        CommonRequest(attribute: "ProjectID", value: projectId),
        CommonRequest(attribute: "ModuleID", value: ""),
        CommonRequest(attribute: "TeamID", value: teamId),
        CommonRequest(attribute: "EmployeeID", value: id),
        CommonRequest(attribute: "StoryTypeMccID", value: ""),
        CommonRequest(attribute: "IssueType", value: issueType),
      ];
      List<DropDownResponse>? response =
          await _taskServices.callDropdowns(dropdownRequestsList);
      if (response != null) {
        updateList.clear();
        updateList.value = response;
        selectedList.value = updateList.isNotEmpty ? updateList[0] : null;
        return true;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  Future<bool> fetchFilters(String flag, RxList updateList, Rxn selectedList,
      bool loaderEnabled) async {
    try {
      if (loaderEnabled) {
        showLoader();
      }
      String id = myApp.preferenceHelper!.getString(employeeIdKey);
      var filterRequestsList = [
        CommonRequest(attribute: "transType", value: "LIST"),
        CommonRequest(attribute: "transSubType", value: "DropDown"),
        CommonRequest(attribute: "EmployeeID", value: id),
        CommonRequest(attribute: "flag", value: flag),
      ];
      List<FiltersResponse>? response =
          await _taskServices.callFilter(filterRequestsList);
      if (response != null) {
        updateList.clear();
        updateList.value = response;
        selectedList.value = updateList.isNotEmpty ? updateList[0] : null;
        return true;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  //////////////////////////////////////////////////////////////////////////////

  Future<bool> fetchInitData() async {
    return true;
  }
}
