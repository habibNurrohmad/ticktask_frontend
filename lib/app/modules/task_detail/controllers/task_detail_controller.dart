import 'package:get/get.dart';
import '../../../core/services/api_services.dart';
import 'package:ticktask_frontend/app/modules/home/controllers/home_controller.dart';
import 'package:ticktask_frontend/app/modules/history/controllers/history_controller.dart';
import '../model/task_detail_model.dart';

class TaskDetailController extends GetxController {
  final api = ApiService();

  var isLoading = true.obs;
  var task = Rxn<TaskDetailModel>();
  var isDone = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      final args = Get.arguments;
      if (args is int) {
        fetchDetail(args);
      }
    }
  }

  Future<void> fetchDetail(int id) async {
    isLoading.value = true;

    final res = await api.getTaskDetail(id);

    if (res.statusCode == 200) {
      task.value = TaskDetailModel.fromJson(res.body['data']);
      isDone.value = task.value!.isDone == 1;
    }

    isLoading.value = false;
  }

  Future<void> updateDone(bool value) async {
    if (task.value == null) return;

    isDone.value = value;

    final body = {
      "title": task.value!.title,
      "description": task.value!.description,
      "deadline": task.value!.deadline,
      "start_at": task.value!.startAt,
      "end_at": task.value!.endAt,
      "is_priority": task.value!.isPriority,
      "is_done": value ? 1 : 0,
      "type": task.value!.type,
    };

    final res = await api.updateTask(task.value!.id, body);

    if (res.statusCode == 200) {
      // setelah update sukses → refresh daftar dan history jika ini adalah mark-as-done
      if (value == true) {
        try {
          Get.find<HomeController>().fetchTasks();
        } catch (_) {}

        try {
          Get.find<HistoryController>().fetchHistory();
        } catch (_) {}
      }

      // kembali ke view sebelumnya dengan result TRUE
      Get.back(result: true);
    } else {
      isDone.value = !value;
      Get.snackbar("Gagal", "Status tidak dapat diperbarui");
    }
  }
}