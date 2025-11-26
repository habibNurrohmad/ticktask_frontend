class TaskModel {
  final int? id;
  final String? title;
  final String? description;
  final String? deadline;
  final int? isDone;
  final String? type;
  final int? isPriority; // <-- integer, bukan bool!

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.deadline,
    this.isDone,
    this.type,
    this.isPriority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      deadline: json['deadline'],
      isDone: json['is_done'], // int (0/1)
      type: json['type'],
      isPriority: json['is_priority'], // int (0/1)
    );
  }
}
