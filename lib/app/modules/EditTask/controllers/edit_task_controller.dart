import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/TaskModel.dart';
import '../../../core/services/api_services.dart';

class EditTaskController extends GetxController {
  final api = ApiService();

  final isLoading = false.obs;
  final task = Rxn<TaskModel>();

  final titleC = TextEditingController();
  final descC = TextEditingController();
  final deadline = Rxn<DateTime>();
  final isDone = false.obs;

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
      };

      final res = await api.updateTask(taskId, body);

      if (res.isOk && res.body?['status'] == true) {
        // ✅ CUMA INI
        Get.back(result: true);
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
