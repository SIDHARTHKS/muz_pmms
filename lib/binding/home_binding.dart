import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:pmms/service/home_service.dart';
import 'package:pmms/service/task_services.dart';
import '../controller/home_controller.dart';

class HomeBinding extends BaseBinding {
  const HomeBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);

    Get.lazyPut<HomeService>(() => HomeService(), fenix: true);
    Get.lazyPut<TaskServices>(() => TaskServices(), fenix: true);
  }
}
