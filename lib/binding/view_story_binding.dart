import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:pmms/controller/story_details_controller.dart';

class ViewStoryBinding extends BaseBinding {
  const ViewStoryBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<StoryDetailsController>(() => StoryDetailsController(),
        fenix: true);
  }
}
