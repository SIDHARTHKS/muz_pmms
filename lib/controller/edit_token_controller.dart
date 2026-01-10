import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/controller/tasks_controller.dart';
import 'package:pmms/helper/app_message.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/date_helper.dart';
import 'package:pmms/helper/enum.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/model/app_model.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/service/task_services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../helper/core/base/app_base_controller.dart';
import '../model/task_model.dart';

class EditTokenController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final TaskServices _taskServices = Get.find<TaskServices>();
  final TasksController tasksController = Get.find<TasksController>();
  final RefreshController pullController = RefreshController();
  //
  final isInitCalled = false.obs;

  // description edit
  TextEditingController descriptionController = TextEditingController();
  RxString actualDescription = "".obs;
  RxBool rxDescriptionChanged = false.obs;

  // selected task/story details
  Rxn<TaskResponse> rxSelectedToken = Rxn<TaskResponse>();

  //filter selection
  Rxn<FiltersResponse> rxSelectedProject = Rxn<FiltersResponse>();
  Rxn<DropDownResponse> rxSelectedTeam = Rxn<DropDownResponse>();
  Rxn<DropDownResponse> rxSelectedModule = Rxn<DropDownResponse>();
  Rxn<DropDownResponse> rxSelectedOption = Rxn<DropDownResponse>();
  Rxn<DropDownResponse> rxSelectedAsignee = Rxn<DropDownResponse>();
  Rxn<DropDownResponse> rxSelectedRequestedBy = Rxn<DropDownResponse>();

  RxBool rxEdited = false.obs;

  //dates

  DateTime rxRequestedOn = DateTime.now();
  DateTime rxDueDate = DateTime.now();

  // responses
  RxList<FiltersResponse> rxProjectsList = <FiltersResponse>[].obs;
  //
  RxList<DropDownResponse> rxTeamList = <DropDownResponse>[].obs;
  RxList<DropDownResponse> rxModuleList = <DropDownResponse>[].obs;
  RxList<DropDownResponse> rxOptionsList = <DropDownResponse>[].obs;
  RxList<DropDownResponse> rxAssigneeList = <DropDownResponse>[].obs;
  RxList<DropDownResponse> rxRequestedByList = <DropDownResponse>[].obs;

  // edited list
  RxList<TaskResponse> rxNewTasks = <TaskResponse>[].obs;
  Rxn<TaskResponse> rxEditedToken = Rxn<TaskResponse>();

  @override
  Future<void> onInit() async {
    isInitCalled(true);
    await _setArguments();
    await _setFields();
    super.onInit();
  }

  //////////////////////////////// SETTING EDITED TASK ////////////////////////////////

  Future<void> setEditedTask() async {
    final success = await fetchTasks();
    if (!success) return;

    final selectedId = rxSelectedToken.value?.requestId;
    if (selectedId == null) return;

    rxEditedToken.value = rxNewTasks.firstWhereOrNull(
      (x) => x.requestId == selectedId,
    );
    if (rxEditedToken.value != null) {
      rxSelectedToken.value = rxEditedToken.value;
      rxSelectedToken.refresh();
      rxEdited(false);
    }
  }

  //////////////////////////////// FETCHING/SETTING TASK ////////////////////////////////

  Future<void> _setArguments() async {
    final arguments = Get.arguments;
    if (arguments != null && arguments[selectedEditTokenKey] != null) {
      rxSelectedToken.value =
          TaskResponse.fromJson(arguments[selectedEditTokenKey]);
      handleDescription(rxSelectedToken.value!);
    } else {
      showErrorSnackbar(message: "Could not set data .");
      goBack();
    }
  }

  Future<void> _setFields() async {
    actualDescription.value = rxSelectedToken.value?.description ?? "--";
    await fetchFilters(typeProject, rxProjectsList, false);
    setDropdownSelectedById(
      selectedRx: rxSelectedProject,
      source: rxProjectsList,
      matchId: rxSelectedToken.value?.projectId?.toString(),
    );

    await fetchProjectBasedDropdown(
        rxSelectedProject.value?.mccId ?? "0", "", "", false);
  }

  void setProjectBasedFields() async {
    setDropdownSelectedById(
      selectedRx: rxSelectedTeam,
      source: rxTeamList,
      matchId: rxSelectedToken.value?.teamId?.toString(),
    );
    setDropdownSelectedById(
      selectedRx: rxSelectedModule,
      source: rxModuleList,
      matchId: rxSelectedToken.value?.moduleId?.toString(),
    );
    setDropdownSelectedById(
      selectedRx: rxSelectedOption,
      source: rxOptionsList,
      matchId: rxSelectedToken.value?.optionId?.toString(),
    );
    setDropdownSelectedById(
      selectedRx: rxSelectedAsignee,
      source: rxAssigneeList,
      matchId: rxSelectedToken.value?.assigneeId?.toString(),
    );
    await fetchRequestedByDropdown(
        rxSelectedProject.value?.mccId ?? '',
        rxSelectedModule.value?.id ?? '',
        rxSelectedTeam.value?.id ?? '',
        false);
    if (rxRequestedByList.isNotEmpty) {
      rxSelectedRequestedBy.value = rxRequestedByList.firstWhereOrNull(
        (x) =>
            x.name?.toLowerCase() ==
            rxSelectedToken.value?.requestedBy?.toLowerCase(),
      );
    }
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

  Future<void> fetchProjectBasedDropdown(String projectId, String moduelID,
      String teamID, bool loaderEnabled) async {
    bool teamFetched = await fetchDropdowns(projectId, moduelID, teamID, "TEAM",
        rxTeamList, rxSelectedTeam, "TOKEN", loaderEnabled);

    bool moduleFetched = await fetchDropdowns(projectId, moduelID, teamID,
        "MODULE", rxModuleList, rxSelectedModule, "TOKEN", loaderEnabled);

    bool optionFetched = await fetchDropdowns(projectId, moduelID, teamID,
        "OPTION", rxOptionsList, rxSelectedOption, "TOKEN", loaderEnabled);
    if (teamFetched && moduleFetched && optionFetched) {
      setProjectBasedFields();
    } else {
      showErrorSnackbar(message: "Could not fetch required details.");
      goBack();
    }
  }

  Future<void> fetchRequestedByDropdown(String projectId, String moduelID,
      String teamID, bool loaderEnabled) async {
    await fetchDropdowns(projectId, moduelID, teamID, "REQUESTEDBY",
        rxRequestedByList, rxSelectedRequestedBy, "TOKEN", loaderEnabled);
  }

  ////////////////////////////////////////  EDIT DESCRIPTION  /////////////////////////////////////////

  void handleDescription(TaskResponse task) {
    final desc = actualDescription.value.isNotEmpty
        ? actualDescription.value
        : task.description ?? "--";

    descriptionController.text = desc;
    actualDescription.value = desc;
    rxDescriptionChanged.value = false;
  }

  void verifyDescriptionEdit(String value) {
    rxDescriptionChanged.value = value.trim() != actualDescription.value.trim();
    rxEdited(rxDescriptionChanged.value);
  }

  void handleSaveDescription(TaskResponse task) {
    if (!rxDescriptionChanged.value) return;

    final newValue = descriptionController.text.trim();

    actualDescription.value = newValue;
    task.description = newValue;
    rxDescriptionChanged.value = false;
  }

  ////////////////////////////////////////  API CALL  /////////////////////////////////////////

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

  Future<bool> fetchFilters(
      String flag, RxList updateList, bool loaderEnabled) async {
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
        return true;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  Future<bool> callUpdateToken() async {
    try {
      showLoader();
      String id = myApp.preferenceHelper!.getString(employeeIdKey);
      final TaskResponse? token = rxSelectedToken.value;
      var generateTokenRequestList = [
        CommonRequest(attribute: "transType", value: "INSERT"),
        CommonRequest(attribute: "transSubType", value: "UPDATE"),
        CommonRequest(attribute: "IssueType", value: "TOKEN"),
        CommonRequest(
            attribute: "Description", value: descriptionController.text),
        CommonRequest(attribute: "AdditionalInfo", value: ""),
        CommonRequest(attribute: "Attachments", value: ""),
        CommonRequest(attribute: "RequestID", value: token?.requestId ?? ""),
        CommonRequest(attribute: "LoginEmpID", value: id),
        CommonRequest(
            attribute: "ProjectID",
            value: rxSelectedProject.value?.mccId ?? ""),
        CommonRequest(
            attribute: "TeamID", value: rxSelectedTeam.value?.id ?? ""),
        CommonRequest(
            attribute: "ModuleID", value: rxSelectedModule.value?.id ?? ""),
        CommonRequest(
            attribute: "OptionID", value: rxSelectedOption.value?.id ?? ""),
        CommonRequest(
            attribute: "AssigneeID", value: (token?.assigneeId.toString())),
        CommonRequest(
            attribute: "RequestTypeMccID",
            value: token?.requestTypeId.toString()),
        CommonRequest(
            attribute: "RequestedByID", value: rxSelectedRequestedBy.value?.id),
        CommonRequest(
            attribute: "PriorityMccID", value: (token?.priorityId.toString())),
        CommonRequest(
            attribute: "CurrentStatusMccID",
            value: token?.currentStatusId.toString()),
        CommonRequest(
            attribute: "ClientRefID", value: token?.clientRefId ?? "0"),
        CommonRequest(attribute: "RequestOnDate", value: ""), //doubt
        CommonRequest(attribute: "DueDate", value: ""), //doubt
      ];
      bool? response =
          await _taskServices.approveRejectToken(generateTokenRequestList);
      if (response != null) {
        return response;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
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
        rxNewTasks.clear();
        rxNewTasks.value = response;
        return true;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  Future<bool> fetchInitData() async {
    return true;
  }
}
