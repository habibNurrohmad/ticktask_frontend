import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  //TODO: Implement CalendarController

  final count = 0.obs;
  final focusedDay = DateTime.now().obs;
  final selectedDay = Rxn<DateTime>();
  final calendarFormat = CalendarFormat.month.obs;

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

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
  }
}
