import 'dart:convert';
import 'dart:ui';

import 'package:pmms/helper/enum.dart';

DeviceSupportModel deviceSupportModelFromJson(String str) =>
    DeviceSupportModel.fromJson(json.decode(str));

String deviceSupportModelToJson(DeviceSupportModel data) =>
    json.encode(data.toJson());

class DeviceSupportModel {
  String? android;
  String? ios;

  DeviceSupportModel({
    this.android,
    this.ios,
  });

  factory DeviceSupportModel.fromJson(Map<String, dynamic> json) =>
      DeviceSupportModel(
        android: json["android"],
        ios: json["ios"],
      );

  Map<String, dynamic> toJson() => {
        "android": android,
        "ios": ios,
      };
}

//

AppBaseRequest appBaseRequestFromJson(String str) =>
    AppBaseRequest.fromJson(json.decode(str));

String appBaseRequestToJson(AppBaseRequest data) => json.encode(data.toJson());

class AppBaseRequest {
  RequestBase? requestBase;

  AppBaseRequest({
    this.requestBase,
  });

  factory AppBaseRequest.fromJson(Map<String, dynamic> json) => AppBaseRequest(
        requestBase: json["RequestBase"] == null
            ? null
            : RequestBase.fromJson(json["RequestBase"]),
      );

  Map<String, dynamic> toJson() => {
        "RequestBase": requestBase?.toJson(),
      };
}

class RequestBase {
  String? clientTag;
  String? transId;
  String? requestId;

  RequestBase({
    this.clientTag,
    this.transId,
    this.requestId,
  });

  factory RequestBase.fromJson(Map<String, dynamic> json) => RequestBase(
        clientTag: json["ClientTag"],
        transId: json["TransId"],
        requestId: json["RequestId"],
      );

  Map<String, dynamic> toJson() => {
        "ClientTag": clientTag,
        "TransId": transId,
        "RequestId": requestId,
      };
}

//

class PieData {
  final double value;
  final Color color;

  PieData(this.value, this.color);
}

//

List<CommonRequest> commonRequestFromJson(String str) =>
    List<CommonRequest>.from(
        json.decode(str).map((x) => CommonRequest.fromJson(x)));

String commonRequestToJson(List<CommonRequest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommonRequest {
  String? attribute;
  String? value;

  CommonRequest({
    this.attribute,
    this.value,
  });

  factory CommonRequest.fromJson(Map<String, dynamic> json) => CommonRequest(
        attribute: json["attribute"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "attribute": attribute,
        "value": value,
      };
}

//success

class SuccessModel {
  final String title;
  final String subtitle;
  final String route;

  SuccessModel({
    required this.title,
    required this.subtitle,
    required this.route,
  });

  // Optional: From JSON
  factory SuccessModel.fromJson(Map<String, dynamic> json) {
    return SuccessModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      route: json['route'] ?? '',
    );
  }

  // Optional: To JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'route': route,
    };
  }
}
// filter

class FilterModel {
  final String name;
  final FilterType filterType;

  FilterModel({
    required this.name,
    required this.filterType,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "filterType": filterType.toString(),
        // Example: "FilterType.tokenStatus"
      };

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
      name: json["name"],
      filterType: FilterType.values.firstWhere(
        (e) => e.toString() == json["filterType"],
      ),
    );
  }
}
