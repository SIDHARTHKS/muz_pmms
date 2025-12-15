import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/model/app_model.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/model/task_model.dart';
import 'package:pmms/service/task_services.dart';
import 'package:pmms/view/createToken/pages/create_token_page1.dart';
import 'package:pmms/view/createToken/pages/create_token_page2.dart';
import 'package:pmms/view/createToken/pages/create_token_page3.dart';
import '../helper/app_message.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/enum.dart';

class CreateTokenController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final TaskServices _taskServices = Get.find<TaskServices>();
  //
  final isInitCalled = false.obs;

  // textfield
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController additionaldescriptionController =
      TextEditingController();
  final TextEditingController clientRefIdController = TextEditingController();

  // pages
  RxInt rxCurrentPageIndex = 0.obs;

  // toggle
  final RxBool rxToggle = false.obs;

  //filter
  Rxn<FiltersResponse> rxSelectedProject = Rxn<FiltersResponse>();
  Rxn<FiltersResponse> rxSelectedRequest = Rxn<FiltersResponse>();
  Rxn<FiltersResponse> rxSelectedPriority = Rxn<FiltersResponse>();
  Rxn<DropDownResponse> rxSelectedTeam = Rxn<DropDownResponse>();
  Rxn<DropDownResponse> rxSelectedModule = Rxn<DropDownResponse>();
  Rxn<DropDownResponse> rxSelectedOption = Rxn<DropDownResponse>();
  Rxn<DropDownResponse> rxSelectedAsignee = Rxn<DropDownResponse>();
  Rxn<DropDownResponse> rxSelectedRequestedBy = Rxn<DropDownResponse>();

  //dates

  DateTime rxRequestedOn = DateTime.now();
  DateTime rxDueDate = DateTime.now();

  // responses
  Rxn<CreateTokenResponse> rxGenerateTokenResponse = Rxn<CreateTokenResponse>();
  RxList<FiltersResponse> rxProjectsList = <FiltersResponse>[].obs;
  RxList<FiltersResponse> rxPriorityList = <FiltersResponse>[].obs;
  RxList<FiltersResponse> rxRequestList = <FiltersResponse>[].obs;
  //
  RxList<DropDownResponse> rxTeamList = <DropDownResponse>[].obs;
  RxList<DropDownResponse> rxModuleList = <DropDownResponse>[].obs;
  RxList<DropDownResponse> rxOptionsList = <DropDownResponse>[].obs;
  RxList<DropDownResponse> rxAssigneeList = <DropDownResponse>[].obs;
  RxList<DropDownResponse> rxRequestedByList = <DropDownResponse>[].obs;

  @override
  Future<void> onInit() async {
    isInitCalled(true);
    fetchInitData();
    super.onInit();
  }

  ////////////////////////////////////////////////////////////////////////////// pages

  List<Widget> pageList = [
    const CreateTokenPage1(),
    const CreateTokenPage2(),
    const CreateTokenPage3()
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

  bool checkIsFilled() {
    if (descriptionController.text.isEmpty) {
      showErrorSnackbar(message: "Please enter description");
      return false;
    }
    return true;
  }
  ////////////////////////////////////////////////////////////////////////////// filter

  List<String> tokenTypes = ['Pending', 'Approved', 'Rejected', 'In Progress'];

  void setDefaultFilters() {
    rxSelectedProject.value = rxProjectsList[0];
    rxSelectedRequest.value = rxRequestList[0];
    rxSelectedPriority.value = rxPriorityList[0];
  }

  //////////////////////////////////////////////////////////////////////////////

  Future<bool> callGenerateToken() async {
    try {
      showLoader();
      String id = myApp.preferenceHelper!.getString(employeeIdKey);

      if (requiredDataSelected()) {
        var generateTokenRequestList = [
          CommonRequest(attribute: "transType", value: "INSERT"),
          CommonRequest(attribute: "transSubType", value: "INSERT"),
          CommonRequest(attribute: "IssueType", value: "TOKEN"),
          CommonRequest(
              attribute: "Description", value: descriptionController.text),
          CommonRequest(
              attribute: "AdditionalInfo",
              value: additionaldescriptionController.text),
          CommonRequest(attribute: "Attachments", value: ""),
          CommonRequest(attribute: "RequestID", value: "0"),
          CommonRequest(attribute: "LoginEmpID", value: id),
          CommonRequest(
              attribute: "ProjectID",
              value: rxSelectedProject.value?.mccId ?? ""), /////doubt
          CommonRequest(attribute: "TeamID", value: ""),
          CommonRequest(attribute: "ModuleID", value: ""),
          CommonRequest(attribute: "OptionID", value: ""),
          CommonRequest(attribute: "AssigneeID", value: ""),
          CommonRequest(attribute: "RequestTypeMccID", value: ""), //
          CommonRequest(attribute: "RequestedByID", value: ""), //
          CommonRequest(attribute: "PriorityMccID", value: ""), //
          CommonRequest(attribute: "CurrentStatusMccID", value: ""), //
          CommonRequest(attribute: "ClientRefID", value: ""), //
          CommonRequest(attribute: "RequestOnDate", value: ""), //
          CommonRequest(attribute: "DueDate", value: ""), //
        ];
        CreateTokenResponse? response =
            await _taskServices.createToken(generateTokenRequestList);
        if (response != null) {
          rxGenerateTokenResponse.value = response;
          clearFieldsAfterTokenCreation();
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
    if (isNullOrEmpty(rxSelectedProject.value?.mccId) ||
        isNullOrEmpty(descriptionController.text) ||
        isNullOrEmpty(rxSelectedPriority.value?.mccId)) {
      showErrorSnackbar(message: "Missing Ids");
      return false;
    }

    return true;
  }

  bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  void clearFieldsAfterTokenCreation() {
    descriptionController.clear();
    additionaldescriptionController.clear();
    rxDueDate = DateTime.now();
    rxRequestedOn = DateTime.now();
    rxCurrentPageIndex.value = 0;
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

  Future<void> callAndSetFilters(bool loaderEnabled) async {
    bool setProject =
        await fetchFilters(typeProject, rxProjectsList, loaderEnabled);
    bool setPriority =
        await fetchFilters(typePriority, rxPriorityList, loaderEnabled);
    bool setRequest =
        await fetchFilters(typeRequest, rxRequestList, loaderEnabled);
    if (setProject && setPriority && setRequest) {
      setDefaultFilters();
    } else {
      showErrorSnackbar(message: "Failed to load filters");
      navigateToAndRemove(homePageRoute);
    }
  }

  Future<void> fetchProjectBasedDropdown(String projectId, String moduelID,
      String teamID, bool loaderEnabled) async {
    await fetchDropdowns(projectId, moduelID, teamID, "TEAM", rxTeamList,
        rxSelectedTeam, "TOKEN", loaderEnabled);
    await fetchDropdowns(projectId, moduelID, teamID, "MODULE", rxModuleList,
        rxSelectedModule, "TOKEN", loaderEnabled);
    await fetchDropdowns(projectId, moduelID, teamID, "OPTION", rxOptionsList,
        rxSelectedOption, "TOKEN", loaderEnabled);
    // await fetchDropdowns(projectId, moduelID, teamID, "ASSIGNEE",
    //     rxAssigneeList, rxSelectedAsignee, "TOKEN", loaderEnabled);
    await fetchAssigneDropdown(
        projectId, moduelID, rxSelectedTeam.value?.id ?? "", loaderEnabled);
  }

  Future<void> fetchAssigneDropdown(String projectId, String moduelID,
      String teamID, bool loaderEnabled) async {
    await fetchDropdowns(projectId, moduelID, teamID, "ASSIGNEE",
        rxAssigneeList, rxSelectedAsignee, "TOKEN", loaderEnabled);
  }

  Future<void> fetchRequestedByDropdown(String projectId, String moduelID,
      String teamID, bool loaderEnabled) async {
    await fetchDropdowns(projectId, moduelID, teamID, "REQUESTEDBY",
        rxRequestedByList, rxSelectedRequestedBy, "TOKEN", loaderEnabled);
  }

  ///////////////////////////////////////////////////////////////////////////////

  Future<bool> fetchInitData() async {
    await callAndSetFilters(false);
    await fetchProjectBasedDropdown(
        rxSelectedProject.value?.mccId ?? '', "", "", false);
    return true;
  }
}
