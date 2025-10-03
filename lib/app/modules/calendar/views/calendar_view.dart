import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ticktask_frontend/app/core/values/app_colors.dart';

import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildGreen,
      body: const Center(
        child: Text(
          'CalendarView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
