import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
    // Check stored token and navigate accordingly
    final box = GetStorage();
    final token = box.read('token');
    final seenLanding = box.read('seenLanding') ?? false;

    if (token != null && token.toString().isNotEmpty) {
      // If token exists, go straight to Home
      Future.delayed(const Duration(milliseconds: 800), () {
        Get.offAllNamed(Routes.HOME);
      });
    } else {
      // Jika user sudah pernah melihat landing, langsung ke Login,
      // jika belum, tampilkan Landing Page.
      Future.delayed(const Duration(seconds: 2), () {
        if (seenLanding == true) {
          Get.offAllNamed(Routes.LOGIN);
        } else {
          Get.offAllNamed(Routes.LANDING_PAGE);
        }
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
