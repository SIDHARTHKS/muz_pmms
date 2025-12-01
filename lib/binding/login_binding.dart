import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:pmms/service/task_services.dart';

import '../controller/login_controller.dart';
import '../service/auth_service.dart';

class LoginBinding extends BaseBinding {
  const LoginBinding();

  @override
  void injectDependencies() {
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<TaskServices>(() => TaskServices(), fenix: true);
  }
}
