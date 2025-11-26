import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/api_services.dart';
import '../model/user_model.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final api = ApiService(); // <<— tambah ini
  final box = GetStorage();
  final count = 0.obs;
  final Rxn<ImageProvider> avatarImageProvider = Rxn<ImageProvider>();
  final ImagePicker _picker = ImagePicker();

  final user = UserModel().obs;
  final isLoading = false.obs;

  //   LOAD AVATAR
  Future<void> pickAvatarFromCamera() => _pickAvatar(ImageSource.camera);
  Future<void> pickAvatarFromGallery() => _pickAvatar(ImageSource.gallery);

  Future<void> _pickAvatar(ImageSource source) async {
    try {
      final XFile? x = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (x != null) {
        avatarImageProvider.value = FileImage(File(x.path));
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak bisa memilih foto: $e');
    }
  }

  //   FETCH USER PROFILE
  @override
  void onReady() {
    super.onReady();
    fetchUser(); // API akan berjalan setiap buka halaman
  }

  Future<void> fetchUser() async {
    try {
      isLoading(true);

      final response = await api.getUser();

      Get.log("PROFILE RESPONSE -> ${response.body}");

      if (response.statusCode == 200) {
        user.value = UserModel.fromJson(response.body['user']);
      } else {
        Get.snackbar("Error", response.body["message"] ?? "Gagal memuat data");
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat memuat data profil");
    } finally {
      isLoading(false);
    }
  }

  //           LOGOUT
  Future<void> logout() async {
    try {
      box.remove("token"); // ← INI YANG BENER

      user.value = UserModel(); // kosongkan data user

      Get.offAllNamed('/login');
      Get.snackbar("Logout", "Berhasil keluar");
    } catch (e) {
      Get.snackbar("Error", "Gagal logout");
    }
  }

  void increment() => count.value++;
}
