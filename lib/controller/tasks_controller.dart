import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmms/model/dropdown_model.dart';
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

  final List<CommonDropdownResponse> projectList = [
    CommonDropdownResponse(mccId: '1', mccCode: 'GEN', mccName: 'General'),
    CommonDropdownResponse(
        mccId: '2', mccCode: 'JUELISV2', mccName: 'JuelIS V2'),
    CommonDropdownResponse(mccId: '3', mccCode: 'PAYROLL', mccName: 'Payroll'),
    CommonDropdownResponse(
        mccId: '4', mccCode: 'MRETAILP', mccName: 'MRetail - Pulimoottil'),
    CommonDropdownResponse(
        mccId: '5', mccCode: 'MRETAILS', mccName: 'MRetail - Seematti'),
  ];

  // 👥 Team List
  final List<CommonDropdownResponse> teamList = [
    CommonDropdownResponse(mccId: '1', mccCode: 'DEV', mccName: 'Development'),
    CommonDropdownResponse(mccId: '2', mccCode: 'QA', mccName: 'Service'),
    CommonDropdownResponse(mccId: '3', mccCode: 'SUP', mccName: 'Support'),
    CommonDropdownResponse(mccId: '4', mccCode: 'OPS', mccName: 'Operations'),
    CommonDropdownResponse(
        mccId: '5', mccCode: 'HR', mccName: 'Human Resources'),
  ];

// 🧱 Module List
  final List<CommonDropdownResponse> moduleList = [
    CommonDropdownResponse(
        mccId: '1', mccCode: 'LOGIN', mccName: 'Back Office'),
    CommonDropdownResponse(
        mccId: '2', mccCode: 'UI', mccName: 'UI Enhancements'),
    CommonDropdownResponse(mccId: '3', mccCode: 'REPORT', mccName: 'Reports'),
    CommonDropdownResponse(
        mccId: '4', mccCode: 'NOTIFY', mccName: 'Notifications'),
    CommonDropdownResponse(
        mccId: '5', mccCode: 'API', mccName: 'API Integration'),
  ];

// ⚙️ Option List
  final List<CommonDropdownResponse> optionList = [
    CommonDropdownResponse(mccId: '1', mccCode: 'BUG', mccName: 'Notification'),
    CommonDropdownResponse(mccId: '2', mccCode: 'MOD', mccName: 'Modification'),
    CommonDropdownResponse(
        mccId: '3', mccCode: 'SUPPORT', mccName: 'Support Request'),
    CommonDropdownResponse(
        mccId: '4', mccCode: 'FEATURE', mccName: 'New Feature'),
    CommonDropdownResponse(mccId: '5', mccCode: 'OTHER', mccName: 'Other'),
  ];

// 👤 Assignee List
  final List<CommonDropdownResponse> assigneeList = [
    CommonDropdownResponse(
        mccId: '1', mccCode: 'SID', mccName: 'Annette Black'),
    CommonDropdownResponse(mccId: '2', mccCode: 'ANU', mccName: 'Sidharth KS'),
    CommonDropdownResponse(
        mccId: '3', mccCode: 'RAHUL', mccName: 'Rahul Menon'),
    CommonDropdownResponse(mccId: '4', mccCode: 'NEHA', mccName: 'Neha Joseph'),
    CommonDropdownResponse(
        mccId: '5', mccCode: 'ARUN', mccName: 'Arun Krishnan'),
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
