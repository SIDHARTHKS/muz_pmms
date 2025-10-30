import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/app_message.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/navigation.dart';
import '../helper/route.dart';
import '../model/task_model.dart';

class TasksController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  //
  final isInitCalled = false.obs;

  // date
  DateTimeRange? selectedDateRange;

  // searchbar
  TextEditingController searchController = TextEditingController();
  //

  // taskdetail
  Rxn<TaskModel> rxTaskDetail = Rxn<TaskModel>();
  //

  // filter
  var rxSelectedTokenTypes = <String>[].obs;
  var rxSelectedProjects = <String>[].obs;
  var rxSelectedPriority = <String>[].obs;
  var rxSelectedRequestTypes = <String>[].obs;

  @override
  Future<void> onInit() async {
    // await _setArguments();
    isInitCalled(true);
    setDefaultFilters();
    setDateRange();
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
      rxSelectedTokenTypes.add("Pending");
    }
    if (rxSelectedProjects.isEmpty) {
      rxSelectedProjects.add("General");
    }
    if (rxSelectedPriority.isEmpty) {
      rxSelectedPriority.add("");
    }
    if (rxSelectedRequestTypes.isEmpty) {
      rxSelectedRequestTypes.add("");
    }
  }

  Future<void> _setArguments() async {
    var arguments = Get.arguments;
    if (arguments != null) {
    } else {
      showErrorSnackbar(
          message: "Unable To Fetch Locations. Please Login Again");
      navigateToAndRemoveAll(loginPageRoute);
    }
  }

  //

  void setTask(TaskModel task) {
    rxTaskDetail(task);
  }

  // filters

  List<String> tokenTypes = ['Pending', 'Approved', 'Rejected', 'In Progress'];
  List<String> projects = [
    'General',
    'JuelIS V2',
    'Payroll',
    'MRetail - Pulimoottil',
    'MRetail - Seematti'
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

  // mock data
  final List<TaskModel> mockTasks = [
    TaskModel(
      title: "Real-time Notification System",
      requestedBy: "Muziris",
      requestedDate: DateTime(2025, 9, 8),
      type: "Modification",
      clientRefId: "00085",
      tokenId: "TKN-782",
      priority: "High",
      description:
          "We will build a robust real-time notification system that ensures users receive timely updates through both push notifications.",
      project: "Payroll",
      team: "Service",
      module: "Back Office",
      option: "Notification",
      assignee: "Annette Black",
    ),
    TaskModel(
      title: "Employee Attendance Tracker",
      requestedBy: "GlobalTech",
      requestedDate: DateTime(2025, 8, 12),
      type: "New Feature",
      clientRefId: "00072",
      tokenId: "TKN-681",
      priority: "Medium",
      description:
          "Develop an attendance tracker module that integrates with existing payroll and leave systems for automated daily updates.",
      project: "HR Suite",
      team: "Development",
      module: "Attendance",
      option: "Integration",
      assignee: "Cameron Diaz",
    ),
    TaskModel(
      title: "Monthly Report Automation",
      requestedBy: "InfyCorp",
      requestedDate: DateTime(2025, 7, 5),
      type: "Enhancement",
      clientRefId: "00063",
      tokenId: "TKN-543",
      priority: "Low",
      description:
          "Automate the generation of monthly performance reports to reduce manual processing and errors.",
      project: "Analytics",
      team: "Data",
      module: "Reports",
      option: "Automation",
      assignee: "Jacob Jones",
    ),
    TaskModel(
      title: "User Access Control Update",
      requestedBy: "HexaSoft",
      requestedDate: DateTime(2025, 6, 19),
      type: "Modification",
      clientRefId: "00049",
      tokenId: "TKN-491",
      priority: "High",
      description:
          "Revamp user role and permission management to support dynamic access levels and new audit logging.",
      project: "Admin Portal",
      team: "Security",
      module: "Access Control",
      option: "Permissions",
      assignee: "Theresa Webb",
    ),
    TaskModel(
      title: "Expense Management Revamp",
      requestedBy: "FinCore",
      requestedDate: DateTime(2025, 5, 23),
      type: "Enhancement",
      clientRefId: "00038",
      tokenId: "TKN-412",
      priority: "Medium",
      description:
          "Redesign the expense module UI and integrate OCR-based receipt uploads for faster claim processing.",
      project: "Finance Suite",
      team: "UX/UI",
      module: "Expenses",
      option: "UI Revamp",
      assignee: "Leslie Alexander",
    ),
  ];

  //
  Future<void> sampleDelya() async {
    await Future.delayed(const Duration(seconds: 3)); // or 100 for test
  }

  Future<bool> fetchInitData() async {
    // await sampleDelya();
    return true;
  }
}
