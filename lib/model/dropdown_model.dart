import 'dart:convert';

List<CommonDropdownResponse> commonDropdownResponseFromJson(String str) =>
    List<CommonDropdownResponse>.from(
        json.decode(str).map((x) => CommonDropdownResponse.fromJson(x)));

String commonDropdownResponseToJson(List<CommonDropdownResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommonDropdownResponse {
  String? mccId;
  String? mccCode;
  String? mccName;

  CommonDropdownResponse({
    this.mccId,
    this.mccCode,
    this.mccName,
  });

  factory CommonDropdownResponse.fromJson(Map<String, dynamic> json) =>
      CommonDropdownResponse(
        mccId: json["mccID"],
        mccCode: json["mccCode"],
        mccName: json["mccName"],
      );

  Map<String, dynamic> toJson() => {
        "mccID": mccId,
        "mccCode": mccCode,
        "mccName": mccName,
      };
}
