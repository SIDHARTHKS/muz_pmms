import 'package:get/get.dart';
import 'package:pmms/helper/app_string.dart';
import 'package:pmms/helper/single_app.dart';
import '../helper/core/base/app_base_controller.dart';

class SettingsController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  //

  RxBool rxNotificationsEnabled = true.obs;
  RxBool rxDarkmodeEnabled = false.obs;

  @override
  Future<void> onInit() async {
    rxNotificationsEnabled(
        MyApplication().preferenceHelper!.getBool(notificationKey));
    rxDarkmodeEnabled(MyApplication().preferenceHelper!.getBool(darkModeKey));
    super.onInit();
  }

  void toggleNotifications() {
    rxNotificationsEnabled.value = !rxNotificationsEnabled.value;
    MyApplication()
        .preferenceHelper!
        .setBool(notificationKey, rxNotificationsEnabled.value);
  }

  void toggleDarkmode() {
    rxDarkmodeEnabled.value = !rxDarkmodeEnabled.value;
    MyApplication()
        .preferenceHelper!
        .setBool(darkModeKey, rxDarkmodeEnabled.value);
  }

  Future<void> resetPreference() async {
    if (myApp.preferenceHelper != null) {
      myApp.preferenceHelper!.remove(loginNameKey);
      myApp.preferenceHelper!.remove(loginPasswordKey);
      if (myApp.preferenceHelper!.getBool(rememberMeKey)) {
        myApp.preferenceHelper!.setBool(rememberMeKey, false);
      }
    }
  }

  Future<bool> fetchInitData() async {
    // await sampleDelya();
    return true;
  }
}
