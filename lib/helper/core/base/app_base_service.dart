import 'package:get/get.dart';
import '../../app_string.dart';
import '../../deviceInfo.dart';
import '../../single_app.dart';
import 'http_service.dart';
import 'app_base_controller.dart';

class AppBaseService {
  late AppBaseController controller;

  final HttpService httpService = Get.find<HttpService>();
  final MyApplication myApplication = Get.find<MyApplication>();

  // auth
  getLoginApiEndpoint() => '/login'; //
  getUserLoginApiEndpoint() => '/userlogin'; //
  getRefreshApiEndpoint() => '/refreshtoken'; //

  getMailApiEndpoint() => '/getEmailID'; //
  getVerificationCodeApiEndpoint() => '/sendVerificationCode'; //
  getverifyOtpApiEndpoint() => '/verifyVerificationCode'; //

  // profile
  getProfileApiEndpoint() => '/getProfileDetails'; //

  // dashboard
  getTasksApiEndpoint() => '/mytask'; //

  // token
  getCreateTokenApiEndpoint() => '/generatetoken'; //

  // story
  getStoryDetailsApiEndpoint() => '/storyinToken'; //
  getCreateStoryApiEndpoint() => '/generatestory'; //
  getHoldStoryApiEndpoint() => '/generatestory'; //

  // filter
  getFiltersApiEndpoint() => '/mytaskdropdown'; //
  getDropdownApiEndpoint() => '/taskdropdown'; //

  // settings
  // getVersionApiEndpoint() => '/getLastVersionDetail'; //
  // getVersionInfoApiEndpoint() => '/getVersionDetail'; //

  // getSupportedVersionApiEndpoint() => '/v1/common/getsupportedversion';

  Future<Map<String, String>> getHeaders({
    bool contentType = true,
    bool authorization = true,
    bool xCorrelationId = true,
    bool deviceId = true,
    bool appId = true,
    bool sid = true,
    bool fbEid = false,
  }) async {
    final MyApplication misApp = Get.find<MyApplication>();
    if (misApp.preferenceHelper == null) {
      return {};
    }

    final Map<String, String> headers = {};
    String? authToken;
    String? sidValue;
    String? deviceIdValue;
    String? fbEidValue;
    String randomDigit = await DeviceUtil.generateRandomString();

    if (authorization) {
      authToken = misApp.preferenceHelper!.getString(accessTokenKey);
    }
    if (sid) {
      sidValue = misApp.preferenceHelper!.getString(sidKey);
    }
    if (deviceId) {
      deviceIdValue = misApp.preferenceHelper!.getString(deviceIdKey);
    }
    if (fbEid) {
      fbEidValue = misApp.preferenceHelper!.getString(fbEidKey);
    }

    if (contentType) {
      headers['Content-Type'] = 'application/json';
    }

    if (authorization) {
      headers['Authorization'] = 'Bearer ${authToken ?? ''}';
    }

    if (xCorrelationId) {
      headers['X-Correlation-Id'] = 'S01${sidValue ?? ''}$randomDigit';
    }
    if (deviceId) {
      headers['DeviceID'] = deviceIdValue ?? '';
    }
    if (appId) {
      headers['AppID'] = 'S01';
    }
    if (sid) {
      headers['SID'] = sidValue ?? '';
    }
    if (fbEid) {
      headers['FBEID'] = fbEidValue ?? '';
    }

    return headers;
  }
}
