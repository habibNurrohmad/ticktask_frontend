import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ticktask_frontend/app/core/values/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildGreen,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Calendar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Rothek',
                  fontSize: 32,
                  fontWeight: FontWeight.w900, // Rothek Black
                  color: AppColors.lightCream,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                return TableCalendar(
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: controller.focusedDay.value,
                  selectedDayPredicate: (day) =>
                      isSameDay(controller.selectedDay.value, day),
                  onDaySelected: controller.onDaySelected,
                  calendarFormat: controller.calendarFormat.value,
                  onFormatChanged: (format) =>
                      controller.calendarFormat.value = format,
                  onPageChanged: (focused) =>
                      controller.focusedDay.value = focused,
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: true,
                    leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
                    rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    titleTextStyle: const TextStyle(
                      fontFamily: 'Rothek',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    formatButtonTextStyle: const TextStyle(
                      fontFamily: 'Rothek',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      fontFamily: 'Rothek',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    weekendStyle: TextStyle(
                      fontFamily: 'Rothek',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  calendarStyle: const CalendarStyle(
                    defaultTextStyle: TextStyle(
                      fontFamily: 'Rothek',
                      color: Colors.white,
                    ),
                    weekendTextStyle: TextStyle(
                      fontFamily: 'Rothek',
                      color: Colors.white,
                    ),
                    outsideTextStyle: TextStyle(
                      fontFamily: 'Rothek',
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                    disabledTextStyle: TextStyle(
                      fontFamily: 'Rothek',
                      color: Colors.white,
                    ),
                    todayTextStyle: TextStyle(
                      fontFamily: 'Rothek',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    selectedTextStyle: TextStyle(
                      fontFamily: 'Rothek',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
