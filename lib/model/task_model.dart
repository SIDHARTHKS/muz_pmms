import 'dart:convert';

class TaskModel {
  final String title; // Title for the task (missing in image)
  final String requestedBy;
  final DateTime requestedDate;
  final String type;
  final String clientRefId;
  final String tokenId;
  final String priority;
  final String description;
  final String project;
  final String team;
  final String module;
  final String option;
  final String assignee;
  final List<String> attachments;

  TaskModel({
    required this.title,
    required this.requestedBy,
    required this.requestedDate,
    required this.type,
    required this.clientRefId,
    required this.tokenId,
    required this.priority,
    required this.description,
    required this.project,
    required this.team,
    required this.module,
    required this.option,
    required this.assignee,
    this.attachments = const [],
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'] ?? '',
      requestedBy: json['requestedBy'] ?? '',
      requestedDate:
          DateTime.tryParse(json['requestedDate'] ?? '') ?? DateTime.now(),
      type: json['type'] ?? '',
      clientRefId: json['clientRefId'] ?? '',
      tokenId: json['tokenId'] ?? '',
      priority: json['priority'] ?? '',
      description: json['description'] ?? '',
      project: json['project'] ?? '',
      team: json['team'] ?? '',
      module: json['module'] ?? '',
      option: json['option'] ?? '',
      assignee: json['assignee'] ?? '',
      attachments: List<String>.from(json['attachments'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'requestedBy': requestedBy,
      'requestedDate': requestedDate.toIso8601String(),
      'type': type,
      'clientRefId': clientRefId,
      'tokenId': tokenId,
      'priority': priority,
      'description': description,
      'project': project,
      'team': team,
      'module': module,
      'option': option,
      'assignee': assignee,
      'attachments': attachments,
    };
  }
}

///////////////////////////////response

List<TaskResponse> taskResponseFromJson(String str) => List<TaskResponse>.from(
    json.decode(str).map((x) => TaskResponse.fromJson(x)));

String taskResponseToJson(List<TaskResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskResponse {
  DateTime? requestDateTime;
  String? requestType;
  String? clientRefId;
  String? tokenId;
  String? team;
  int? teamId;
  int? moduleId;
  String? assignee;
  int? assigneeId;
  String? attachment;
  String? issueType;
  String? storyType;
  String? estimateTime;
  String? iadStatus;
  String? iadAssigneeEmpId;
  String? projectImage;
  String? requestId;
  String? projectName;
  int? projectId;
  String? taskResponseIssueType;
  String? optionName;
  String? requestedBy;
  String? module;
  String? priority;
  String? description;
  String? role;
  int? optionId;
  String? currentStatus;

  TaskResponse({
    this.requestDateTime,
    this.requestType,
    this.clientRefId,
    this.tokenId,
    this.team,
    this.teamId,
    this.moduleId,
    this.assignee,
    this.assigneeId,
    this.attachment,
    this.issueType,
    this.storyType,
    this.estimateTime,
    this.iadStatus,
    this.iadAssigneeEmpId,
    this.projectImage,
    this.requestId,
    this.projectName,
    this.projectId,
    this.taskResponseIssueType,
    this.optionName,
    this.requestedBy,
    this.module,
    this.priority,
    this.description,
    this.role,
    this.optionId,
    this.currentStatus,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) => TaskResponse(
        requestDateTime: json["requestDateTime"] == null
            ? null
            : DateTime.parse(json["requestDateTime"]),
        requestType: json["requestType"],
        clientRefId: json["clientRefID"],
        tokenId: json["tokenID"],
        team: json["team"],
        teamId: json["teamID"],
        moduleId: json["moduleID"],
        assignee: json["assignee"],
        assigneeId: json["assigneeID"],
        attachment: json["attachment"],
        issueType: json["issueTYPE"],
        storyType: json["storyType"],
        estimateTime: json["estimateTime"],
        iadStatus: json["iadStatus"],
        iadAssigneeEmpId: json["iadAssigneeEmpID"],
        projectImage: json["projectImage"],
        requestId: json["requestID"],
        projectName: json["projectName"],
        projectId: json["projectID"],
        taskResponseIssueType: json["issueType"],
        optionName: json["optionName"],
        requestedBy: json["requestedBy"],
        module: json["module"],
        priority: json["priority"],
        description: json["description"],
        role: json["role"],
        optionId: json["optionID"],
        currentStatus: json["currentStatus"],
      );

  Map<String, dynamic> toJson() => {
        "requestDateTime":
            "${requestDateTime!.year.toString().padLeft(4, '0')}-${requestDateTime!.month.toString().padLeft(2, '0')}-${requestDateTime!.day.toString().padLeft(2, '0')}",
        "requestType": requestType,
        "clientRefID": clientRefId,
        "tokenID": tokenId,
        "team": team,
        "teamID": teamId,
        "moduleID": moduleId,
        "assignee": assignee,
        "assigneeID": assigneeId,
        "attachment": attachment,
        "issueTYPE": issueType,
        "storyType": storyType,
        "estimateTime": estimateTime,
        "iadStatus": iadStatus,
        "iadAssigneeEmpID": iadAssigneeEmpId,
        "projectImage": projectImage,
        "requestID": requestId,
        "projectName": projectName,
        "projectID": projectId,
        "issueType": taskResponseIssueType,
        "optionName": optionName,
        "requestedBy": requestedBy,
        "module": module,
        "priority": priority,
        "description": description,
        "role": role,
        "optionID": optionId,
        "currentStatus": currentStatus,
      };
}

CreateTokenResponse createTokenResponseFromJson(String str) =>
    CreateTokenResponse.fromJson(json.decode(str));

String createTokenResponseToJson(CreateTokenResponse data) =>
    json.encode(data.toJson());

class CreateTokenResponse {
  String? message;

  CreateTokenResponse({
    this.message,
  });

  factory CreateTokenResponse.fromJson(Map<String, dynamic> json) =>
      CreateTokenResponse(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
