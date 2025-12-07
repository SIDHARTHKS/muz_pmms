import 'package:pmms/model/app_model.dart';
import 'package:pmms/model/dropdown_model.dart';
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

  Future<List<FiltersResponse>?> callFilter(List<CommonRequest> request) async {
    var response = await httpService.postService<List<FiltersResponse>>(
        endpoint: getFiltersApiEndpoint(),
        headers: await getHeaders(
          authorization: true,
          xCorrelationId: false,
          sid: false,
        ),
        data: request,
        fromJsonT: (json) => List<FiltersResponse>.from(
            json.map((x) => FiltersResponse.fromJson(x))),
        ignoreError: false);
    if (response != null && response.data != null) {
      return response.data;
    } else {
      return null;
    }
  }

  Future<List<DropDownResponse>?> callDropdowns(
      List<CommonRequest> request) async {
    var response = await httpService.postService<List<DropDownResponse>>(
        endpoint: getDropdownApiEndpoint(),
        headers: await getHeaders(
          authorization: true,
          xCorrelationId: false,
          sid: false,
        ),
        data: request,
        fromJsonT: (json) => List<DropDownResponse>.from(
            json.map((x) => DropDownResponse.fromJson(x))),
        ignoreError: false);
    if (response != null && response.data != null) {
      return response.data;
    } else {
      return null;
    }
  }

  Future<CreateTokenResponse?> createToken(List<CommonRequest> request) async {
    var response = await httpService.postService<CreateTokenResponse>(
        endpoint: getCreateTokenApiEndpoint(),
        headers: await getHeaders(
          authorization: true,
          xCorrelationId: false,
          sid: false,
        ),
        data: request,
        fromJsonT: (json) => CreateTokenResponse.fromJson(json),
        ignoreError: false);
    if (response != null && response.data != null) {
      return response.data;
    } else {
      return null;
    }
  }
}
