import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController

  final count = 0.obs;
  final Rxn<ImageProvider> avatarImageProvider = Rxn<ImageProvider>();
  final ImagePicker _picker = ImagePicker();

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
        // TODO: upload/simpan ke backend sesuai kebutuhan
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak bisa memilih foto: $e');
    }
  }

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
}
