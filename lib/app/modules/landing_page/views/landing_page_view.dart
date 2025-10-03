import 'package:flutter/material.dart';
import 'package:animations/animations.dart'; // for SharedAxisTransition
import 'package:get/get.dart';
import 'package:ticktask_frontend/app/core/values/app_colors.dart';
import '../controllers/landing_page_controller.dart';

class LandingPageView extends GetView<LandingPageController> {
  const LandingPageView({super.key});

  Widget _buildPage({required String title, required String subtitle, required IconData icon, required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 84, color: color),
          ),
          const SizedBox(height: 40),
            Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildPage(
        title: 'Kelola Tugas Lebih Mudah',
        subtitle: 'Buat, pantau, dan selesaikan tugas harianmu dengan lebih terstruktur dan efisien.',
        icon: Icons.task_alt_rounded,
        color: AppColors.primary,
      ),
      _buildPage(
        title: 'Kolaborasi Tanpa Batas',
        subtitle: 'Bagikan tugas dan bekerjasama dengan teman atau tim secara real-time.',
        icon: Icons.group_rounded,
        color: Colors.orange.shade600,
      ),
      _buildPage(
        title: 'Capai Target Lebih Cepat',
        subtitle: 'Pantau progres dan raih produktivitas maksimal dengan insight yang akurat.',
        icon: Icons.insights_rounded,
        color: Colors.teal.shade600,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: pages,
            ),
            Positioned(
              top: 8,
              right: 16,
              child: Obx(() {
                final isLast = controller.currentPage.value == controller.totalPages - 1;
                return isLast
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: controller.skipToEnd,
                        child: const Text('Skip'),
                      );
              }),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Obx(() {
                final index = controller.currentPage.value;
                final isLast = index == controller.totalPages - 1;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(controller.totalPages, (i) {
                        final active = i == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: 10,
                          width: active ? 26 : 10,
                          decoration: BoxDecoration(
                            color: active ? AppColors.primary : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          // Smooth width + appearance animation for back button
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeInOutCubic,
                            width: index > 0 ? 54 : 0,
                            height: 54,
                            margin: EdgeInsets.only(right: index > 0 ? 12 : 0),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 220),
                              opacity: index > 0 ? 1 : 0,
                              curve: Curves.easeInOut,
                              child: index > 0
                                  ? ElevatedButton(
                                      onPressed: controller.prevPage,
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Colors.grey.shade200,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_back_rounded,
                                        color: AppColors.textDark,
                                        size: 28,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: controller.nextPage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: PageTransitionSwitcher(
                                  duration: const Duration(milliseconds: 520),
                                  reverse: !isLast, // arah animasi: masuk ke final -> maju
                                  transitionBuilder: (child, primary, secondary) {
                                    return SharedAxisTransition(
                                      animation: primary,
                                      secondaryAnimation: secondary,
                                      transitionType: SharedAxisTransitionType.scaled,
                                      fillColor: Colors.transparent,
                                      child: child,
                                    );
                                  },
                                  child: Text(
                                    isLast ? 'Mulai Sekarang' : 'Lanjut',
                                    key: ValueKey(isLast),
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      height: 1.25,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
