import 'dart:collection';

import 'package:get/get.dart';

import '../../../core/services/api_services.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  final ApiService api = ApiService();

  final isLoading = false.obs;
  final notifications = <NotificationItem>[].obs;
  final sections = <NotificationSection>[].obs;
  final errorMessage = RxnString();

  @override
  void onReady() {
    super.onReady();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      errorMessage.value = null;

      final response = await api.getNotifications();

      if (response.statusCode != 200) {
        errorMessage.value =
            _extractMessage(response.body) ?? 'Gagal memuat notifikasi';
        notifications.clear();
        sections.clear();
        return;
      }

      final List<dynamic> rawList = _extractNotificationList(response.body);
      if (rawList.isEmpty) {
        notifications.clear();
        sections.clear();
        return;
      }

      final parsed =
          rawList
              .map((dynamic e) {
                if (e is Map<String, dynamic>) {
                  return NotificationItem.fromJson(e);
                }
                if (e is Map) {
                  return NotificationItem.fromJson(
                    Map<String, dynamic>.from(e),
                  );
                }
                return null;
              })
              .whereType<NotificationItem>()
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      notifications.assignAll(parsed);
      sections.assignAll(_buildSections(parsed));
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat notifikasi';
      notifications.clear();
      sections.clear();
    } finally {
      isLoading(false);
    }
  }

  void refreshNotifications() => fetchNotifications();

  List<NotificationSection> _buildSections(List<NotificationItem> items) {
    if (items.isEmpty) {
      return <NotificationSection>[];
    }

    final Map<String, _SectionAccumulator> grouped =
        LinkedHashMap<String, _SectionAccumulator>();

    for (final NotificationItem item in items) {
      final String key = _dayKey(item.createdAt);
      grouped
          .putIfAbsent(key, () => _SectionAccumulator(item.createdAt))
          .items
          .add(item);
    }

    final List<_SectionAccumulator> ordered =
        grouped.values.toList()..sort((a, b) => b.date.compareTo(a.date));

    return ordered.map((acc) {
      acc.items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final label = NotificationDateFormatter.relativeLabel(
        acc.date,
        DateTime.now(),
      );
      return NotificationSection(
        label: label,
        items: List<NotificationItem>.from(acc.items),
        dateKey: acc.date,
      );
    }).toList();
  }

  List<dynamic> _extractNotificationList(dynamic body) {
    if (body is List) {
      return body;
    }

    if (body is Map) {
      final mapBody = Map<String, dynamic>.from(body as Map);
      for (final key in <String>['data', 'notifications', 'items', 'results']) {
        final dynamic value = mapBody[key];
        if (value is List) {
          return value;
        }
      }
    }

    return <dynamic>[];
  }

  String? _extractMessage(dynamic body) {
    if (body is Map) {
      final mapBody = Map<String, dynamic>.from(body as Map);
      for (final key in <String>['message', 'error', 'detail']) {
        final dynamic value = mapBody[key];
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }
    return null;
  }
}

class _SectionAccumulator {
  _SectionAccumulator(DateTime sourceDate)
    : date = DateTime(sourceDate.year, sourceDate.month, sourceDate.day);

  final DateTime date;
  final List<NotificationItem> items = <NotificationItem>[];
}

String _dayKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
