import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Text controllers for inputs
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // UI state
  final obscurePassword = true.obs;
  final rememberMe = false.obs;

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
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void toggleObscure() => obscurePassword.value = !obscurePassword.value;

  void toggleRememberMe() => rememberMe.value = !rememberMe.value;

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text;
    // TODO: replace with real authentication logic
    debugPrint('Login pressed — username: $username, password: ${password.isNotEmpty ? '●●●●' : '(empty)'}');
  }
}
