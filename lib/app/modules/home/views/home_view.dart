import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/home_controller.dart';
import '../model/task_model.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // --- TITLE ---
            const Center(
              child: Text(
                "TickTask",
                style: TextStyle(
                  fontFamily: 'Rothek',
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.lightCream,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // --- SEARCH BAR ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lightCream,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextField(
                  onChanged: controller.setSearchQuery,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search task...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // --- FILTER LABEL ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                return Row(
                  children: [
                    _filterChip("Prioritas", TaskFilter.prioritas),
                    const SizedBox(width: 10),
                    _filterChip("Terdekat", TaskFilter.terdekat),
                    const SizedBox(width: 10),
                    _filterChip("Semua", TaskFilter.semua),
                  ],
                );
              }),
            ),

            const SizedBox(height: 20),

            // --- LIST CARD ---
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (controller.filteredTasks.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada task",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.filteredTasks.length,
                  itemBuilder: (_, i) {
                    return _taskCard(controller.filteredTasks[i]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // --- FILTER CHIP ---
  Widget _filterChip(String label, TaskFilter filter) {
    final isSelected = controller.selectedFilter.value == filter;

    return GestureDetector(
      onTap: () => controller.setFilter(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // --- CARD TASK ---
  Widget _taskCard(TaskModel t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCream,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.title ?? '',
            style: const TextStyle(
              fontFamily: 'Rothek',
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            t.description ?? '',
            style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(.7)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.timer, size: 16, color: Colors.black.withOpacity(.7)),
              const SizedBox(width: 6),
              Text(
                t.deadline.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
