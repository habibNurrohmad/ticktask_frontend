import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/services/api_services.dart';
import '../model/calender_model.dart';

class CalendarController extends GetxController {
  final isLoading = false.obs;
  final api = ApiService();

  // Semua task dari API
  var tasks = <CalendarTask>[].obs;

  // Task sesuai tanggal terpilih
  var filteredTasks = <CalendarTask>[].obs;

  // Calendar states
  final focusedDay = DateTime.now().obs;
  final selectedDay = Rx<DateTime?>(DateTime.now());
  final calendarFormat = CalendarFormat.month.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  // ----------------------------------------------------------
  // FETCH ALL TASKS
  // ----------------------------------------------------------
  Future<void> fetchTasks() async {
    try {
      final res = await api.getTasks();

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.body}");

      final rawData = res.body['data'];

      if (rawData is List) {
        tasks.value = rawData.map((e) => CalendarTask.fromJson(e)).toList();
        filterBySelectedDay();
      } else {
        print("rawData is not a List: ${rawData.runtimeType}");
        tasks.clear();
      }
    } catch (e) {
      print("Error fetch tasks: $e");
    }
  }

  // ----------------------------------------------------------
  // SELECT DAY
  // ----------------------------------------------------------
  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;

    filterBySelectedDay();
  }

  // ----------------------------------------------------------
  // FILTER TASKS BY SELECTED DATE
  // ----------------------------------------------------------
  void filterBySelectedDay() {
    if (selectedDay.value == null) return;

    final day = selectedDay.value!;

    filteredTasks.value =
        tasks.where((task) {
          if (task.deadline == null) return false;

          final d = task.deadline!;

          return d.year == day.year && d.month == day.month && d.day == day.day;
        }).toList();
  }
}
