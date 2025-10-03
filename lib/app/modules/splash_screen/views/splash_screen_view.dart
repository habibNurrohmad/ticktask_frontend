import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ticktask_frontend/app/core/values/app_colors.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    // Ensure the controller is instantiated so onReady() can run
    // (lazyPut only creates it on first access)
    final _ = controller;
    return Scaffold(
      backgroundColor: AppColors.sunflowerYellow,
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'LET’S\nCONNECT WITH',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rothek',
                fontWeight: FontWeight.w600,
                fontSize: 10,
                color: AppColors.textDark,
                letterSpacing: 3,
              ),
            ),
            SizedBox(height: 100),
            Text(
              'TickTask',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rothek',
                fontWeight: FontWeight.w900,
                fontSize: 64,
                color: AppColors.textDark,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 100),
            Text(
              'THANK YOU\nFOR YOUR TRUST!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rothek',
                fontWeight: FontWeight.w600,
                fontSize: 10,
                color: AppColors.textDark,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
