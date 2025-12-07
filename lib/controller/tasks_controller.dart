import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/enum.dart';
import 'package:pmms/model/app_model.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/view/tasks/tabviews/story_view.dart';
import 'package:pmms/view/tasks/tabviews/pl_tokens_view.dart';
import 'package:pmms/view/tasks/tabviews/tl_token_view.dart';
import '../helper/app_message.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/navigation.dart';
import '../helper/route.dart';
import '../model/task_model.dart';

class TasksController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  //
  final isInitCalled = false.obs;

  // tab
  RxInt rxTabIndex = 0.obs;

  // date
  DateTimeRange? selectedDateRange;

  // searchbar
  TextEditingController searchController = TextEditingController();

  // filter
  var rxSelectedTokenTypes = <String>[].obs;
  var rxSelectedProjects = <String>[].obs;
  var rxSelectedPriority = <String>[].obs;
  var rxSelectedRequestTypes = <String>[].obs;

  RxInt tokenTypeFilterCount = 0.obs;
  RxInt projectTypeFilterCount = 0.obs;
  RxInt priorityTypeFilterCount = 0.obs;
  RxInt requestTypeFilterCount = 0.obs;

  RxInt totalFilterCount = 0.obs;

  // description edit
  TextEditingController descriptionController = TextEditingController();

  // tasks
  RxList<TaskResponse> rxTasksResponse = <TaskResponse>[].obs;

  RxList<TaskResponse> rxTokens = <TaskResponse>[].obs;
  RxList<TaskResponse> rxStory = <TaskResponse>[].obs;

  Rxn<TaskResponse> rxTaskDetail = Rxn<TaskResponse>();

  // filter
  RxList<FilterModel> rxTaskFilterTypeList = <FilterModel>[].obs;

  //

  @override
  Future<void> onInit() async {
    // await _setArguments();
    isInitCalled(true);
    setDefaultFilters();
    // setDateRange();
    _setArguments();
    _setFilterNames();
    super.onInit();
  }

  void setDateRange() {
    selectedDateRange = DateTimeRange(
      start: DateTime.now(), // today
      end: DateTime.now().add(const Duration(days: 7)), // 7 days from today
    );
  }

  void setDefaultFilters() {
    if (rxSelectedTokenTypes.isEmpty) {
      // rxSelectedTokenTypes.add("Pending");
    }
    if (rxSelectedProjects.isEmpty) {
      // rxSelectedProjects.add("General");
    }
    if (rxSelectedPriority.isEmpty) {
      // rxSelectedPriority.add("");
    }
    if (rxSelectedRequestTypes.isEmpty) {
      // rxSelectedRequestTypes.add("");
    }
    checkFilters();
  }

  Future<void> _setArguments() async {
    var arguments = Get.arguments;
    var task = arguments[tasksDataKey];
    if (arguments != null) {
      rxTasksResponse(task);
      await filterTasks();
    } else {
      showErrorSnackbar(
          message: "Unable To Fetch Task Details. Please Login Again");
      navigateToAndRemoveAll(loginPageRoute);
    }
  }

  // Future<void> setFilters() async {
  //   try {
  //     showLoader();
  //     String id = myApp.preferenceHelper!.getString(employeeIdKey);
  //     var tasksRequestsList = [
  //       CommonRequest(attribute: "transType", value: "LIST"),
  //       CommonRequest(attribute: "transSubType", value: "DropDown"),
  //       CommonRequest(attribute: "EmployeeID", value: id),
  //       CommonRequest(attribute: "dateFrom", value: ""),
  //     ];
  //     List<TaskResponse>? response =
  //         await _taskServices.getTasks(tasksRequestsList);
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

  Future<void> filterTasks() async {
    rxTokens.clear();
    rxStory.clear();
    for (int i = 0; i < rxTasksResponse.length; i++) {
      if (rxTasksResponse[i].issueType == "TOKEN") {
        rxTokens.add(rxTasksResponse[i]);
      } else {
        rxStory.add(rxTasksResponse[i]);
      }
    }
  }

  void resetsetFilters() {
    rxSelectedTokenTypes.clear();
    rxSelectedProjects.clear();
    rxSelectedPriority.clear();
    rxSelectedRequestTypes.clear();
    checkFilters();
  }

  void setTask(TaskResponse task) {
    rxTaskDetail(task);
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
  }

  List rxTabLabel = [token.tr, story.tr, token.tr];
  List rxPlTabScreens = [
    const PlTokensView(),
    const StoryView(),
    const TlTokenView()
  ];
  List rxTlTabScreens = [const TlTokenView(), const StoryView()];

  void switchTab(int index) {
    rxTabIndex(index);
  }

  // filters

  void _setFilterNames() {
    List<String> filterItems = [
      'All',
      'To Do',
      'In Progress',
      'Hold',
      'Completed'
    ];
    List<FilterType> filterTypes = [
      FilterType.all,
      FilterType.todo,
      FilterType.inprogress,
      FilterType.hold,
      FilterType.completed
    ];
    List<FilterModel> list = [];
    for (int i = 0; i < filterTypes.length; i++) {
      list.add(
        FilterModel(
          name: filterItems[i],
          filterType: filterTypes[i],
        ),
      );
    }
    rxTaskFilterTypeList.value = list;
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
