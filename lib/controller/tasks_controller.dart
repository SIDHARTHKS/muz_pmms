import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/date_helper.dart';
import 'package:pmms/helper/enum.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/model/app_model.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/service/task_services.dart';
import 'package:pmms/view/tasks/tabviews/story/story_view.dart';
import 'package:pmms/view/tasks/tabviews/pl/pl_tokens_view.dart';
import 'package:pmms/view/tasks/tabviews/tl/tl_token_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../helper/app_message.dart';
import '../helper/core/base/app_base_controller.dart';
import '../model/task_model.dart';

class TasksController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  final TaskServices _taskServices = Get.find<TaskServices>();
  final RefreshController pullController = RefreshController();
  //
  final isInitCalled = false.obs;

  // tab
  RxInt rxTabIndex = 0.obs;

  // date
  DateTimeRange? selectedDateRange;

  // searchbar
  TextEditingController searchController = TextEditingController();

  // tasks
  RxList<TaskResponse> rxTasksResponse = <TaskResponse>[].obs;
  RxList<TaskResponse> rxFilteredTasksResponse = <TaskResponse>[].obs;
  RxList<TaskResponse> rxDisplayedTasks = <TaskResponse>[].obs;
  //
  RxList<TaskResponse> rxTokens = <TaskResponse>[].obs;
  RxList<TaskResponse> rxStory = <TaskResponse>[].obs;

  // filter

  RxList<FiltersResponse> rxTaskFilterTypeList = <FiltersResponse>[].obs;
  RxList<FiltersResponse> rxTypeFilters = <FiltersResponse>[].obs;
  RxList<FiltersResponse> rxProjectFilters = <FiltersResponse>[].obs;
  RxList<FiltersResponse> rxPriorityFilters = <FiltersResponse>[].obs;
  RxList<FiltersResponse> rxRequestFilters = <FiltersResponse>[].obs;

  var rxSelectedTokenTypes = <FiltersResponse>[].obs;
  var rxSelectedProjects = <FiltersResponse>[].obs;
  var rxSelectedPriority = <FiltersResponse>[].obs;
  var rxSelectedRequestTypes = <FiltersResponse>[].obs;

  RxInt tokenTypeFilterCount = 0.obs;
  RxInt projectTypeFilterCount = 0.obs;
  RxInt priorityTypeFilterCount = 0.obs;
  RxInt requestTypeFilterCount = 0.obs;
  RxInt totalFilterCount = 0.obs;

  // selected task/story details
  Rxn<TaskResponse> rxSelectedToken = Rxn<TaskResponse>();
  Rxn<TaskResponse> rxSelectedStory = Rxn<TaskResponse>();
  Rxn<StoryList> rxFetchedStory = Rxn<StoryList>();
  RxList<StoryList> rxFetchedStories = <StoryList>[].obs;

  // scroll controller
  final Map<int, ScrollController> horizontalScrollControllers = {};
  final Map<int, RxBool> hasHorizontalOverflow = {};

  @override
  Future<void> onInit() async {
    isInitCalled(true);
    fetchInitData();
    super.onInit();
  }

  @override
  void onClose() {
    for (final controller in horizontalScrollControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  ScrollController getHorizontalScrollController(int index) {
    return horizontalScrollControllers.putIfAbsent(index, () {
      final controller = ScrollController();

      controller.addListener(() => _checkHorizontalOverflow(index));

      // 🔥 IMPORTANT: check once AFTER first layout
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkHorizontalOverflow(index);
      });

      return controller;
    });
  }

  RxBool hasOverflow(int index) {
    return hasHorizontalOverflow.putIfAbsent(index, () => false.obs);
  }

  void _checkHorizontalOverflow(int index) {
    final controller = horizontalScrollControllers[index];
    if (controller == null || !controller.hasClients) return;
    hasHorizontalOverflow[index]?.value =
        controller.position.maxScrollExtent > 0;
  }

  void resetHorizontalScrollState() {
    // Dispose all scroll controllers
    for (final controller in horizontalScrollControllers.values) {
      controller.dispose();
    }

    // Clear controllers map
    horizontalScrollControllers.clear();

    // Reset overflow indicators
    for (final rx in hasHorizontalOverflow.values) {
      rx.value = false;
    }

    // Clear overflow map
    hasHorizontalOverflow.clear();
  }

  //////////////////////////////// DATE RANGE ////////////////////////////////
  void setDateRange() {
    selectedDateRange = DateTimeRange(
      start: DateTime.now(), // today
      end: DateTime.now().add(const Duration(days: 7)), // 7 days from today
    );
  }

  //////////////////////////////// TASK/STORY ////////////////////////////////

  Future<void> setStory(TaskResponse task) async {
    rxSelectedStory(task);
  }

  //////////////////////////////// FETCHING/SETTING TASK ////////////////////////////////

  Future<void> _setArguments() async {
    // var arguments = Get.arguments;
    // var task = arguments[tasksDataKey];
    // if (arguments != null) {
    //   rxTasksResponse(task);
    //   rxFilteredTasksResponse(task);
    //   rxDisplayedTasks(rxFilteredTasksResponse);
    //   splitDisplayedTasks();
    // } else {
    //   showErrorSnackbar(
    //       message: "Unable To Fetch Task Details. Please Login Again");
    //   navigateToAndRemoveAll(loginPageRoute);
    // }
  }

  /////////////////////// REFRESH ///////////////////////

  Future<void> refreshTasks(bool showLoader) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final success = await fetchTasks(showLoader);
      if (success) {
        resetsetFilters();
        pullController.refreshCompleted();
      } else {
        pullController.refreshFailed();
      }
    } catch (e) {
      pullController.refreshFailed();
    }
  }

  Future<bool> fetchTasks(bool loader) async {
    try {
      if (loader) {
        showLoader();
      }
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
        rxTasksResponse.clear();
        rxTasksResponse.value = response;
        splitDisplayedTasks();
        return true;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  //////////////////////////////// APPROVE TOKEN  ////////////////////////////////

  Future<bool> approveToken() async {
    try {
      showLoader();
      String id = myApp.preferenceHelper!.getString(employeeIdKey);
      var tkn = rxSelectedToken.value;
      var approveList = [
        CommonRequest(attribute: "transType", value: "LIST"),
        CommonRequest(attribute: "transSubType", value: "TOKEN_APPROVAL"),
        CommonRequest(attribute: "IssueType", value: "TOKEN"),
        CommonRequest(
            attribute: "Description", value: tkn?.description ?? "--"),
        CommonRequest(attribute: "AdditionalInfo", value: "--"),
        CommonRequest(attribute: "Attachments", value: tkn?.attachment ?? ""),
        CommonRequest(
            attribute: "RequestID", value: tkn?.requestId.toString() ?? ""),
        CommonRequest(attribute: "LoginEmpID", value: id),
        CommonRequest(
            attribute: "ProjectID", value: tkn?.projectId.toString() ?? ""),
        CommonRequest(attribute: "TeamID", value: tkn?.teamId.toString() ?? ""),
        CommonRequest(
            attribute: "ModuleID", value: tkn?.moduleId.toString() ?? ""),
        CommonRequest(
            attribute: "OptionID", value: tkn?.optionId.toString() ?? ""),
        CommonRequest(
            attribute: "AssigneeID", value: tkn?.assigneeId.toString() ?? ""),
        CommonRequest(
            attribute: "RequestTypeMccID",
            value: tkn?.requestTypeId.toString() ?? ""),
        CommonRequest(
            attribute: "RequestedByID", value: tkn?.requestedBy ?? ""),
        CommonRequest(
            attribute: "PriorityMccID",
            value: tkn?.priorityId.toString() ?? ""),
        CommonRequest(
            attribute: "CurrentStatusMccID",
            value: tkn?.currentStatusId.toString() ?? ""),
        CommonRequest(
            attribute: "ClientRefID", value: tkn?.clientRefId.toString() ?? ""),
        CommonRequest(
            attribute: "RequestOnDate",
            value: tkn?.requestDateTime.toString() ?? ""),
        CommonRequest(attribute: "DueDate", value: ""),
      ];
      bool? response = await _taskServices.approveRejectToken(approveList);
      if (response != null && response) {
        await refreshTasks(true);
        return response;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  //////////////////////////////// REJECT TOKEN  ////////////////////////////////

  Future<bool> rejectToken() async {
    try {
      showLoader();
      String id = myApp.preferenceHelper!.getString(employeeIdKey);
      var tkn = rxSelectedToken.value;
      var approveList = [
        CommonRequest(attribute: "transType", value: "LIST"),
        CommonRequest(attribute: "transSubType", value: "TOKEN_REJECTION"),
        CommonRequest(attribute: "IssueType", value: "TOKEN"),
        CommonRequest(
            attribute: "Description", value: tkn?.description ?? "--"),
        CommonRequest(attribute: "AdditionalInfo", value: "--"),
        CommonRequest(attribute: "Attachments", value: tkn?.attachment ?? ""),
        CommonRequest(
            attribute: "RequestID", value: tkn?.requestId.toString() ?? ""),
        CommonRequest(attribute: "LoginEmpID", value: id),
        CommonRequest(
            attribute: "ProjectID", value: tkn?.projectId.toString() ?? ""),
        CommonRequest(attribute: "TeamID", value: tkn?.teamId.toString() ?? ""),
        CommonRequest(
            attribute: "ModuleID", value: tkn?.moduleId.toString() ?? ""),
        CommonRequest(
            attribute: "OptionID", value: tkn?.optionId.toString() ?? ""),
        CommonRequest(
            attribute: "AssigneeID", value: tkn?.assigneeId.toString() ?? ""),
        CommonRequest(
            attribute: "RequestTypeMccID",
            value: tkn?.requestTypeId.toString() ?? ""),
        CommonRequest(
            attribute: "RequestedByID", value: tkn?.requestedBy ?? ""),
        CommonRequest(
            attribute: "PriorityMccID",
            value: tkn?.priorityId.toString() ?? ""),
        CommonRequest(
            attribute: "CurrentStatusMccID",
            value: tkn?.currentStatusId.toString() ?? ""),
        CommonRequest(
            attribute: "ClientRefID", value: tkn?.clientRefId.toString() ?? ""),
        CommonRequest(
            attribute: "RequestOnDate",
            value: tkn?.requestDateTime.toString() ?? ""),
        CommonRequest(attribute: "DueDate", value: ""),
      ];
      bool? response = await _taskServices.approveRejectToken(approveList);
      if (response != null && response) {
        await refreshTasks(true);
        return response;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  //////////////////////////////// STORY FETCH  ////////////////////////////////

  Future<bool> fetchStory(bool loader) async {
    try {
      if (loader) {
        showLoader();
      }
      await Future.delayed(const Duration(seconds: 2));
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

  Future<bool> fetchStories() async {
    try {
      showLoader();
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
        CommonRequest(
            attribute: "ParentRequestID",
            value: tkn?.parentRequestId.toString() ?? ""),
        CommonRequest(attribute: "AssigneeID", value: ""),
        CommonRequest(attribute: "LoginEmpID", value: id),
      ];
      List<StoryResponse>? response = await _taskServices.getStory(approveList);
      if (response != null && response.isNotEmpty) {
        rxFetchedStories.assignAll(response.first.storyList!);
        return true;
      }
    } catch (e) {
      appLog('$exceptionMsg $e', logging: Logging.error);
    } finally {
      hideLoader();
    }
    return false;
  }

  //////////////////////////////// FILTERS FETCH  ////////////////////////////////

  Future<void> _fetchFilters() async {
    await handleFilter(
      prefKey: typeFilterDataKey,
      apiFlag: "TOKEN_STATUS",
      targetList: rxTypeFilters,
    );

    await handleFilter(
      prefKey: priorityFilterDataKey,
      apiFlag: "PRIORITY",
      targetList: rxPriorityFilters,
    );

    await handleFilter(
      prefKey: projectFilterDataKey,
      apiFlag: "PROJECT",
      targetList: rxProjectFilters,
    );

    await handleFilter(
      prefKey: requestFilterDataKey,
      apiFlag: "REQUEST_TYPE",
      targetList: rxRequestFilters,
    );
  }

  Future<void> handleFilter({
    required String prefKey,
    required String apiFlag,
    required RxList<FiltersResponse> targetList,
  }) async {
    if (hasFilterData(prefKey)) {
      targetList.value = loadFilterList(prefKey);
      return;
    }

    // Fetch from API
    bool success = await fetchFilterData(apiFlag, targetList, false);
    if (success) {
      saveFilterList(prefKey, targetList);
    }
  }

  // CHECK PREF FOR FILTER

  bool hasFilterData(String key) {
    final data = myApp.preferenceHelper?.getString(key);
    return data != null && data.isNotEmpty;
  }

  // SAVE FILTER TO PREF
  void saveFilterList(String key, RxList<FiltersResponse> list) {
    final jsonString = jsonEncode(list.map((e) => e.toJson()).toList());
    myApp.preferenceHelper?.setString(key, jsonString);
  }

  // LOAD FILTER FROM PREF
  List<FiltersResponse> loadFilterList(String key) {
    final jsonString = myApp.preferenceHelper?.getString(key);
    if (jsonString == null || jsonString.isEmpty) return [];

    final decoded = jsonDecode(jsonString) as List;
    return decoded.map((e) => FiltersResponse.fromJson(e)).toList();
  }

  // FILTERS API CALL
  Future<bool> fetchFilterData(
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

  void resetsetFilters() {
    rxSelectedTokenTypes.clear();
    rxSelectedProjects.clear();
    rxSelectedPriority.clear();
    rxSelectedRequestTypes.clear();
    searchController.clear();
    rxFilteredTasksResponse.value = List<TaskResponse>.from(rxTasksResponse);
    rxDisplayedTasks.value = List<TaskResponse>.from(rxFilteredTasksResponse);
    splitDisplayedTasks();
    checkFilters();
  }

  void checkFilters() {
    tokenTypeFilterCount.value = rxSelectedTokenTypes.length;
    projectTypeFilterCount.value = rxSelectedProjects.length;
    priorityTypeFilterCount.value = rxSelectedPriority.length;
    requestTypeFilterCount.value = rxSelectedRequestTypes.length;

    totalFilterCount.value = tokenTypeFilterCount.value +
        projectTypeFilterCount.value +
        priorityTypeFilterCount.value +
        requestTypeFilterCount.value;
    if (totalFilterCount.value > 0) {
      applyFilters();
    } else {
      setToDefault();
    }
  }

  void setToDefault() {
    splitDisplayedTasks();
    searchController.clear();
  }

  //
  List<TaskResponse> applyFiltersOnly() {
    final typeFilters = rxSelectedTokenTypes;
    final projectFilters = rxSelectedProjects;
    final priorityFilters = rxSelectedPriority;
    final requestTypeFilters = rxSelectedRequestTypes;

    final dateRange = selectedDateRange;

    return rxTasksResponse.where((item) {
      bool match = true;

      // TOKEN / STORY STATUS
      if (typeFilters.isNotEmpty) {
        match = match &&
            typeFilters.any((f) =>
                item.currentStatus?.toLowerCase() ==
                    (f.mccName ?? "").toLowerCase() ||
                item.iadStatus?.toLowerCase() ==
                    (f.mccName ?? "").toLowerCase());
      }

      // PROJECT
      if (projectFilters.isNotEmpty) {
        match = match &&
            projectFilters.any((f) =>
                item.projectId.toString() == f.mccName ||
                item.projectName == f.mccName);
      }

      // PRIORITY
      if (priorityFilters.isNotEmpty) {
        match = match &&
            priorityFilters.any((f) =>
                item.priority?.toLowerCase() ==
                (f.mccName ?? "").toLowerCase());
      }

      // REQUEST TYPE
      if (requestTypeFilters.isNotEmpty) {
        match = match &&
            requestTypeFilters.any((f) =>
                item.requestType?.toLowerCase() ==
                (f.mccName ?? "").toLowerCase());
      }

      return match;
    }).toList();
  }
//

  ////////////////////////////////////////  SEARCH  /////////////////////////////////////////
  ///

  List<TaskResponse> applySearch(List<TaskResponse> list, String query) {
    if (query.isEmpty) return list;
    final q = query.toLowerCase();

    return list.where((item) {
      return (item.tokenId?.toLowerCase().contains(q) ?? false) ||
          (item.projectName?.toLowerCase().contains(q) ?? false) ||
          (item.projectId?.toString().contains(q) ?? false) ||
          (item.module?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  void onSearchChanged(String value) {
    final query = value.trim();

    // Always search on the filtered list, NOT displayed list
    List<TaskResponse> base = rxFilteredTasksResponse;

    rxDisplayedTasks.value = applySearch(base, query);

    // Split for tokens/story view
    splitDisplayedTasks();
  }

  ////////////////////////////////////////  FILTER & SEARCH  /////////////////////////////////////////
  void applyFilters() {
    // Apply filters only
    List<TaskResponse> filtered = applyFiltersOnly();

    rxFilteredTasksResponse.value = filtered;
    rxDisplayedTasks.value =
        applySearch(filtered, searchController.text.trim());
    splitDisplayedTasks();
  }

  void splitDisplayedTasks() {
    rxTokens.clear();
    rxStory.clear();

    for (final item in rxDisplayedTasks) {
      if ((item.issueType ?? '').toUpperCase() == "TOKEN") {
        rxTokens.add(item);
      } else {
        rxStory.add(item);
      }
    }
  }

  ////////////////////////////////////////  TABS  /////////////////////////////////////////

  List rxTabLabel = [token.tr, story.tr, token.tr];
  List rxPlTabScreens = [
    const PlTokensView(),
    const StoryView(),
    const TlTokenView()
  ];

  void switchTab(int index) {
    rxTabIndex(index);
  }

  //

  Future<bool> fetchInitData() async {
    setDateRange();
    await refreshTasks(true);
    await _fetchFilters();
    return true;
  }

  Future<bool> fetchStoryDetailsInitData() async {
    await fetchStory(false);
    return true;
  }
}
