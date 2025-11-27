import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticktask_frontend/app/core/values/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/calendar_controller.dart';
import '../model/calender_model.dart';

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
                  fontWeight: FontWeight.w900,
                  color: AppColors.lightCream,
                ),
              ),
            ),

            // Calendar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                return TableCalendar(
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: controller.focusedDay.value,
                  selectedDayPredicate:
                      (day) => isSameDay(controller.selectedDay.value, day),
                  onDaySelected: controller.onDaySelected,
                  calendarFormat: controller.calendarFormat.value,
                  onFormatChanged:
                      (format) => controller.calendarFormat.value = format,
                  onPageChanged:
                      (focused) => controller.focusedDay.value = focused,

                  // ===============================
                  //          🔥 TEXT PUTIH
                  // ===============================
                  headerStyle: const HeaderStyle(
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rothek',
                    ),
                    formatButtonTextStyle: TextStyle(color: Colors.white),
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),

                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.white),
                    weekendStyle: TextStyle(color: Colors.white),
                  ),

                  calendarStyle: const CalendarStyle(
                    defaultTextStyle: TextStyle(color: Colors.white),
                    weekendTextStyle: TextStyle(color: Colors.white),
                    holidayTextStyle: TextStyle(color: Colors.white),

                    todayTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),

                    selectedTextStyle: TextStyle(color: Colors.black),
                    selectedDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 12),
            const Divider(color: Colors.white70, height: 1, thickness: 1),
            const SizedBox(height: 8),

            // TASK LIST
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Stack(
                  children: [
                    Obx(() {
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 205),

                        // 🔥 tampilkan ALL tasks
                        itemCount: controller.tasks.length,

                        separatorBuilder: (_, __) => const SizedBox(height: 12),

                        itemBuilder: (context, index) {
                          final data = controller.tasks[index];
                          return _taskCard(data);
                        },
                      );
                    }),

                    // Overlay gradient dari bawah
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 200,
                      child: IgnorePointer(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x00000000), Color(0xAA000000)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔥 CARD DARI API
Widget _taskCard(CalendarTask data) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.lightCream,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.07),
          offset: const Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    ),
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title ?? "-",
                style: const TextStyle(
                  fontFamily: 'Rothek',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    data.deadline != null ? "${data.deadline}" : "—",
                    style: TextStyle(
                      fontFamily: 'Rothek',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Container(width: 1, height: 16, color: Colors.black12),
                  const SizedBox(width: 12),

                  if (data.isPriority == 1)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD14A4A),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: const Text(
                        'Prioritas',
                        style: TextStyle(
                          fontFamily: 'Rothek',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  const SizedBox(width: 8),

                  if (data.isDone == 1)
                    const Text(
                      'Selesai',
                      style: TextStyle(
                        fontFamily: 'Rothek',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3CB371),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {},
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}
