import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:pmms/controller/change_password_controller.dart';

class ChangePasswordBinding extends BaseBinding {
  const ChangePasswordBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController(),
        fenix: true);
  }
}
