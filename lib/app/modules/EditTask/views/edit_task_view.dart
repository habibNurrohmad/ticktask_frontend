import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_task_controller.dart';

class EditTaskView extends GetView<EditTaskController> {
  const EditTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: controller.titleC,
                decoration: const InputDecoration(labelText: "Judul"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.descC,
                decoration: const InputDecoration(labelText: "Deskripsi"),
              ),
              const SizedBox(height: 12),
              Obx(
                () => SwitchListTile(
                  title: const Text("Selesai"),
                  value: controller.isDone.value,
                  onChanged: (v) => controller.isDone.value = v,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => ListTile(
                  title: const Text("Deadline"),
                  subtitle: Text(
                    controller.deadline.value == null
                        ? "-"
                        : controller.deadline.value.toString(),
                  ),
                  trailing: const Icon(Icons.date_range),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: controller.deadline.value ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      controller.deadline.value = date;
                    }
                  },
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.updateTask,
                  child: const Text("Update Task"),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
