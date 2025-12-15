import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/home_controller.dart';
import '../model/task_model.dart';
import '../../task_detail/controllers/task_detail_controller.dart';
import '../../task_detail/views/task_detail_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key}); // <-- pakai const, hapus Get.put()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            const Center(
              child: Text(
                "TickTask",
                style: TextStyle(
                  fontFamily: 'Rothek',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.lightCream,
                ),
              ),
            ),

            const Center(
              child: Text(
                "Hi, Someone",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.lightCream,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.lightCream,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: controller.setSearchQuery,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 12),
                                    hintText: 'Search by keywords',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 56),
                            ],
                          ),
                        ),

                        // Search circle button on right edge of the pill
                        Positioned(
                          right: 6,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              splashRadius: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Bell icon circle
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.lightCream,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: _filterChip("Prioritas", TaskFilter.prioritas),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _filterChip("Terdekat", TaskFilter.terdekat),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _filterChip("Semua", TaskFilter.semua),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 14),

            Obx(() {
              final showCalendar = controller.selectedFilter.value == TaskFilter.semua;
              final monthNames = const [
                '',
                'Januari',
                'Februari',
                'Maret',
                'April',
                'Mei',
                'Juni',
                'Juli',
                'Agustus',
                'September',
                'Oktober',
                'November',
                'Desember'
              ];

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: -1.0,
                      child: child,
                    ),
                  );
                },
                child: showCalendar
                    ? Padding(
                        key: const ValueKey('calendarRow'),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Tahun
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final years = controller.availableYears;
                                      await showModalBottomSheet<void>(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16)),
                                        ),
                                        builder: (ctx) {
                                          return SafeArea(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(16),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Pilih Tahun',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          controller.setSelectedYear(
                                                              null);
                                                          Navigator.pop(ctx);
                                                        },
                                                        child: const Text('Semua'),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const Divider(height: 1),
                                                if (years.isEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets.all(20),
                                                    child: Text(
                                                      'Tidak ada tahun tersedia',
                                                      style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(.6),
                                                      ),
                                                    ),
                                                  )
                                                else
                                                  Flexible(
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: years.length,
                                                      itemBuilder: (_, i) {
                                                        final y = years[i];
                                                        return ListTile(
                                                          title: Text(y.toString()),
                                                          onTap: () {
                                                            controller.setSelectedYear(y);
                                                            Navigator.pop(ctx);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                const SizedBox(height: 12),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 45,
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: AppColors.lightCream,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Obx(() {
                                          final sel = controller.selectedYear.value;
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(sel == null ? 'Semua Tahun' : sel.toString()),
                                            ],
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                            
                                // Bulan
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final months = controller
                                          .availableMonths(controller.selectedYear.value);
                                      await showModalBottomSheet<void>(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16)),
                                        ),
                                        builder: (ctx) {
                                          return SafeArea(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(16),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Pilih Bulan',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          controller.setSelectedMonth(
                                                              null);
                                                          Navigator.pop(ctx);
                                                        },
                                                        child: const Text('Semua'),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const Divider(height: 1),
                                                if (months.isEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets.all(20),
                                                    child: Text(
                                                      'Tidak ada bulan tersedia',
                                                      style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(.6),
                                                      ),
                                                    ),
                                                  )
                                                else
                                                  Flexible(
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: months.length,
                                                      itemBuilder: (_, i) {
                                                        final m = months[i];
                                                        return ListTile(
                                                          title: Text(monthNames[m]),
                                                          onTap: () {
                                                            controller.setSelectedMonth(m);
                                                            Navigator.pop(ctx);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                const SizedBox(height: 12),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 45,
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: AppColors.lightCream,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Obx(() {
                                          final sel = controller.selectedMonth.value;
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.date_range,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(sel == null
                                                  ? 'Semua Bulan'
                                                  : monthNames[sel]),
                                            ],
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                      )
                    : const SizedBox(
                        key: ValueKey('calendarEmpty'),
                        height: 0,
                      ),
              );
            }),

            const SizedBox(height: 5),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (controller.filteredTasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Tidak ada task",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 200),
                      ],
                    ),
                  );
                }
                

                return RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: AppColors.mildBlue,
                  onRefresh: controller.fetchTasks,
                  child: Stack(
                    children: [
                      ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 205),
                        itemCount: controller.filteredTasks.length,
                        itemBuilder: (_, i) {
                          return _taskCard(controller.filteredTasks[i]);
                        },
                      ),

                      // Overlay gradient hitam dari bawah (0% -> 100%)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 200,
                        child: IgnorePointer(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0x00000000), // 0% hitam (transparan)
                                  Color(0xAA000000),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // FILTER CHIP
  Widget _filterChip(String label, TaskFilter filter) {
    final isSelected = controller.selectedFilter.value == filter;
    Color bgColor;
    Color textColor;

    if (isSelected) {
      if (filter == TaskFilter.semua) {
        bgColor = AppColors.darkBlue;
      } else {
        bgColor = AppColors.softCyan;
      }
      textColor = Colors.white;
    } else {
      bgColor = AppColors.lightCream;
      textColor = Colors.black;
    }

    return GestureDetector(
      onTap: () => controller.setFilter(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // TASK CARD
  Widget _taskCard(TaskModel t) {
    return GestureDetector(
      onTap: () {
        final id = t.id;
        if (id == null) {
          Get.snackbar('Error', 'Task id kosong');
          return;
        }

        // Prepare controller and load detail so controller is available for the pushed view
        if (!Get.isRegistered<TaskDetailController>()) {
          final c = Get.put(TaskDetailController());
          c.fetchDetail(id);
        } else {
          Get.find<TaskDetailController>().fetchDetail(id);
        }

        Navigator.of(Get.context!).push(
          CupertinoPageRoute(
            builder: (_) => const TaskDetailView(),
            settings: RouteSettings(arguments: id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightCream,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    t.title ?? '',
                    style: const TextStyle(
                      fontFamily: 'Rothek',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                // moved PRIORITAS label next to the deadline container below

                const SizedBox(width: 8),

                // Small three-dots box button at top-right of the task card
                PopupMenuButton<int>(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(value: 1, child: Text('Edit')),
                    PopupMenuItem(value: 2, child: Text('Hapus')),
                  ],
                  onSelected: (v) {
                    if (v == 1) {
                      // contoh: navigasi ke edit (implementasi sesuai kebutuhan)
                      Get.toNamed('/task-edit', arguments: t.id);
                    } else if (v == 2) {
                      // placeholder: fungsi hapus belum diimplementasikan di controller
                      Get.snackbar('Hapus', 'Fungsi hapus belum diimplementasikan',
                          backgroundColor: Colors.black.withOpacity(0.6),
                          colorText: Colors.white);
                    }
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.more_vert,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              t.description ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(.7),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        t.deadline.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                if (t.isPriority == 1)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "PRIORITAS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
