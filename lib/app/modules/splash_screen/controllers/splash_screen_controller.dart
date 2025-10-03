import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // Navigate to Landing Page after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(Routes.LANDING_PAGE);
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
