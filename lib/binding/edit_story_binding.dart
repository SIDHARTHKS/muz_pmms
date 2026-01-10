import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:pmms/controller/edit_story_controller.dart';

class EditStoryBinding extends BaseBinding {
  const EditStoryBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<EditStoryController>(() => EditStoryController(), fenix: true);
  }
}
