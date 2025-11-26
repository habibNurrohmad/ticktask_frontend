import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // tambahkan untuk CupertinoPageRoute

import 'package:get/get.dart';
import 'package:ticktask_frontend/app/core/values/app_colors.dart';
import 'package:ticktask_frontend/app/modules/about/views/about_view.dart';
import 'package:ticktask_frontend/app/modules/change_password/views/change_password_view.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  void _showPhotoSourcePicker(BuildContext context) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil foto (Kamera)'),
                onTap: () {
                  Get.back();
                  controller.pickAvatarFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Get.back();
                  controller.pickAvatarFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildPink,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // Title at top center
            const Center(
              child: Text(
                'My Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Rothek',
                  fontSize: 32,
                  fontWeight: FontWeight.w900, // Rothek Black
                  color: AppColors.lightCream,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Avatar + tombol kamera
            Center(
              child: SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Ring luar
                    Obx(
                      () => Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: AppColors.darkPink,
                          child: CircleAvatar(
                            radius: 76,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                controller.avatarImageProvider.value,
                            child:
                                controller.avatarImageProvider.value == null
                                    ? const Icon(
                                      Icons.person,
                                      size: 72,
                                      color: AppColors.mildPink,
                                    )
                                    : null,
                          ),
                        ),
                      ),
                    ),
                    // Tombol kamera
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () => _showPhotoSourcePicker(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.lightCream,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.darkPink,
                              width: 2,
                            ), // outline hitam
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: AppColors.darkPink,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Obx(
                    () => Text(
                      controller.user.value.name ?? "Tidak ada nama",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Rothek',
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  Obx(
                    () => Text(
                      controller.user.value.email ?? "Tidak ada email",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Rothek',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Dua container yang bersusun dengan icon di kiri dan panah di kanan
            Center(
              child: Column(
                children: [
                  Material(
                    color: AppColors.lightCream,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.of(
                          context,
                        ).push(CupertinoPageRoute(builder: (_) => AboutView()));
                      },
                      child: const SizedBox(
                        width: 300,
                        height: 60,
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            Icon(
                              Icons.info_outline,
                              color: Colors.black,
                              size: 28,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'About',
                                style: TextStyle(
                                  fontFamily: 'Rothek',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black,
                              size: 22,
                            ),
                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Material(
                    color: AppColors.lightCream,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => ChangePasswordView(),
                          ),
                        );
                      },
                      child: const SizedBox(
                        width: 300,
                        height: 60,
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            Icon(
                              Icons.lock_outline,
                              color: Colors.black,
                              size: 28,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Change Password',
                                style: TextStyle(
                                  fontFamily: 'Rothek',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black,
                              size: 22,
                            ),
                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton(
                      // onPressed: () => controller.logout(),
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: 'Rothek',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
