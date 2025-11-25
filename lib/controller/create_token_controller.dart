import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/view/createToken/pages/create_token_page1.dart';
import 'package:pmms/view/createToken/pages/create_token_page2.dart';
import 'package:pmms/view/createToken/pages/create_token_page3.dart';
import '../helper/core/base/app_base_controller.dart';

class CreateTokenController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  //
  final isInitCalled = false.obs;

  // textfield
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController additionaldescriptionController =
      TextEditingController();

  // pages
  RxInt rxCurrentPageIndex = 0.obs;

  // toggle
  final RxBool rxToggle = false.obs;

  //filter
  Rxn<CommonDropdownResponse> rxSelectedProject = Rxn<CommonDropdownResponse>();
  Rxn<CommonDropdownResponse> rxSelectedRequest = Rxn<CommonDropdownResponse>();
  Rxn<CommonDropdownResponse> rxSelectedPriority =
      Rxn<CommonDropdownResponse>();
  Rxn<CommonDropdownResponse> rxSelectedTeam = Rxn<CommonDropdownResponse>();
  Rxn<CommonDropdownResponse> rxSelectedModule = Rxn<CommonDropdownResponse>();
  Rxn<CommonDropdownResponse> rxSelectedOption = Rxn<CommonDropdownResponse>();
  Rxn<CommonDropdownResponse> rxSelectedAsignee = Rxn<CommonDropdownResponse>();
  Rxn<CommonDropdownResponse> rxSelectedClientId =
      Rxn<CommonDropdownResponse>();
  Rxn<CommonDropdownResponse> rxSelectedRequestedBy =
      Rxn<CommonDropdownResponse>();

  //dates

  DateTime rxRequestedOn = DateTime.now();
  DateTime rxDueDate = DateTime.now();

  @override
  Future<void> onInit() async {
    isInitCalled(true);
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
  ////////////////////////////////////////////////////////////////////////////// filter

  void setDefaultFilters() {
    rxSelectedProject.value = projectList[0];
    rxSelectedRequest.value = requestTypes[0];
    rxSelectedPriority.value = priorityTypes[0];
    rxSelectedTeam.value = teamList[0];
    rxSelectedModule.value = moduleList[0];
    rxSelectedOption.value = optionList[0];
    rxSelectedAsignee.value = assigneeList[0];
    rxSelectedClientId.value = clientRefIdList[0];
    rxSelectedRequestedBy.value = requestedByList[0];
  }

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

  final List<CommonDropdownResponse> requestTypes = [
    CommonDropdownResponse(mccId: '1', mccCode: 'SUP', mccName: 'Support'),
    CommonDropdownResponse(mccId: '3', mccCode: 'ERR', mccName: 'Error'),
    CommonDropdownResponse(mccId: '2', mccCode: 'MOD', mccName: 'Modification'),
  ];

  final List<CommonDropdownResponse> priorityTypes = [
    CommonDropdownResponse(mccId: '2', mccCode: 'HIG', mccName: 'High'),
    CommonDropdownResponse(mccId: '3', mccCode: 'MED', mccName: 'Medium'),
    CommonDropdownResponse(mccId: '1', mccCode: 'LOW', mccName: 'Low'),
  ];

  final List<CommonDropdownResponse> teamList = [
    CommonDropdownResponse(mccId: '1', mccCode: 'DEV', mccName: 'Development'),
    CommonDropdownResponse(
        mccId: '2', mccCode: 'QA', mccName: 'Quality Assurance'),
    CommonDropdownResponse(mccId: '3', mccCode: 'OPS', mccName: 'Operations'),
    CommonDropdownResponse(mccId: '4', mccCode: 'SUP', mccName: 'Support Team'),
  ];

  final List<CommonDropdownResponse> moduleList = [
    CommonDropdownResponse(mccId: '1', mccCode: 'AUTH', mccName: 'Back Office'),
    CommonDropdownResponse(mccId: '2', mccCode: 'PAY', mccName: 'Payment'),
    CommonDropdownResponse(
        mccId: '3', mccCode: 'UI', mccName: 'User Interface'),
    CommonDropdownResponse(
        mccId: '4', mccCode: 'NOTIF', mccName: 'Notifications'),
  ];

  final List<CommonDropdownResponse> optionList = [
    CommonDropdownResponse(mccId: '1', mccCode: 'LOW', mccName: 'Notification'),
    CommonDropdownResponse(mccId: '2', mccCode: 'MED', mccName: 'Modification'),
    CommonDropdownResponse(mccId: '3', mccCode: 'HIGH', mccName: 'Updation'),
  ];

  final List<CommonDropdownResponse> assigneeList = [
    CommonDropdownResponse(
        mccId: '1', mccCode: 'USR1', mccName: 'Annette Black'),
    CommonDropdownResponse(mccId: '2', mccCode: 'USR2', mccName: 'Jane Smith'),
    CommonDropdownResponse(
        mccId: '3', mccCode: 'USR3', mccName: 'Alex Johnson'),
    CommonDropdownResponse(mccId: '4', mccCode: 'USR4', mccName: 'Priya Menon'),
  ];

  final List<CommonDropdownResponse> clientRefIdList = [
    CommonDropdownResponse(mccId: '1', mccCode: 'CL001', mccName: '0085'),
    CommonDropdownResponse(mccId: '2', mccCode: 'CL002', mccName: '0096'),
    CommonDropdownResponse(mccId: '3', mccCode: 'CL003', mccName: '0023'),
    CommonDropdownResponse(mccId: '4', mccCode: 'CL004', mccName: '0045'),
  ];

  final List<CommonDropdownResponse> requestedByList = [
    CommonDropdownResponse(mccId: '1', mccCode: 'EMP001', mccName: 'Muziris'),
    CommonDropdownResponse(
        mccId: '2', mccCode: 'EMP002', mccName: 'Anjali Nair'),
    CommonDropdownResponse(
        mccId: '3', mccCode: 'EMP003', mccName: 'Rahul Menon'),
    CommonDropdownResponse(
        mccId: '4', mccCode: 'EMP004', mccName: 'Sneha Varma'),
  ];

  //////////////////////////////////////////////////////////////////////////////

  Future<bool> fetchInitData() async {
    setDefaultFilters();
    return true;
  }
}
