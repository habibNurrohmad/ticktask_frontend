import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticktask_frontend/app/core/values/app_colors.dart';
import '../controllers/history_controller.dart';
import '../model/history_model.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildYellow,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'History',
                  style: TextStyle(
                    fontFamily: 'Rothek',
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Search Bar
              _searchBar(),

              const SizedBox(height: 14),

              // Filters Row
              Row(
                children: [
                  _filterChip('Tahun', () => controller.setYear(2025)),
                  const SizedBox(width: 12),
                  _filterChip('Bulan', () => controller.setMonth(11)),
                ],
              ),

              const SizedBox(height: 16),

              // LIST DINAMIS
              Expanded(
                child: Obx(() {
                  final list = controller.filtered;

                  if (list.isEmpty) {
                    return const Center(
                      child: Text(
                        "Belum ada history",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _historyCard(list[index]);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------
  // SEARCH BAR
  // ----------------------
  Widget _searchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.lightCream,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: TextField(
        onChanged: controller.setKeyword,
        style: const TextStyle(fontFamily: 'Rothek', color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Search By Keywords',
          hintStyle: TextStyle(fontFamily: 'Rothek', color: Colors.black54),
        ),
      ),
    );
  }

  // ----------------------
  // FILTER CHIP
  // ----------------------
  Widget _filterChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightCream,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Rothek',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }

  // ----------------------
  // HISTORY CARD (DINAMIS)
  // ----------------------
  Widget _historyCard(HistoryModel item) {
    final isLate = item.isLate;
    final isFinished = item.isFinished;

    final statusText =
        isFinished ? "Selesai" : (isLate ? "Terlambat" : "Belum Selesai");
    final statusColor =
        isFinished
            ? const Color(0xFF3CB371)
            : (isLate ? const Color(0xFFD14A4A) : Colors.grey);

    final dateLabel =
        item.deadline != null
            ? "${item.deadline!.day}-${item.deadline!.month}-${item.deadline!.year}"
            : "-";

    final timeLabel =
        item.deadline != null
            ? "${item.deadline!.hour}:${item.deadline!.minute.toString().padLeft(2, '0')}"
            : "";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightCream,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
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
                      dateLabel,
                      style: TextStyle(
                        fontFamily: 'Rothek',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeLabel,
                      style: TextStyle(
                        fontFamily: 'Rothek',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '|',
                      style: TextStyle(color: Colors.black.withOpacity(0.4)),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontFamily: 'Rothek',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
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
        ],
      ),
    );
  }
}
