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
      Get.log("TASK RESPONSE => ${response.body}");

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
    List<TaskModel> list = tasks;

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

    return list;
  }
}
