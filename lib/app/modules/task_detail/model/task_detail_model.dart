class TaskDetailModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String deadline;
  final String? startAt;
  final String? endAt;
  final int isDone;
  final String type;
  final int isPriority;

  TaskDetailModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.deadline,
    this.startAt,
    this.endAt,
    required this.isDone,
    required this.type,
    required this.isPriority,
  });

  factory TaskDetailModel.fromJson(Map<String, dynamic> json) {
    return TaskDetailModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      deadline: json['deadline'],
      startAt: json['start_at'],
      endAt: json['end_at'],
      isDone: json['is_done'],
      type: json['type'],
      isPriority: json['is_priority'],
    );
  }
}
