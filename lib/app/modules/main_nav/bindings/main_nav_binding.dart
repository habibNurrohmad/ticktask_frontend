import 'package:get/get.dart';

import '../../calendar/controllers/calendar_controller.dart';
import '../../history/controllers/history_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/main_nav_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    // Controller untuk navigasi utama
    Get.lazyPut<MainNavController>(() => MainNavController());

    // Pastikan controller halaman tersedia ketika MainNav digunakan
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CalendarController>(() => CalendarController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
