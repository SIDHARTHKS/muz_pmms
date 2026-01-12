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
  String? clientRefId;
  String? additionInfo;
  String? requestedBy;
  String? module;
  String? priority;
  String? createdBy;
  String? description;
  String? role;
  int? optionId;
  String? currentStatus;
  DateTime? requestDateTime;
  String? projectName;
  String? requestId;
  int? projectId;
  String? issueType;
  String? optionName;
  int? requestTypeId;
  int? priorityId;
  String? requestType;
  String? storyType;
  String? tokenId;
  String? assignee;
  String? countOfStory;
  String? estimateTime;
  String? parentRequestId;
  int? assigneeId;
  int? teamId;
  String? team;
  int? currentStatusId;
  String? iadStatus;
  String? projectImage;
  int? moduleId;
  String? attachment;
  String? loggedTime;
  String? iadAssigneeEmpId;

  TaskResponse({
    this.clientRefId,
    this.additionInfo,
    this.requestedBy,
    this.module,
    this.priority,
    this.createdBy,
    this.description,
    this.role,
    this.optionId,
    this.currentStatus,
    this.requestDateTime,
    this.projectName,
    this.requestId,
    this.projectId,
    this.issueType,
    this.optionName,
    this.requestTypeId,
    this.priorityId,
    this.requestType,
    this.storyType,
    this.tokenId,
    this.assignee,
    this.countOfStory,
    this.estimateTime,
    this.parentRequestId,
    this.assigneeId,
    this.teamId,
    this.team,
    this.currentStatusId,
    this.iadStatus,
    this.projectImage,
    this.moduleId,
    this.attachment,
    this.loggedTime,
    this.iadAssigneeEmpId,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) => TaskResponse(
        clientRefId: json["clientRefID"],
        additionInfo: json["additionInfo"],
        requestedBy: json["requestedBy"],
        module: json["module"],
        priority: json["priority"],
        createdBy: json["createdBy"],
        description: json["description"],
        role: json["role"],
        optionId: json["optionID"],
        currentStatus: json["currentStatus"],
        requestDateTime: json["requestDateTime"] == null
            ? null
            : DateTime.parse(json["requestDateTime"]),
        projectName: json["projectName"],
        requestId: json["requestID"],
        projectId: json["projectID"],
        issueType: json["issueType"],
        optionName: json["optionName"],
        requestTypeId: json["requestTypeID"],
        priorityId: json["priorityID"],
        requestType: json["requestType"],
        storyType: json["storyType"],
        tokenId: json["tokenID"],
        assignee: json["assignee"],
        countOfStory: json["countOfStory"],
        estimateTime: json["estimateTime"],
        parentRequestId: json["parentRequestID"],
        assigneeId: json["assigneeID"],
        teamId: json["teamID"],
        team: json["team"],
        currentStatusId: json["currentStatusID"],
        iadStatus: json["iadStatus"],
        projectImage: json["projectImage"],
        moduleId: json["moduleID"],
        attachment: json["attachment"],
        loggedTime: json["loggedTime"],
        iadAssigneeEmpId: json["iadAssigneeEmpID"],
      );

  Map<String, dynamic> toJson() => {
        "clientRefID": clientRefId,
        "additionInfo": additionInfo,
        "requestedBy": requestedBy,
        "module": module,
        "priority": priority,
        "createdBy": createdBy,
        "description": description,
        "role": role,
        "optionID": optionId,
        "currentStatus": currentStatus,
        "requestDateTime":
            "${requestDateTime!.year.toString().padLeft(4, '0')}-${requestDateTime!.month.toString().padLeft(2, '0')}-${requestDateTime!.day.toString().padLeft(2, '0')}",
        "projectName": projectName,
        "requestID": requestId,
        "projectID": projectId,
        "issueType": issueType,
        "optionName": optionName,
        "requestTypeID": requestTypeId,
        "priorityID": priorityId,
        "requestType": requestType,
        "storyType": storyType,
        "tokenID": tokenId,
        "assignee": assignee,
        "countOfStory": countOfStory,
        "estimateTime": estimateTime,
        "parentRequestID": parentRequestId,
        "assigneeID": assigneeId,
        "teamID": teamId,
        "team": team,
        "currentStatusID": currentStatusId,
        "iadStatus": iadStatus,
        "projectImage": projectImage,
        "moduleID": moduleId,
        "attachment": attachment,
        "loggedTime": loggedTime,
        "iadAssigneeEmpID": iadAssigneeEmpId,
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

CreateStoryResponse createStoryResponseFromJson(String str) =>
    CreateStoryResponse.fromJson(json.decode(str));

String createStoryResponseToJson(CreateStoryResponse data) =>
    json.encode(data.toJson());

class CreateStoryResponse {
  String? message;

  CreateStoryResponse({
    this.message,
  });

  factory CreateStoryResponse.fromJson(Map<String, dynamic> json) =>
      CreateStoryResponse(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

//

List<StoryResponse> storyResponseFromJson(String str) =>
    List<StoryResponse>.from(
        json.decode(str).map((x) => StoryResponse.fromJson(x)));

String storyResponseToJson(List<StoryResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoryResponse {
  List<StoryList>? storyList;

  StoryResponse({
    this.storyList,
  });

  factory StoryResponse.fromJson(Map<String, dynamic> json) => StoryResponse(
        storyList: json["storyList"] == null
            ? []
            : List<StoryList>.from(
                json["storyList"]!.map((x) => StoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "storyList": storyList == null
            ? []
            : List<dynamic>.from(storyList!.map((x) => x.toJson())),
      };
}

class StoryList {
  String? role;
  String? tokenId;
  String? endDate;
  String? projectImage;
  String? description;
  String? loggedTime;
  int? assigneeId;
  int? currentStatusId;
  String? plannedEndDate;
  String? attachment;
  List<WorkLog>? workLog;
  int? teamId;
  int? optionId;
  String? iadStatus;
  int? projectId;
  String? requestType;
  String? estimateTime;
  String? currentStatus;
  int? requestTypeId;
  String? requestDateTime;
  String? module;
  String? iadAssigneeEmpId;
  String? team;
  String? priority;
  int? priorityId;
  String? issueType;
  String? countOfStory;
  String? parentRequestId;
  String? plannedStartDate;
  String? createdBy;
  String? requestId;
  String? assignee;
  String? projectName;
  String? optionName;
  String? storyType;
  int? moduleId;
  String? startDate;

  StoryList({
    this.role,
    this.tokenId,
    this.endDate,
    this.projectImage,
    this.description,
    this.loggedTime,
    this.assigneeId,
    this.currentStatusId,
    this.plannedEndDate,
    this.attachment,
    this.workLog,
    this.teamId,
    this.optionId,
    this.iadStatus,
    this.projectId,
    this.requestType,
    this.estimateTime,
    this.currentStatus,
    this.requestTypeId,
    this.requestDateTime,
    this.module,
    this.iadAssigneeEmpId,
    this.team,
    this.priority,
    this.priorityId,
    this.issueType,
    this.countOfStory,
    this.parentRequestId,
    this.plannedStartDate,
    this.createdBy,
    this.requestId,
    this.assignee,
    this.projectName,
    this.optionName,
    this.storyType,
    this.moduleId,
    this.startDate,
  });

  factory StoryList.fromJson(Map<String, dynamic> json) => StoryList(
        role: json["role"],
        tokenId: json["tokenID"],
        endDate: json["endDate"],
        projectImage: json["projectImage"],
        description: json["description"],
        loggedTime: json["loggedTime"],
        assigneeId: json["assigneeID"],
        currentStatusId: json["currentStatusID"],
        plannedEndDate: json["plannedEndDate"],
        attachment: json["attachment"],
        workLog: json["workLog"] == null
            ? []
            : List<WorkLog>.from(
                json["workLog"]!.map((x) => WorkLog.fromJson(x))),
        teamId: json["teamID"],
        optionId: json["optionID"],
        iadStatus: json["iadStatus"],
        projectId: json["projectID"],
        requestType: json["requestType"],
        estimateTime: json["estimateTime"],
        currentStatus: json["currentStatus"],
        requestTypeId: json["requestTypeID"],
        requestDateTime: json["requestDateTime"],
        module: json["module"],
        iadAssigneeEmpId: json["iadAssigneeEmpID"],
        team: json["team"],
        priority: json["priority"],
        priorityId: json["priorityID"],
        issueType: json["issueType"],
        countOfStory: json["countOfStory"],
        parentRequestId: json["parentRequestID"],
        plannedStartDate: json["plannedStartDate"],
        createdBy: json["createdBy"],
        requestId: json["requestID"],
        assignee: json["assignee"],
        projectName: json["projectName"],
        optionName: json["optionName"],
        storyType: json["storyType"],
        moduleId: json["moduleID"],
        startDate: json["startDate"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "tokenID": tokenId,
        "endDate": endDate,
        "projectImage": projectImage,
        "description": description,
        "loggedTime": loggedTime,
        "assigneeID": assigneeId,
        "currentStatusID": currentStatusId,
        "plannedEndDate": plannedEndDate,
        "attachment": attachment,
        "workLog": workLog == null
            ? []
            : List<dynamic>.from(workLog!.map((x) => x.toJson())),
        "teamID": teamId,
        "optionID": optionId,
        "iadStatus": iadStatus,
        "projectID": projectId,
        "requestType": requestType,
        "estimateTime": estimateTime,
        "currentStatus": currentStatus,
        "requestTypeID": requestTypeId,
        "requestDateTime": requestDateTime,
        "module": module,
        "iadAssigneeEmpID": iadAssigneeEmpId,
        "team": team,
        "priority": priority,
        "priorityID": priorityId,
        "issueType": issueType,
        "countOfStory": countOfStory,
        "parentRequestID": parentRequestId,
        "plannedStartDate": plannedStartDate,
        "createdBy": createdBy,
        "requestID": requestId,
        "assignee": assignee,
        "projectName": projectName,
        "optionName": optionName,
        "storyType": storyType,
        "moduleID": moduleId,
        "startDate": startDate,
      };
}

class WorkLog {
  String? requestId;
  String? loggedDescription;
  String? loggedEmpName;
  String? loggedDate;
  String? loggedTime;

  WorkLog({
    this.requestId,
    this.loggedDescription,
    this.loggedEmpName,
    this.loggedDate,
    this.loggedTime,
  });

  factory WorkLog.fromJson(Map<String, dynamic> json) => WorkLog(
        requestId: json["requestID"],
        loggedDescription: json["loggedDescription"],
        loggedEmpName: json["loggedEmpName"],
        loggedDate: json["loggedDate"],
        loggedTime: json["loggedTime"],
      );

  Map<String, dynamic> toJson() => {
        "requestID": requestId,
        "loggedDescription": loggedDescription,
        "loggedEmpName": loggedEmpName,
        "loggedDate": loggedDate,
        "loggedTime": loggedTime,
      };
}
