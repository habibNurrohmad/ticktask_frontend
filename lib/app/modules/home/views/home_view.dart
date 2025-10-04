import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ticktask_frontend/app/core/values/app_colors.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  // Tombol filter reusable (aktif/non-aktif)
  Widget _filterButton({
    required String label,
    required TaskFilter value,
  }) {
    final isSelected = controller.selectedFilter.value == value;
    return GestureDetector(
      onTap: () => controller.setFilter(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBlue : AppColors.skyBlue,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 5,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Rothek',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Title at top center
            const Center(
              child: Text(
              'TickTask',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rothek',
                fontSize: 32,
                fontWeight: FontWeight.w900, // Rothek Black
                color: AppColors.lightCream,
              ),
              ),
            ),
            const Center(
              child: Text(
              'Hi, Someone',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rothek',
                fontSize: 20,
                fontWeight: FontWeight.w400, // Rothek Regular
                color: AppColors.lightCream,
              ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Search bar
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightCream,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.fromLTRB(30, 3, 3, 3),
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search by keywords',
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                              style: TextStyle(
                                fontFamily: 'Rothek',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                            Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: const EdgeInsets.all(15),
                            child: const Icon(Icons.search, color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Notification button
                    Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightCream,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: IconButton(
                      onPressed: () {
                      // TODO: handle notification button tap
                      },
                      icon: const Icon(Icons.notifications, color: Colors.black),
                      iconSize: 35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Row filter: Prioritas, Terdekat, Semua (rata kiri, eksklusif)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _filterButton(label: 'Prioritas', value: TaskFilter.prioritas),
                    const SizedBox(width: 10),
                    _filterButton(label: 'Terdekat', value: TaskFilter.terdekat),
                    const SizedBox(width: 10),
                    _filterButton(label: 'Semua', value: TaskFilter.semua),
                  ],
                );
              }),
            ),

            // ... add other content below as needed
          ],
        ),
      ),
    );
  }
}
