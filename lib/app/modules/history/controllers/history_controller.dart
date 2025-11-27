import 'package:get/get.dart';
import '../../../core/services/api_services.dart';
import '../model/history_model.dart';

class HistoryController extends GetxController {
  final api = ApiService();

  var allData = <HistoryModel>[].obs;
  var filtered = <HistoryModel>[].obs;

  var selectedYear = Rx<int?>(null);
  var selectedMonth = Rx<int?>(null);
  var keyword = "".obs;

  @override
  void onReady() {
    super.onReady();
    fetchHistory();
  }

  // -------------------------------
  // FETCH HISTORY
  // -------------------------------
  Future<void> fetchHistory() async {
    try {
      final res = await api.getTaskHistory(); // <-- sudah diperbaiki

      if (res.statusCode == 200 && res.body['status'] == true) {
        final List data = res.body['data'];
        allData.value = data.map((e) => HistoryModel.fromJson(e)).toList();

        applyFilter();
      } else {
        print("History Error => ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("History Exception => $e");
    }
  }

  // -------------------------------
  // FILTERING
  // -------------------------------
  void applyFilter() {
    var temp = allData.toList();

    // Keyword filter
    if (keyword.value.isNotEmpty) {
      temp =
          temp.where((e) {
            final k = keyword.value.toLowerCase();
            return e.title.toLowerCase().contains(k) ||
                e.description.toLowerCase().contains(k);
          }).toList();
    }

    // Year filter
    if (selectedYear.value != null) {
      temp =
          temp.where((e) {
            return e.deadline != null && e.deadline!.year == selectedYear.value;
          }).toList();
    }

    // Month filter
    if (selectedMonth.value != null) {
      temp =
          temp.where((e) {
            return e.deadline != null &&
                e.deadline!.month == selectedMonth.value;
          }).toList();
    }

    filtered.value = temp;
  }

  // -------------------------------
  // SETTERS
  // -------------------------------
  void setYear(int? year) {
    selectedYear.value = year;
    applyFilter();
  }

  void setMonth(int? month) {
    selectedMonth.value = month;
    applyFilter();
  }

  void setKeyword(String text) {
    keyword.value = text;
    applyFilter();
  }
}
