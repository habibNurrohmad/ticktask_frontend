import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/history_detail_controller.dart';

class HistoryDetailView extends GetView<HistoryDetailController> {
  const HistoryDetailView({super.key});

  String formatDate(String? date) {
    if (date == null) return "-";
    try {
      final d = DateTime.parse(date);
      return DateFormat("d MMMM yyyy, HH:mm", "id_ID").format(d);
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildYellow,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 30),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: AppBar(
            backgroundColor: AppColors.mildYellow,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 22,
              ),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              "History Detail",
              style: TextStyle(
                fontFamily: 'Rhotek', // Font Rhotek
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700, // semi-bold
                letterSpacing: 0.3,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Obx(() {
        final data = controller.detail.value;

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (data == null) {
          return const Center(
            child: Text(
              "Data tidak ditemukan",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            10,
            12,
            10,
            24,
          ), // **padding kecil**
          child: Container(
            width: double.infinity, // **biar full width**
            padding: const EdgeInsets.all(
              15,
            ), // **padding kontainer lebih kecil**
            decoration: BoxDecoration(
              color: AppColors.lightCream,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                Text(
                  data.title,
                  style: const TextStyle(
                    fontFamily: 'Rothek',
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 16),

                // STATUS LABEL
                _statusTag(data.isDone == 1),

                const SizedBox(height: 20),

                // DESCRIPTION
                _label("Deskripsi"),
                _value(data.description ?? "-"),

                const SizedBox(height: 16),

                _label("Deadline"),
                _value(formatDate(data.deadline)),

                const SizedBox(height: 16),

                _label("Tipe"),
                _value(data.type),

                const SizedBox(height: 16),

                _label("Prioritas"),
                _value(data.isPriority == 1 ? "Tinggi" : "Normal"),

                const SizedBox(height: 16),

                _label("Dibuat"),
                _value(formatDate(data.createdAt)),
              ],
            ),
          ),
        );
      }),
    );
  }

  // LABEL
  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Rothek',
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.black.withOpacity(0.6),
      ),
    );
  }

  // VALUE
  Widget _value(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Rothek',
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
    );
  }

  // STATUS TAG
  Widget _statusTag(bool isFinished) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isFinished ? const Color(0xFF3CB371) : const Color(0xFFD14A4A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isFinished ? "SELESAI" : "BELUM SELESAI",
        style: const TextStyle(
          fontFamily: 'Rothek',
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}
