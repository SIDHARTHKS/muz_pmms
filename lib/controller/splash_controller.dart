import 'package:get/get.dart';
import '../helper/app_string.dart';
import '../helper/core/base/app_base_controller.dart';
import '../helper/shared_pref.dart';
import '../helper/single_app.dart';

class SplashController extends AppBaseController {
  final MyApplication myApplication = Get.find<MyApplication>();
  SharedPreferenceHelper? _preference;
  var rxUpdateRequired = false.obs;

  Future<int> fetchUserProfile() async {
    _preference = myApplication.preferenceHelper;

    await Future.delayed(const Duration(seconds: 1));

    bool isLoggedIn = myApp.preferenceHelper != null
        ? (myApp.preferenceHelper!.getBool(rememberMeKey) &&
            myApp.preferenceHelper!.getString(emailKey).isNotEmpty)
        : false;

    if (isLoggedIn) {
      if (myApp.preferenceHelper == null) {
        return 2;
      } else {
        // await fetchCompanies().then((success) {
        //   if (success) {
        //     fetchLocations();
        //   }
        // });
        return 1;
      }
    }
    return 2;
  }

  Future<void> resetPref() async {
    _preference!.remove(accessTokenKey);
    _preference!.remove(passwordKey);
  }
}
