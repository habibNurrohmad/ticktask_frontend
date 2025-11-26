class TaskModel {
  final int? id;
  final String? title;
  final String? description;
  final String? deadline;
  final bool isDone;
  final String? type;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.deadline,
    this.isDone = false,
    this.type,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      deadline: json['deadline'],
      isDone: json['is_done'] == 1,
      type: json['type'],
    );
  }
}
