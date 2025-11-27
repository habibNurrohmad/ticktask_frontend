import 'package:get/get.dart';
import '../../../core/services/api_services.dart';
import '../model/history_detail_model.dart';

class HistoryDetailController extends GetxController {
  final api = ApiService();

  var isLoading = false.obs;
  var detail = Rx<HistoryDetailModel?>(null);

  Future<void> fetchDetail(int id) async {
    try {
      isLoading.value = true;

      final res = await api.getTaskHistoryDetail(id);

      if (res.statusCode == 200 &&
          res.body is Map &&
          res.body['status'] == true) {
        if (res.body['data'] != null) {
          detail.value = HistoryDetailModel.fromJson(res.body['data']);
        } else {
          Get.snackbar("Error", "Data tidak ditemukan");
        }
      } else {
        Get.snackbar("Error", "Gagal mengambil detail data");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    final id = Get.arguments;
    fetchDetail(id);
    super.onInit();
  }
}
