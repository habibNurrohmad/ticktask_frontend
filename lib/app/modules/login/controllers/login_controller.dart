import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/services/api_services.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();

  final hide = true.obs;
  final remember = false.obs;

  final api = ApiService();
  final box = GetStorage();

  void togglePassword() {
    hide.value = !hide.value;
  }

  Future<void> login() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      Get.snackbar("Error", "Email & password wajib diisi");
      return;
    }

    final body = {"email": email.text.trim(), "password": password.text};

    final res = await api.login(body);

    if (res.statusCode == 200) {
      final token = res.body["token"];

      if (token == null) {
        Get.snackbar("Error", "Token tidak ditemukan dari server");
        return;
      }

      box.write("token", token);

      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar("Login Gagal", res.body["message"] ?? "Terjadi kesalahan");
    }
  }
}
