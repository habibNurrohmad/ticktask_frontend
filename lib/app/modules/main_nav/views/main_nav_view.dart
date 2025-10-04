import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../calendar/views/calendar_view.dart';
import '../../history/views/history_view.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_nav_controller.dart';
import '../../../core/values/app_colors.dart';
import '../../create_new_task/views/create_new_task_view.dart'; // <-- tambah import

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomeView(),
      CalendarView(),
      HistoryView(),
      ProfileView(),
    ];

    return Obx(() {
      final index = controller.currentIndex.value;
      final indicatorColor = <Color>[
        AppColors.mildBlue,
        AppColors.mildGreen,
        AppColors.mildYellow,
        AppColors.mildPink,
      ][index];

      // Warna tombol "Tambahkan Task Baru" per tab
      final bool isHome = index == 0;
      final bool isCalendar = index == 1;
      final Color? newTaskFillColor =
          isHome ? AppColors.regularBlue : (isCalendar ? AppColors.lightGreen : null);
      final Color? newTaskMaterialColor =
          isHome ? AppColors.darkBlue : (isCalendar ? AppColors.darkGreen : null);
      // Tambah warna foreground (ikon + teks)
      final Color? newTaskForegroundColor =
          isHome ? AppColors.darkBlue : (isCalendar ? AppColors.darkGreen : null);

      return Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: pages,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (index == 0 || index == 1)
                      _NewTaskButton(
                        color: newTaskFillColor!,            // bg icon & bg teks
                        materialColor: newTaskMaterialColor!, // bg material utama
                        foregroundColor: newTaskForegroundColor!, // warna ikon & teks
                        onTap: () => Get.to(() => const CreateNewTaskView()),
                      ),
                    if (index == 0 || index == 1) const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Material(
                        elevation: 8,
                        shadowColor: Colors.black.withOpacity(0.12),
                        color: Colors.white,
                        child: _AnimatedBottomBar(
                          index: index,
                          indicatorColor: indicatorColor,
                          onTap: controller.onTabSelected,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// Bottom bar kustom dengan indikator lingkaran besar yang dianimasikan
class _AnimatedBottomBar extends StatelessWidget {
  const _AnimatedBottomBar({
    required this.index,
    required this.indicatorColor,
    required this.onTap,
  });

  final int index;
  final Color indicatorColor;
  final ValueChanged<int> onTap;

  static const double _barHeight = 88;
  static const double _indicatorSize = 62; // lebih besar dari default
  static const double _iconSize = 35;

  @override
  Widget build(BuildContext context) {
    const items = [
      (unselected: Icons.home_outlined, selected: Icons.home_rounded),
      (unselected: Icons.calendar_today_outlined, selected: Icons.calendar_month_rounded),
      (unselected: Icons.history_toggle_off_rounded, selected: Icons.history_rounded),
      (unselected: Icons.person_outline_rounded, selected: Icons.person_rounded),
    ];

    return SizedBox(
      height: _barHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final count = items.length;
          final itemWidth = width / count;
          final left = itemWidth * index + (itemWidth - _indicatorSize) / 2;

          return Stack(
            children: [
              // Background bar color
              Positioned.fill(
                child: ColoredBox(color: AppColors.lightCream),
              ),
              // Big circular indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: left,
                top: (_barHeight - _indicatorSize) / 2,
                width: _indicatorSize,
                height: _indicatorSize,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: indicatorColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Icons row
              Row(
                children: [
                  for (var i = 0; i < count; i++)
                    Expanded(
                      child: Center(
                        child: IconButton(
                          onPressed: () => onTap(i),
                          iconSize: _iconSize,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            i == index ? items[i].selected : items[i].unselected,
                            color: i == index ? AppColors.lightCream : Colors.black87,
                            size: _iconSize,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NewTaskButton extends StatelessWidget {
  const _NewTaskButton({
    required this.onTap,
    required this.color,
    required this.materialColor,
    required this.foregroundColor,
  });

  final VoidCallback onTap;
  final Color color;
  final Color materialColor;
  final Color foregroundColor;

  static const double _height = 70;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: materialColor, // warna material utama (Home: darkBlue, Calendar: darkGreen)
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.10),
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: _height,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // Container icon add task
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color, // Home: regularBlue, Calendar: lightGreen
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_task_rounded,
                  color: foregroundColor, // Home: darkBlue, Calendar: darkGreen
                ),
              ),
              const SizedBox(width: 8),
              // Container teks "Tambahkan Task Baru"
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: color, // Home: regularBlue, Calendar: lightGreen
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Text(
                    'Tambahkan Task Baru',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // const Icon(
              //   Icons.chevron_right_rounded,
              //   color: Colors.black54,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
