class HistoryModel {
  final int id;
  final String title;
  final String description;
  final DateTime? deadline;
  final int isDone;
  final String type;

  HistoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.isDone,
    required this.type,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      isDone: json['is_done'],
      type: json['type'],
    );
  }

  // determine status
  bool get isLate {
    if (deadline == null) return false;
    final now = DateTime.now();
    return isDone == 0 && deadline!.isBefore(now);
  }

  bool get isFinished {
    if (deadline == null) return isDone == 1;
    return isDone == 1 && deadline!.isAfter(DateTime(2000));
  }
}
