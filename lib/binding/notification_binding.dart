import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:pmms/controller/home_controller.dart';

class NotificationBinding extends BaseBinding {
  const NotificationBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
