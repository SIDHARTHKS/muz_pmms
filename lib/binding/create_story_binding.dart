import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:pmms/controller/create_story_controller.dart';

class CreateStoryBinding extends BaseBinding {
  const CreateStoryBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<CreateStoryController>(() => CreateStoryController(),
        fenix: true);
  }
}
