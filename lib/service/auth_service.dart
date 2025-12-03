import 'package:pmms/helper/core/base/app_base_service.dart';
import '../helper/app_message.dart';
import '../helper/app_string.dart';
import '../helper/enum.dart';
import '../model/app_model.dart';
import '../model/login_model.dart';

class AuthService extends AppBaseService {
  // Future<AppBaseResponse?>? fetchSupportedVersion() async =>
  //     await httpService.getService(
  //       endpoint: getSupportedVersionApiEndpoint(),
  //       headers: await getHeaders(authorization: false),
  //       fromJsonT: (json) => DeviceSupportModel.fromJson(json),
  //     );

  Future<LoginResponse?> login(LoginRequest request) async {
    var response = await httpService.postService<LoginResponse>(
        endpoint: getLoginApiEndpoint(),
        headers: await getHeaders(
          authorization: false,
          xCorrelationId: false,
          sid: false,
        ),
        data: request.toJson(),
        fromJsonT: (json) => LoginResponse.fromJson(json),
        ignoreError: false);
    if (response != null && response.data != null) {
      return response.data;
    }
    return null;
  }

  Future<UserLoginResponse?> userLogin(List<CommonRequest> request) async {
    var response = await httpService.postService<UserLoginResponse>(
      endpoint: getUserLoginApiEndpoint(),
      headers: await getHeaders(
        authorization: true,
        xCorrelationId: false,
        sid: false,
      ),
      data: request,
      fromJsonT: (json) => UserLoginResponse.fromJson(json),
    );
    if (response != null && response.data != null) {
      return response.data;
    }
    return null;
  }

  //

  // Future<bool> updatePassword(List<CommonRequest> request) async {
  //   var response = await httpService.postService(
  //     endpoint: getUpdatePassApiEndpoint(),
  //     headers: await getHeaders(
  //       authorization: false,
  //       xCorrelationId: false,
  //       sid: false,
  //     ),
  //     data: request,
  //     fromJsonT: (json) => json,
  //   );
  //   if (response != null && response.success != null) {
  //     return response.success!;
  //   }
  //   return false;
  // }

  // Future<bool> changePassword(List<CommonRequest> request) async {
  //   var response = await httpService.postService(
  //       endpoint: getChangePassApiEndpoint(),
  //       headers: await getHeaders(
  //         authorization: true,
  //         xCorrelationId: false,
  //         sid: false,
  //       ),
  //       data: request,
  //       fromJsonT: (json) => json,
  //       retryOnUnauthorized: true);
  //   if (response != null && response.success != null) {
  //     appLog('Change password response: ${response.success}');
  //     return response.success!;
  //   } else {
  //     return false;
  //   }
  // }

  Future<EmailResponse?> getMail(List<CommonRequest> request) async {
    var response = await httpService.postService<EmailResponse>(
      endpoint: getMailApiEndpoint(),
      headers: await getHeaders(
        authorization: false,
        xCorrelationId: false,
        sid: false,
      ),
      data: request,
      fromJsonT: (json) => EmailResponse.fromJson(json),
    );
    if (response != null && response.data != null) {
      return response.data;
    }
    return null;
  }

  Future<OtpResponse?> getOtp(List<CommonRequest> request) async {
    var response = await httpService.postService<OtpResponse>(
      endpoint: getVerificationCodeApiEndpoint(),
      headers: await getHeaders(
        authorization: false,
        xCorrelationId: false,
        sid: false,
      ),
      data: request,
      fromJsonT: (json) => OtpResponse.fromJson(json),
    );
    if (response != null && response.data != null) {
      return response.data;
    }
    return null;
  }

  Future<bool> verifyOtp(List<CommonRequest> request) async {
    var response = await httpService.postService(
      endpoint: getverifyOtpApiEndpoint(),
      headers: await getHeaders(
        authorization: false,
        xCorrelationId: false,
        sid: false,
      ),
      data: request,
      fromJsonT: (json) => json,
    );
    if (response != null && response.success != null) {
      appLog('Change password response: ${response.success}');
      return response.success!;
    } else {
      return false;
    }
  }

  Future<RefreshResponse?> refresh(RefreshRequest request) async {
    final response = await httpService.postService(
      endpoint: getRefreshApiEndpoint(),
      headers: await getHeaders(
        authorization: false,
        xCorrelationId: false,
        sid: false,
      ),
      data: request.toJson(),
      fromJsonT: (json) => RefreshResponse.fromJson(json),
      retryOnUnauthorized: false,
      ignoreError: true, // or true if you want silent handling
    );

    if (response != null && response.data != null) {
      myApplication.preferenceHelper!
          .setString(accessTokenKey, response.data!.authToken!);
      return response.data;
    }
    appLog('refresh returned null value', logging: Logging.warning);
    return null;
  }

  // Future<bool> logoutSession() async {
  //   final request = {};
  //   var response = await httpService.postService(
  //     endpoint: getLogoutApiEndpoint(),
  //     headers: await getHeaders(
  //       authorization: true,
  //       xCorrelationId: false,
  //       sid: false,
  //     ),
  //     retryOnUnauthorized: true,
  //     data: request,
  //     fromJsonT: (json) => json,
  //   );
  //   if (response != null) {
  //     return response.success ?? false;
  //   }
  //   return false;
  // }
}
