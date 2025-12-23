import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/task_detail_controller.dart';

class TaskDetailView extends GetView<TaskDetailController> {
  const TaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildBlue,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 30),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: AppBar(
            backgroundColor: AppColors.mildBlue,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 22,
              ),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              "Task Detail",
              style: TextStyle(
                fontFamily: 'Rhotek', // Font Rhotek
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700, // semi-bold
                letterSpacing: 0.3,
              ),
            ),
            centerTitle: true,
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.lightCream,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        t.title,
                        style: const TextStyle(
                          fontFamily: 'Rothek',
                          fontSize: 26,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (t.isPriority == 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "PRIORITAS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 14),
                Divider(color: Colors.black.withOpacity(0.15), thickness: .7),
                const SizedBox(height: 14),

                // DESCRIPTION BLOCK
                Text(
                  "Deskripsi",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(.7),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  t.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(.8),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 28),

                // TASK INFO
                _infoCard(
                  icon: Icons.calendar_month_rounded,
                  label: "Deadline",
                  value: t.deadline,
                ),

                const SizedBox(height: 8),

                if (t.startAt != null)
                  _infoCard(
                    icon: Icons.play_arrow_rounded,
                    label: "Mulai",
                    value: t.startAt!,
                  ),

                if (t.endAt != null) const SizedBox(height: 8),

                if (t.endAt != null)
                  _infoCard(
                    icon: Icons.stop_rounded,
                    label: "Selesai",
                    value: t.endAt!,
                  ),

                const SizedBox(height: 30),

                // DONE TOGGLE
                Obx(() {
                  return GestureDetector(
                    onTap: () async {
                      // Jika belum selesai, tampilkan dialog konfirmasi
                      if (!controller.isDone.value) {
                        final confirm = await showCupertinoDialog<bool>(
                          context: context,
                          builder: (ctx) => CupertinoAlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text(
                              'Apakah Anda yakin ingin menandai task ini sebagai selesai?',
                            ),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text('Batal'),
                                onPressed: () => Navigator.of(ctx).pop(false),
                              ),
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                child: const Text('Konfirmasi'),
                                onPressed: () => Navigator.of(ctx).pop(true),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          controller.updateDone(true);
                        }
                      } else {
                        // Jika sudah selesai, langsung toggle tanpa konfirmasi
                        controller.updateDone(false);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: controller.isDone.value
                            ? Colors.green.shade600
                            : Colors.grey.shade300,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            controller.isDone.value
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: controller.isDone.value
                                ? Colors.white
                                : Colors.black87,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            controller.isDone.value
                                ? "Task selesai"
                                : "Tandai sebagai selesai",
                            style: TextStyle(
                              color: controller.isDone.value
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  // WIDGET INFO CARD
  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.black.withOpacity(.7)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(.5),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}