import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/story_details_controller.dart';
import 'package:pmms/controller/tasks_controller.dart';
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

class EditStoryController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final TaskServices _taskServices = Get.find<TaskServices>();
  late TasksController tasksController = Get.find<TasksController>();
  late StoryDetailsController storyDetailsController =
      Get.find<StoryDetailsController>();
  //
  final isInitCalled = false.obs;

  // textfield
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

  Rx<DateTime> rxRequestDate = DateTime.now().obs;
  Rx<DateTime> rxOriginalStartDate = DateTime.now().obs;
  Rx<DateTime> rxOriginalEndDate = DateTime.now().obs;
  Rx<DateTime> rxPlannedStartDate = DateTime.now().obs;
  Rx<DateTime> rxPlannedEndDate = DateTime.now().obs;

  // story
  Rxn<StoryList> rxCurrentStoryDetail = Rxn<StoryList>();
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
    setDefaultFilters();
    await fetchDropdownForStory(
        (rxCurrentStoryDetail.value?.projectId ?? "").toString(),
        (rxCurrentStoryDetail.value?.moduleId ?? "").toString(),
        (rxCurrentStoryDetail.value?.teamId ?? "").toString(),
        false);
    super.onInit();
  }

  /////////////////////////////
  Future<void> _setArguments() async {
    final arguments = Get.arguments;

    if (arguments != null && arguments[currentStoryKey] != null) {
      rxCurrentStoryDetail.value =
          StoryList.fromJson(arguments[currentStoryKey]);
    }
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
    setEstimateTime(rxCurrentStoryDetail.value?.estimateTime ?? "00.00");
    descriptionController.text = rxCurrentStoryDetail.value?.description ?? "";
    setDateFromString(
        rxCurrentStoryDetail.value?.plannedStartDate ?? "", rxPlannedStartDate);
    setDateFromString(
        rxCurrentStoryDetail.value?.plannedEndDate ?? "", rxPlannedEndDate);
    setDateFromString(
        rxCurrentStoryDetail.value?.requestDateTime ?? "", rxRequestDate);
  }

  void setDropdownSelectedById<T>({
    required Rxn<T> selectedRx,
    required List<T> source,
    required String? matchId,
  }) {
    if (source.isEmpty) {
      selectedRx.value = null;
      return;
    }

    selectedRx.value = source.firstWhereOrNull((item) {
          final dynamic d = item;

          String? id;

          // ✅ SAFE property access
          if (d is DropDownResponse) {
            id = d.id;
          } else if (d is FiltersResponse) {
            id = d.mccId;
          }

          return id?.toString() == matchId;
        }) ??
        source.first;
  }

  void setDateFromString(
    String dateStr,
    Rx<DateTime> target,
  ) {
    if (dateStr.isEmpty || dateStr.startsWith("0000")) {
      target.value = DateTime.now();
      return;
    }

    final parsed = DateTime.tryParse(dateStr);
    if (parsed != null) {
      target.value = parsed;
    }
  }

  void setEstimateTime(String estimate) {
    final parts = estimate.split('.');

    final hours = parts.isNotEmpty ? parts[0] : "0";
    final minutes = parts.length > 1 ? parts[1] : "0";

    hoursController.text = hours.padLeft(2, '0');
    minutesController.text = minutes.padLeft(2, '0');
  }

  //////////////////////////////// EDIT STORY /////////////////////////////////

  Future<bool> callEditStory() async {
    try {
      showLoader();
      String id = myApp.preferenceHelper!.getString(employeeIdKey);
      var story = rxCurrentStoryDetail.value;
      if (requiredDataSelected()) {
        var generateStoryRequestList = [
          CommonRequest(attribute: "transType", value: "INSERT"),
          CommonRequest(attribute: "transSubType", value: "EDIT"),
          CommonRequest(
              attribute: "Description", value: descriptionController.text),
          CommonRequest(
              attribute: "EstimateTime",
              value:
                  "${hoursController.text.trim()}.${minutesController.text.trim()}"),
          CommonRequest(
              attribute: "RequestDate",
              value: DateHelper().formatForApi(rxRequestDate.value)),
          CommonRequest(
              attribute: "PlannedStartDate",
              value: DateHelper().formatForApi(rxPlannedStartDate.value)),
          CommonRequest(
              attribute: "PlannedEndDate",
              value: DateHelper().formatForApi(rxPlannedEndDate.value)),
          CommonRequest(attribute: "RequestID", value: story?.requestId ?? "0"),
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
              value: rxCurrentStoryDetail.value?.requestId ?? ""),
          CommonRequest(
              attribute: "AssigneeID",
              value: (rxSelectedAsignee.value?.id ?? "").toString()),
          CommonRequest(attribute: "LoginEmpID", value: id),
          CommonRequest(
              attribute: "OrginalStratDate",
              value: DateHelper().formatForApi(rxOriginalStartDate.value)),
          CommonRequest(
              attribute: "OrginalEndDate",
              value: DateHelper().formatForApi(rxOriginalEndDate.value)),
          CommonRequest(
              attribute: "Attachments", value: story?.attachment ?? ""),
          CommonRequest(attribute: "Links", value: story?.attachment ?? ""),
        ];
        CreateStoryResponse? response =
            await _taskServices.createStory(generateStoryRequestList);
        if (response != null) {
          rxGenerateStoryResponse.value = response;
          clearFieldsAfterStoryEdit();
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

  void clearFieldsAfterStoryEdit() {
    descriptionController.clear();
    hoursController.clear();
    minutesController.clear();
    rxCurrentPageIndex.value = 0;
  }

  ///////////////////////////////// DROPDOWNS ////////////////////////////////////

  Future<void> fetchDropdownForStory(String projectId, String moduelID,
      String teamID, bool loaderEnabled) async {
    await fetchFilters(
        "STORY_TYPE", rxStoryTypeList, rxSelectedStoryType, loaderEnabled);
    final matchedStoryType = rxStoryTypeList.firstWhereOrNull(
      (e) =>
          (e.mccName ?? "").toLowerCase() ==
          (rxCurrentStoryDetail.value?.storyType ?? "").toLowerCase(),
    );
    if (matchedStoryType != null) {
      setDropdownSelectedById(
        selectedRx: rxSelectedStoryType,
        source: rxStoryTypeList,
        matchId: matchedStoryType.mccId?.toString(),
      );
    }
    await fetchAssignee();
    setDropdownSelectedById(
      selectedRx: rxSelectedAsignee,
      source: rxAssigneeList,
      matchId: rxCurrentStoryDetail.value?.assigneeId?.toString(),
    );
    await fetchFilters("STORY_STATUS", rxStoryStatusList, rxSelectedStoryStatus,
        loaderEnabled);
    await fetchModule();
    await fetchOption();
  }

  Future<void> fetchAssignee() async {
    await fetchDropdowns(
        (rxCurrentStoryDetail.value?.projectId ?? "").toString(),
        "",
        (rxCurrentStoryDetail.value?.teamId ?? "").toString(),
        "ASSIGNEE",
        rxAssigneeList,
        rxSelectedAsignee,
        "STORY",
        rxSelectedStoryType.value?.mccId ?? "0",
        false);
  }

  Future<void> fetchModule() async {
    await fetchDropdowns(
        (rxCurrentStoryDetail.value?.projectId ?? "").toString(),
        "",
        (rxCurrentStoryDetail.value?.teamId ?? "").toString(),
        "MODULE",
        rxModuleList,
        rxSelectedModule,
        "TOKEN",
        rxSelectedStoryType.value?.mccId ?? "0",
        false);
  }

  Future<void> fetchOption() async {
    await fetchDropdowns(
        (rxCurrentStoryDetail.value?.projectId ?? "").toString(),
        (rxCurrentStoryDetail.value?.moduleId ?? "").toString(),
        (rxCurrentStoryDetail.value?.teamId ?? "").toString(),
        "OPTION",
        rxOptionsList,
        rxSelectedOption,
        "TOKEN",
        rxSelectedStoryType.value?.mccId ?? "0",
        false);
  }

  ////////////////////////////////////////////// FILTER AND DROPDOWN API CALL   /////////////////////////////////////////////

  Future<bool> fetchDropdowns(
      String projectId,
      String moduleId,
      String teamId,
      String flag,
      RxList updateList,
      Rxn selectedList,
      String issueType,
      String storyType,
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
        CommonRequest(attribute: "StoryTypeMccID", value: storyType),
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
