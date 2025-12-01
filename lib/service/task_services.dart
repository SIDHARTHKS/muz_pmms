import 'package:pmms/model/app_model.dart';
import 'package:pmms/model/task_model.dart';

import '../helper/core/base/app_base_service.dart';

class TaskServices extends AppBaseService {
  Future<List<TaskResponse>?> getTasks(List<CommonRequest> request) async {
    var response = await httpService.postService<List<TaskResponse>>(
        endpoint: getTasksApiEndpoint(),
        headers: await getHeaders(
          authorization: true,
          xCorrelationId: false,
          sid: false,
        ),
        data: request,
        fromJsonT: (json) => List<TaskResponse>.from(
              json.map((x) => TaskResponse.fromJson(x)),
            ),
        ignoreError: false);
    if (response != null && response.data != null) {
      return response.data;
    } else {
      return null;
    }
  }
}
