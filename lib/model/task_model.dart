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
