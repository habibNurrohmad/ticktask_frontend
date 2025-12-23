import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/TaskModel.dart';
import '../../../core/services/api_services.dart';
import 'package:ticktask_frontend/app/routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class EditTaskController extends GetxController {
  final api = ApiService();

  final isLoading = false.obs;
  final task = Rxn<TaskModel>();

  final titleC = TextEditingController();
  final descC = TextEditingController();
  final deadline = Rxn<DateTime>();
  final isDone = false.obs;
  final isPriority = false.obs;

  late int taskId;

  @override
  void onInit() {
    super.onInit();
    taskId = Get.arguments as int;
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;

    try {
      final res = await api.getTaskDetail(taskId);

      if (res.isOk && res.body?['status'] == true) {
        final data = res.body['data'];
        final model = TaskModel.fromJson(data);

        task.value = model;
        titleC.text = model.title;
        descC.text = model.description;
        deadline.value = model.deadline;
        isDone.value = model.isDone;
        isPriority.value = (model.isPriority == 1);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTask() async {
    isLoading.value = true;

    try {
      final body = {
        "title": titleC.text.trim(),
        "description": descC.text.trim(),
        "deadline": deadline.value?.toString().split(".").first,
        "is_done": isDone.value ? 1 : 0,
        "is_priority": isPriority.value ? 1 : 0,
      };

      final res = await api.updateTask(taskId, body);

      if (res.isOk && res.body?['status'] == true) {
        // refresh home tasks if controller is available
        try {
          if (Get.isRegistered<HomeController>()) {
            await Get.find<HomeController>().fetchTasks();
          }
        } catch (_) {}

        // navigate back to Home and rebuild tabs
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.back(result: false);
      }
    } catch (_) {
      Get.back(result: false);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleC.dispose();
    descC.dispose();
    super.onClose();
  }
}
