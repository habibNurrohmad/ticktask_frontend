class TaskModel {
  final int id;
  final int userId;
  String title;
  String description;
  DateTime? deadline;
  bool isDone;

  TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.deadline,
    required this.isDone,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      isDone: json['is_done'] == 1,
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      "title": title,
      "description": description,
      "deadline": deadline?.toString().split(".").first,
      "is_done": isDone ? 1 : 0,
    };
  }
}
