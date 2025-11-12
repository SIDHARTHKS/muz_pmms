import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:pmms/controller/settings_controller.dart';

class SettingsBinding extends BaseBinding {
  const SettingsBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
  }
}
