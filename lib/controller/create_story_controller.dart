import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pmms/helper/app_message.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/navigation.dart';
import 'package:pmms/helper/route.dart';
import 'package:pmms/model/dropdown_model.dart';
import 'package:pmms/model/task_model.dart';
import 'package:pmms/view/createStory/pages/create_story_page1.dart';
import 'package:pmms/view/createStory/pages/create_story_page2.dart';
import 'package:pmms/view/story/editStory/pages/edit_story_page1.dart';
import 'package:pmms/view/story/editStory/pages/edit_story_page2.dart';
import '../helper/core/base/app_base_controller.dart';

class CreateStoryController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
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
  Rxn<FiltersResponse> rxSelectedAsignee = Rxn<FiltersResponse>();
  Rxn<FiltersResponse> rxSelectedModule = Rxn<FiltersResponse>();
  Rxn<FiltersResponse> rxSelectedOption = Rxn<FiltersResponse>();

  //dates
  DateTime rxRequestedOn = DateTime.now();
  DateTime rxDueDate = DateTime.now();

  DateTime rxRequestDate = DateTime.now();
  DateTime rxPlannedStartDate = DateTime.now();
  DateTime rxPlannedEndDate = DateTime.now();

  // story
  Rxn<TaskResponse> rxCurrentStoryDetail = Rxn<TaskResponse>();

  @override
  Future<void> onInit() async {
    isInitCalled(true);

    super.onInit();
  }

  /////////////////////////////
  Future<void> _setArguments() async {
    final arguments = Get.arguments;
    if (arguments != null && arguments[currentStoryKey] != null) {
      rxCurrentStoryDetail(arguments[currentStoryKey]);
      setFields();
    } else {
      setDefaultFilters();
      appLog("new story");
    }
  }

  void setFields() {
    descriptionController.text = rxCurrentStoryDetail.value?.description ?? "";
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
    rxSelectedStoryType.value = storyTypeList[0];
    rxSelectedAsignee.value = assigneeList[0];
    rxSelectedModule.value = moduleTypeList[0];
    rxSelectedOption.value = optionTypeList[0];

    // time
    hoursController.text = "00";
    minutesController.text = "00";
  }

  final List<FiltersResponse> storyTypeList = [
    FiltersResponse(
      mccId: '1',
      mccCode: 'DEVELOPMENT',
      mccName: 'Development',
    ),
    FiltersResponse(
      mccId: '2',
      mccCode: 'BUG',
      mccName: 'Bug',
    ),
    FiltersResponse(
      mccId: '3',
      mccCode: 'FEATURE',
      mccName: 'Feature',
    ),
    FiltersResponse(
      mccId: '4',
      mccCode: 'IMPROVEMENT',
      mccName: 'Improvement',
    ),
    FiltersResponse(
      mccId: '5',
      mccCode: 'TASK',
      mccName: 'Task',
    ),
    FiltersResponse(
      mccId: '6',
      mccCode: 'SPIKE',
      mccName: 'Spike / Research',
    ),
  ];

  final List<FiltersResponse> assigneeList = [
    FiltersResponse(mccId: '1', mccCode: 'USR1', mccName: 'Annette Black'),
    FiltersResponse(mccId: '2', mccCode: 'USR2', mccName: 'Jane Smith'),
    FiltersResponse(mccId: '3', mccCode: 'USR3', mccName: 'Alex Johnson'),
    FiltersResponse(mccId: '4', mccCode: 'USR4', mccName: 'Priya Menon'),
  ];

  final List<FiltersResponse> moduleTypeList = [
    FiltersResponse(
      mccId: '1',
      mccCode: 'NA',
      mccName: 'NA',
    ),
    FiltersResponse(
      mccId: '2',
      mccCode: 'MODULE1',
      mccName: 'Module1',
    ),
    FiltersResponse(
      mccId: '3',
      mccCode: 'MODULE2',
      mccName: 'Module2',
    ),
    FiltersResponse(
      mccId: '4',
      mccCode: 'MODULE3',
      mccName: 'Module3',
    ),
  ];
  final List<FiltersResponse> optionTypeList = [
    FiltersResponse(
      mccId: '1',
      mccCode: 'NA',
      mccName: 'NA',
    ),
    FiltersResponse(
      mccId: '2',
      mccCode: 'OPTION1',
      mccName: 'Option1',
    ),
    FiltersResponse(
      mccId: '3',
      mccCode: 'OPTION2',
      mccName: 'Option2',
    ),
    FiltersResponse(
      mccId: '4',
      mccCode: 'OPTION3',
      mccName: 'Option3',
    ),
  ];

  //////////////////////////////////////////////////////////////////////////////

  Future<bool> fetchInitData() async {
    _setArguments();
    return true;
  }
}
