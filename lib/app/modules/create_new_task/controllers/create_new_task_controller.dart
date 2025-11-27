import 'package:get/get.dart';
import '../../../core/services/api_services.dart';

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
    if (title.isEmpty) {
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
        Get.back(result: true);
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
