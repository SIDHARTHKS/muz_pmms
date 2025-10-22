import 'package:get/get.dart';
import '../helper/app_message.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/navigation.dart';
import '../helper/route.dart';
import '../service/home_service.dart';

class HomeController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  //
  final HomeService _homeService = Get.find<HomeService>();
  //
  final isInitCalled = false.obs;
  RxString rxUserName = ''.obs;
  RxString rxUserImg = ''.obs;
  RxString rxUserId = "".obs;

  @override
  Future<void> onInit() async {
    await _setArguments();
    isInitCalled(true);
    super.onInit();
  }

  Future<void> _setArguments() async {
    var arguments = Get.arguments;
    if (arguments != null) {
    } else {
      showErrorSnackbar(
          message: "Unable To Fetch Locations. Please Login Again");
      navigateToAndRemoveAll(loginPageRoute);
    }
    appLog("userid =${rxUserId.value}");
  }

  Future<bool> fetchInitData() async {
    return true;
  }
}
