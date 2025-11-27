import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/task_model.dart';
import '../../../core/services/api_services.dart';

enum TaskFilter { prioritas, terdekat, semua }

class HomeController extends GetxController with WidgetsBindingObserver {
  final api = ApiService();

  final isLoading = false.obs;
  final tasks = <TaskModel>[].obs;

  // tambahan untuk view
  final searchQuery = "".obs;
  final selectedFilter = TaskFilter.semua.obs;
  // Selected year filter (null = semua tahun)
  final selectedYear = RxnInt();

  // Trigger refresh dari luar
  final refreshTrigger = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    fetchTasks();

    ever(refreshTrigger, (_) {
      fetchTasks();
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  // Dipanggil otomatis ketika kembali ke halaman Home
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchTasks(); // auto refresh ketika kembali
    }
  }

  // ---------------------------------------------------------------------------
  // FETCH TASKS
  // ---------------------------------------------------------------------------
  Future<void> fetchTasks() async {
    try {
      isLoading(true);

      final response = await api.getTasks();
      // Get.log("TASK RESPONSE => ${response.body}");

      if (response.statusCode == 200 && response.body['data'] != null) {
        final List data = response.body['data'];
        tasks.value = data.map((e) => TaskModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", response.body["message"] ?? "Gagal memuat data");
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat memuat task");
    } finally {
      isLoading(false);
    }
  }

  // ---------------------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------------------
  void setSearchQuery(String value) {
    searchQuery.value = value.toLowerCase();
  }

  // ---------------------------------------------------------------------------
  // FILTER
  // ---------------------------------------------------------------------------
  void setFilter(TaskFilter filter) {
    selectedFilter.value = filter;
  }

  // ---------------------------------------------------------------------------
  // FILTERED LIST (digunakan View)
  // ---------------------------------------------------------------------------
  List<TaskModel> get filteredTasks {
    // Jangan tampilkan task yang sudah selesai (isDone == 1)
    List<TaskModel> list = tasks.where((t) => t.isDone != 1).toList();

    // -- SEARCH --
    if (searchQuery.value.isNotEmpty) {
      list =
          list.where((t) {
            return (t.title ?? "").toLowerCase().contains(searchQuery.value) ||
                (t.description ?? "").toLowerCase().contains(searchQuery.value);
          }).toList();
    }

    // -- FILTER: Prioritas
    if (selectedFilter.value == TaskFilter.prioritas) {
      list = list.where((t) => t.isPriority == 1).toList();
    }

    // -- FILTER: Terdekat (sort deadline)
    if (selectedFilter.value == TaskFilter.terdekat) {
      list = List.from(list)
        ..sort((a, b) => (a.deadline ?? "").compareTo(b.deadline ?? ""));
    }

    // -- FILTER: Selected Year (if set)
    if (selectedYear.value != null) {
      final y = selectedYear.value!;
      list = list.where((t) {
        if (t.deadline == null) return false;
        try {
          final dt = DateTime.tryParse(t.deadline!);
          if (dt == null) return false;
          return dt.year == y;
        } catch (_) {
          return false;
        }
      }).toList();
    }

    // -- FILTER: Selected Month (if set)
    if (selectedMonth.value != null) {
      final m = selectedMonth.value!;
      list = list.where((t) {
        if (t.deadline == null) return false;
        try {
          final dt = DateTime.tryParse(t.deadline!);
          if (dt == null) return false;
          return dt.month == m;
        } catch (_) {
          return false;
        }
      }).toList();
    }

    return list;
  }

  // Return list of unique years present in unfinished tasks' deadlines
  List<int> get availableYears {
    final years = <int>{};
    for (final t in tasks) {
      // consider only tasks that are not done (isDone != 1)
      if (t.isDone == 1) continue;
      final d = t.deadline;
      if (d == null) continue;
      final dt = DateTime.tryParse(d);
      if (dt == null) continue;
      years.add(dt.year);
    }

    final list = years.toList()..sort((a, b) => b.compareTo(a));
    return list;
  }

  void setSelectedYear(int? year) {
    selectedYear.value = year;
    // Clear selected month when year changes to avoid stale selection
    selectedMonth.value = null;
  }

  // Selected month filter (1-12), null = semua bulan
  final selectedMonth = RxnInt();

  // Return list of unique months (1-12) present in unfinished tasks' deadlines.
  // If [year] is provided, filter months for that year; otherwise across all years.
  List<int> availableMonths([int? year]) {
    final months = <int>{};
    for (final t in tasks) {
      if (t.isDone == 1) continue;
      final d = t.deadline;
      if (d == null) continue;
      final dt = DateTime.tryParse(d);
      if (dt == null) continue;
      if (year != null && dt.year != year) continue;
      months.add(dt.month);
    }
    final list = months.toList()..sort();
    return list;
  }

  void setSelectedMonth(int? month) {
    selectedMonth.value = month;
  }
}
