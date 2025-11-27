class CalendarResponse {
  final bool status;
  final String message;
  final List<CalendarTask> data;

  CalendarResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CalendarResponse.fromJson(Map<String, dynamic> json) {
    return CalendarResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? "",
      data:
          (json['data'] as List).map((e) => CalendarTask.fromJson(e)).toList(),
    );
  }
}

class CalendarTask {
  final int id;
  final int userId;
  final String title;
  final String description;

  final DateTime? deadline;
  final DateTime? startAt;
  final DateTime? endAt;

  final int isDone;
  final String type;
  final int isPriority;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CalendarTask({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.deadline,
    this.startAt,
    this.endAt,
    required this.isDone,
    required this.type,
    required this.isPriority,
    this.createdAt,
    this.updatedAt,
  });

  factory CalendarTask.fromJson(Map<String, dynamic> json) {
    return CalendarTask(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'] ?? "",
      description: json['description'] ?? "",

      deadline:
          json['deadline'] != null ? DateTime.tryParse(json['deadline']) : null,

      startAt:
          json['start_at'] != null ? DateTime.tryParse(json['start_at']) : null,

      endAt: json['end_at'] != null ? DateTime.tryParse(json['end_at']) : null,

      isDone: json['is_done'] ?? 0,
      type: json['type'] ?? "",
      isPriority: json['is_priority'] ?? 0,

      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,

      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
    );
  }
}
