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
            const SizedBox(height: 12),
            const Divider(color: Colors.white70, height: 1, thickness: 1),
            const SizedBox(height: 8),

            // Daftar kartu — pakai Stack + overlay gradient seperti di HomeView
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Stack(
                  children: [
                    // List card
                    ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 205),
                      itemCount: _sampleTasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _taskCard(_sampleTasks[index]),
                    ),
                    // Overlay gradient hitam dari bawah (0% -> 100%)
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
                              colors: [
                                Color(0x00000000), // 0% hitam (transparan)
                                Color(0xAA000000),
                              ],
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

// Sample data dan helper di-level top agar konstruktor `CalendarView` bisa `const`
final List<_TaskCardData> _sampleTasks = [
  _TaskCardData(
    title: 'Rapat Lanik 2',
    start: DateTime(2025, 12, 30),
    end: DateTime(2026, 1, 31),
    timeRange: '19.00 – 23.00',
    isPriority: true,
    isDone: true,
  ),
  _TaskCardData(
    title: 'Kuliah PBO',
    start: DateTime(2025, 10, 10),
    end: DateTime(2025, 10, 10),
    timeRange: '08.00 – 10.00',
    isPriority: false,
    isDone: false,
  ),
  _TaskCardData(
    title: 'UTS Basis Data',
    start: DateTime(2025, 11, 5),
    end: DateTime(2025, 11, 5),
    timeRange: '09.00 – 11.00',
    isPriority: true,
    isDone: false,
  ),
  _TaskCardData(
    title: 'Proyek Kelompok',
    start: DateTime(2026, 3, 1),
    end: DateTime(2026, 6, 30),
    timeRange: 'Flexible',
    isPriority: false,
    isDone: false,
  ),
  _TaskCardData(
    title: 'Seminar Teknologi',
    start: DateTime(2027, 2, 15),
    end: DateTime(2027, 2, 15),
    timeRange: '13.00 – 16.00',
    isPriority: true,
    isDone: false,
  ),
];



Widget _taskCard(_TaskCardData data) {
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
                data.title,
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
                    '${data.timeRange} WIB',
                    style: TextStyle(
                      fontFamily: 'Rothek',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 1,
                    height: 16,
                    color: Colors.black.withOpacity(0.12),
                  ),
                  const SizedBox(width: 12),
                  if (data.isPriority)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD14A4A),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  if (data.isDone)
                    Text(
                      'Selesai',
                      style: TextStyle(
                        fontFamily: 'Rothek',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3CB371),
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
            child: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
          ),
        ),
      ],
    ),
  );
}

// Model data sederhana untuk kartu
class _TaskCardData {
  final String title;
  final DateTime start;
  final DateTime end;
  final String timeRange;
  final bool isPriority;
  final bool isDone;

  _TaskCardData({
    required this.title,
    required this.start,
    required this.end,
    required this.timeRange,
    required this.isPriority,
    required this.isDone,
  });
}
