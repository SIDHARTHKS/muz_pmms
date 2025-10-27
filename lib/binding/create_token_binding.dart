import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:pmms/controller/create_token_controller.dart';

class CreateTokenBinding extends BaseBinding {
  const CreateTokenBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<CreateTokenController>(() => CreateTokenController(),
        fenix: true);
  }
}
