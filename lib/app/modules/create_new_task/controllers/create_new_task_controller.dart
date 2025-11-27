import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_services.dart';
import '../../main_nav/controllers/main_nav_controller.dart';

class CreateNewTaskController extends GetxController {
  final api = ApiService();

  // Input Controller
  final title = "".obs;
  final description = "".obs;
  final deadline = "".obs;

  // Priority Switch
  final isPriority = false.obs;

  // Loading State
  final isLoading = false.obs;

  // -----------------------------------------------------------
  // SUBMIT TASK
  // -----------------------------------------------------------
  Future<void> submitTask() async {
    if (title.value.trim().isEmpty) {
      Get.snackbar("Gagal", "Judul tidak boleh kosong");
      return;
    }

    isLoading(true);

    final body = {
      "title": title.value,
      "description": description.value,
      "deadline": deadline.value,
      "is_priority": isPriority.value ? 1 : 0,
      "type": "task",
    };

    try {
      final response = await api.createTask(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Berhasil", "Task berhasil dibuat");
        await Future.delayed(const Duration(milliseconds: 500));

        // Pastikan MainNav berada di tab Home jika ada
        try {
          final mainC = Get.find<MainNavController>();
          mainC.onTabSelected(0);
        } catch (_) {}

        // Debug log and kembalikan hasil ke pemanggil (pemanggil akan melakukan fetch)
        Get.log('CreateNewTask: task created, attempting to close view');

        // Prefer Navigator.pop via Get.context if available (fallback for navigation issues)
        try {
          if (Get.context != null) {
            Get.log('CreateNewTask: popping via Navigator.of(Get.context!).pop(true)');
            Navigator.of(Get.context!).pop(true);
          } else {
            Get.log('CreateNewTask: Get.context is null, using Get.back');
            Get.back(result: true);
          }
        } catch (e) {
          Get.log('CreateNewTask: pop failed ($e), attempting Get.back');
          try {
            Get.back(result: true);
          } catch (_) {}
        }
      } else {
        final msg =
            (response.body is Map ? response.body["message"] : null) ??
            "Gagal membuat task";
        Get.snackbar("Error", msg.toString());
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat membuat task");
    } finally {
      isLoading(false);
    }
  }
}
