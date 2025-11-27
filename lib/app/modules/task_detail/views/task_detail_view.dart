import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/task_detail_controller.dart';

class TaskDetailView extends GetView<TaskDetailController> {
  const TaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildBlue,
      appBar: AppBar(
        backgroundColor: AppColors.mildBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.lightCream),
        title: const Text(
          "Task Detail",
          style: TextStyle(
            color: AppColors.lightCream,
            fontFamily: 'Rothek',
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final t = controller.task.value!;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.lightCream,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        t.title,
                        style: const TextStyle(
                          fontFamily: 'Rothek',
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (t.isPriority == 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "PRIORITAS",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // Description
                Text(
                  t.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(.7),
                  ),
                ),

                const SizedBox(height: 20),

                // Deadline
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 18,
                      color: Colors.black.withOpacity(.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      t.deadline,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(.7),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Checkbox
                Obx(() {
                  return Row(
                    children: [
                      Checkbox(
                        value: controller.isDone.value,
                        onChanged: (v) => controller.updateDone(v!),
                      ),
                      const Text(
                        "Tandai sebagai selesai",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}
