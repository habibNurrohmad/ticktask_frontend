class NotificationItem {
  NotificationItem({
    this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.formattedDate,
  });

  final int? id;
  final String title;
  final String body;
  final DateTime createdAt;
  final String formattedDate;

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final rawCreatedAt =
        json['created_at'] ?? json['createdAt'] ?? json['date'];
    DateTime parsedDate = DateTime.now();
    if (rawCreatedAt is String) {
      final parsed = DateTime.tryParse(rawCreatedAt);
      if (parsed != null) {
        parsedDate = parsed.toLocal();
      }
    } else if (rawCreatedAt is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(rawCreatedAt * 1000);
    }

    return NotificationItem(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      title: (json['title'] ?? json['subject'] ?? '').toString(),
      body:
          (json['body'] ?? json['message'] ?? json['description'] ?? '')
              .toString(),
      createdAt: parsedDate,
      formattedDate: NotificationDateFormatter.formatFull(parsedDate),
    );
  }
}

class NotificationSection {
  NotificationSection({
    required this.label,
    required this.items,
    required this.dateKey,
  });

  final String label;
  final List<NotificationItem> items;
  final DateTime dateKey;
}

class NotificationDateFormatter {
  static const List<String> _monthNames = <String>[
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static String formatFull(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = _monthNames[date.month - 1];
    return '$day $month ${date.year}';
  }

  static String relativeLabel(DateTime date, DateTime reference) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedReference = DateTime(
      reference.year,
      reference.month,
      reference.day,
    );
    final difference = normalizedReference.difference(normalizedDate).inDays;

    if (difference == 0) {
      return 'Hari ini';
    }
    if (difference == 1) {
      return 'Kemarin';
    }
    return formatFull(date);
  }
}
