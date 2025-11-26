import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/services/api_services.dart';

class RegisterController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  final obscurePassword = true.obs;
  final api = ApiService();

  void toggleObscure() => obscurePassword.value = !obscurePassword.value;

  Future<void> register() async {
    final name = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Semua field wajib diisi");
      return;
    }

    final body = {"name": name, "email": email, "password": password};

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await api.register(body);

      Get.back(); // tutup loading

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;

        Get.snackbar(
          "Berhasil",
          data["message"] ?? "Register berhasil",
          snackPosition: SnackPosition.TOP,
        );

        debugPrint("User created: ${data['user']}");
      } else {
        Get.snackbar(
          "Gagal",
          response.body['message'] ?? "Terjadi kesalahan",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Tidak dapat menghubungi server");
      debugPrint("Register error: $e");
    }
  }
}
