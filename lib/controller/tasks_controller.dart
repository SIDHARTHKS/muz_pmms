import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/date_helper.dart';
import 'package:pmms/helper/enum.dart';
import 'package:pmms/model/app_model.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/service/task_services.dart';
import 'package:pmms/view/tasks/tabviews/story/story_view.dart';
import 'package:pmms/view/tasks/tabviews/pl/pl_tokens_view.dart';
import 'package:pmms/view/tasks/tabviews/tl/tl_token_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../helper/app_message.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/navigation.dart';
import '../helper/route.dart';
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

  // description edit
  TextEditingController descriptionController = TextEditingController();
  RxString actualDescription = "".obs;
  RxBool rxDescriptionChanged = false.obs;

  // tasks
  RxList<TaskResponse> rxTasksResponse = <TaskResponse>[].obs;
  RxList<TaskResponse> rxFilteredTasksResponse = <TaskResponse>[].obs;
  RxList<TaskResponse> rxDisplayedTasks = <TaskResponse>[].obs;
  //
  RxList<TaskResponse> rxTokens = <TaskResponse>[].obs;
  RxList<TaskResponse> rxStory = <TaskResponse>[].obs;

  Rxn<TaskResponse> rxTaskDetail = Rxn<TaskResponse>();
  Rxn<TaskResponse> rxStoryDetail = Rxn<TaskResponse>();

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

  // scroll controller
  final Map<int, ScrollController> horizontalScrollControllers = {};
  final Map<int, RxBool> hasHorizontalOverflow = {};

  //

  @override
  Future<void> onInit() async {
    isInitCalled(true);
    setDateRange();
    _setArguments();
    _fetchFilters();
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

  void setTask(TaskResponse task) {
    rxTaskDetail(task);
  }

  void setStory(TaskResponse task) {
    rxStoryDetail(task);
  }

  //////////////////////////////// FETCHING/SETTING TASK ////////////////////////////////

  Future<void> _setArguments() async {
    var arguments = Get.arguments;
    var task = arguments[tasksDataKey];
    if (arguments != null) {
      rxTasksResponse(task);
      rxFilteredTasksResponse(task);
      await sortTasks();
    } else {
      showErrorSnackbar(
          message: "Unable To Fetch Task Details. Please Login Again");
      navigateToAndRemoveAll(loginPageRoute);
    }
  }

  ////////// SORT TASK AND TOKEN

  Future<void> sortTasks() async {
    rxTokens.clear();
    rxStory.clear();
    for (int i = 0; i < rxFilteredTasksResponse.length; i++) {
      String type =
          (rxFilteredTasksResponse[i].issueType ?? "").trim().toUpperCase();
      appLog("issues : ${rxFilteredTasksResponse[i].issueType}");
      if (type == "TOKEN") {
        rxTokens.add(rxFilteredTasksResponse[i]);
      } else {
        rxStory.add(rxFilteredTasksResponse[i]);
      }
    }
  }

  /////////////////////// REFRESH

  Future<void> refreshTasks() async {
    try {
      await fetchTasks().then((success) async {
        if (success) {
          await sortTasks();
          pullController.refreshCompleted();
        }
      });
    } catch (e) {
      pullController.refreshFailed();
    }
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
    sortTasks();
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

  ////////////////////////////////////////  EDIT DESCRIPTION  /////////////////////////////////////////
  void handleDescription(TaskResponse task) {
    descriptionController.text = task.description ?? "--";
    actualDescription(task.description ?? "--");
  }

  void verifyDescriptionEdit(String value) {
    final current = value.trim();
    final original = actualDescription.value.trim();

    appLog("original: $original");
    appLog("current : $current");

    rxDescriptionChanged(current != original);
    appLog("changed: $rxDescriptionChanged");
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

  List<String> tokenTypes = ['Pending', 'Approved', 'Rejected', 'In Progress'];

  final List<FiltersResponse> projectList = [
    FiltersResponse(mccId: '1', mccCode: 'GEN', mccName: 'General'),
    FiltersResponse(mccId: '2', mccCode: 'JUELISV2', mccName: 'JuelIS V2'),
    FiltersResponse(mccId: '3', mccCode: 'PAYROLL', mccName: 'Payroll'),
    FiltersResponse(
        mccId: '4', mccCode: 'MRETAILP', mccName: 'MRetail - Pulimoottil'),
    FiltersResponse(
        mccId: '5', mccCode: 'MRETAILS', mccName: 'MRetail - Seematti'),
  ];

  // 👥 Team List
  final List<FiltersResponse> teamList = [
    FiltersResponse(mccId: '1', mccCode: 'DEV', mccName: 'Development'),
    FiltersResponse(mccId: '2', mccCode: 'QA', mccName: 'Service'),
    FiltersResponse(mccId: '3', mccCode: 'SUP', mccName: 'Support'),
    FiltersResponse(mccId: '4', mccCode: 'OPS', mccName: 'Operations'),
    FiltersResponse(mccId: '5', mccCode: 'HR', mccName: 'Human Resources'),
  ];

// 🧱 Module List
  final List<FiltersResponse> moduleList = [
    FiltersResponse(mccId: '1', mccCode: 'LOGIN', mccName: 'Back Office'),
    FiltersResponse(mccId: '2', mccCode: 'UI', mccName: 'UI Enhancements'),
    FiltersResponse(mccId: '3', mccCode: 'REPORT', mccName: 'Reports'),
    FiltersResponse(mccId: '4', mccCode: 'NOTIFY', mccName: 'Notifications'),
    FiltersResponse(mccId: '5', mccCode: 'API', mccName: 'API Integration'),
  ];

// ⚙️ Option List
  final List<FiltersResponse> optionList = [
    FiltersResponse(mccId: '1', mccCode: 'BUG', mccName: 'Notification'),
    FiltersResponse(mccId: '2', mccCode: 'MOD', mccName: 'Modification'),
    FiltersResponse(mccId: '3', mccCode: 'SUPPORT', mccName: 'Support Request'),
    FiltersResponse(mccId: '4', mccCode: 'FEATURE', mccName: 'New Feature'),
    FiltersResponse(mccId: '5', mccCode: 'OTHER', mccName: 'Other'),
  ];

// 👤 Assignee List
  final List<FiltersResponse> assigneeList = [
    FiltersResponse(mccId: '1', mccCode: 'SID', mccName: 'Annette Black'),
    FiltersResponse(mccId: '2', mccCode: 'ANU', mccName: 'Sidharth KS'),
    FiltersResponse(mccId: '3', mccCode: 'RAHUL', mccName: 'Rahul Menon'),
    FiltersResponse(mccId: '4', mccCode: 'NEHA', mccName: 'Neha Joseph'),
    FiltersResponse(mccId: '5', mccCode: 'ARUN', mccName: 'Arun Krishnan'),
  ];
  List<String> priority = [
    'High',
    'Medium',
    'Low',
  ];

  List<String> requestTypes = [
    'Error',
    'Support',
    'Modification',
  ];

  Future<bool> fetchInitData() async {
    return true;
  }
}
