import 'package:get/get.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController

  final count = 0.obs;
  final obscurePassword = true.obs;
  final obscureUsername = true.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  void togglePassword() => obscurePassword.value = !obscurePassword.value;
  void toggleUsername() => obscureUsername.value = !obscureUsername.value;
}
