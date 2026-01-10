import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:pmms/controller/edit_token_controller.dart';

class EditTokenBinding extends BaseBinding {
  const EditTokenBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<EditTokenController>(() => EditTokenController(), fenix: true);
  }
}
