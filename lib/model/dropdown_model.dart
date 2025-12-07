import 'dart:convert';

List<FiltersResponse> filtersResponseFromJson(String str) =>
    List<FiltersResponse>.from(
        json.decode(str).map((x) => FiltersResponse.fromJson(x)));

String filtersResponseToJson(List<FiltersResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FiltersResponse {
  String? mccCode;
  String? mccName;
  String? mccId;

  FiltersResponse({
    this.mccCode,
    this.mccName,
    this.mccId,
  });

  factory FiltersResponse.fromJson(Map<String, dynamic> json) =>
      FiltersResponse(
        mccCode: json["mccCode"],
        mccName: json["mccName"],
        mccId: json["mccID"],
      );

  Map<String, dynamic> toJson() => {
        "mccCode": mccCode,
        "mccName": mccName,
        "mccID": mccId,
      };
}

List<DropDownResponse> dropDownResponseFromJson(String str) =>
    List<DropDownResponse>.from(
        json.decode(str).map((x) => DropDownResponse.fromJson(x)));

String dropDownResponseToJson(List<DropDownResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DropDownResponse {
  String? name;
  String? id;
  String? code;

  DropDownResponse({
    this.name,
    this.id,
    this.code,
  });

  factory DropDownResponse.fromJson(Map<String, dynamic> json) =>
      DropDownResponse(
        name: json["name"],
        id: json["id"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "code": code,
      };
}
