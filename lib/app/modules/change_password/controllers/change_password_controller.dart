import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/services/api_services.dart';
import '../../../routes/app_pages.dart';

class ChangePasswordController extends GetxController {
  final ApiService apiService = ApiService();
  final GetStorage box = GetStorage();

  final formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isObscureCurrent = true.obs;
  final isObscureNew = true.obs;
  final isObscureConfirm = true.obs;
  final isSubmitting = false.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleCurrentVisibility() => isObscureCurrent.toggle();
  void toggleNewVisibility() => isObscureNew.toggle();
  void toggleConfirmVisibility() => isObscureConfirm.toggle();

  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      Get.snackbar('Peringatan', 'Masukkan password saat ini');
      return '';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      Get.snackbar('Peringatan', 'Masukkan password baru');
      return '';
    }
    if (value.length < 8) {
      Get.snackbar('Peringatan', 'Password minimal 8 karakter');
      return '';
    }
    if (value == currentPasswordController.text) {
      Get.snackbar('Peringatan', 'Password baru tidak boleh sama');
      return '';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      Get.snackbar('Peringatan', 'Konfirmasi password baru');
      return '';
    }
    if (value != newPasswordController.text) {
      Get.snackbar('Peringatan', 'Konfirmasi password tidak sama');
      return '';
    }
    return null;
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      isSubmitting(true);

      final response = await apiService.changePassword({
        'current_password': currentPasswordController.text,
        'new_password': newPasswordController.text,
        'confirm_password': confirmPasswordController.text,
      });

      if (response.statusCode == 200) {
        Get.snackbar(
          'Berhasil',
          response.body['message'] ?? 'Password berhasil diubah',
        );
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        formKey.currentState?.reset();
        await box.remove('token');
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar(
          'Error',
          response.body['message'] ?? 'Gagal mengubah password',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan. Coba lagi nanti.');
    } finally {
      isSubmitting(false);
    }
  }
}
