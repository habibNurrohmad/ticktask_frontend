import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavController extends GetxController {
  // Index untuk NavigationBar (0: Home, 1: Calendar, 2: History, 3: Profile)
  final RxInt currentIndex = 0.obs;
  late final PageController pageController;

  @override
  void onInit() {
    pageController = PageController(initialPage: currentIndex.value);
    super.onInit();
  }

  void onTabSelected(int index) {
    currentIndex.value = index;
    // Animasi geser antar halaman
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
