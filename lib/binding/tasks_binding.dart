import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:pmms/controller/tasks_controller.dart';

class TasksBinding extends BaseBinding {
  const TasksBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<TasksController>(() => TasksController(), fenix: true);

    // Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
  }
}
