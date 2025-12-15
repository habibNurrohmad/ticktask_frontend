import 'package:flutter/material.dart';
import 'dart:math';
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                children: [
                  _searchBar(),

                  const SizedBox(height: 14),

                  // Filters Row
                  Row(
                    children: [
                      _yearFilterChip(context),
                      const SizedBox(width: 12),
                      _monthFilterChip(context),
                    ],
                  ),
                ],
              ),
            ),

            // LIST DINAMIS
            Expanded(
              child: Stack(
                children: [
                  Obx(() {
                    final list = controller.filtered;
              
                    if (list.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 125),
                        child: const Center(
                          child: Text(
                            "Belum ada history",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
              
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 125),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _historyCard(list[index]);
                      },
                    );
                  }),
              
                  // Overlay gradient dari bawah
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 120,
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
          ],
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

  // (Removed unused generic filter chip helper)

  Widget _yearFilterChip(BuildContext context) {
    return Obx(() {
      final year = controller.selectedYear.value;
      final label = year != null ? 'Tahun: $year' : 'Tahun';

      return GestureDetector(
        onTap: () => _showYearPicker(context),
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
    });
  }

  void _showYearPicker(BuildContext context) {
    final data = controller.allData.where(
      (e) =>
          e.deadline != null &&
          (controller.selectedMonth.value == null ||
              e.deadline!.month == controller.selectedMonth.value),
    );

    final years = data.map((e) => e.deadline!.year).toSet().toList();

    years.sort((a, b) => b.compareTo(a));

    if (years.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada data task untuk memilih tahun'),
        ),
      );
      return;
    }

    final itemCount = years.length;
    final tileHeight = 56.0;
    final headerHeight = 72.0;
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    final sheetHeight = min(maxHeight, headerHeight + itemCount * tileHeight);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: sheetHeight + 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pilih Tahun',
                        style: TextStyle(
                          fontFamily: 'Rothek',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.setYear(null);
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Semua'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: years.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final y = years[index];
                      return ListTile(
                        title: Text(
                          y.toString(),
                          style: const TextStyle(fontFamily: 'Rothek'),
                        ),
                        onTap: () {
                          controller.setYear(y);
                          Navigator.of(ctx).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _monthFilterChip(BuildContext context) {
    return Obx(() {
      final m = controller.selectedMonth.value;
      final monthNames = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];

      final label = m != null ? 'Bulan: ${monthNames[m]}' : 'Bulan';

      return GestureDetector(
        onTap: () => _showMonthPicker(context),
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
    });
  }

  void _showMonthPicker(BuildContext context) {
    final monthNames = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final data = controller.allData.where(
      (e) =>
          e.deadline != null &&
          (controller.selectedYear.value == null ||
              e.deadline!.year == controller.selectedYear.value),
    );

    final months = data.map((e) => e.deadline!.month).toSet().toList();
    months.sort((a, b) => b.compareTo(a));

    if (months.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada data task untuk memilih bulan'),
        ),
      );
      return;
    }

    final itemCount = months.length;
    final tileHeight = 56.0;
    final headerHeight = 72.0;
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    final sheetHeight = min(maxHeight, headerHeight + itemCount * tileHeight);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: sheetHeight + 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pilih Bulan',
                        style: TextStyle(
                          fontFamily: 'Rothek',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.setMonth(null);
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Semua'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: months.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final m = months[index];
                      return ListTile(
                        title: Text(
                          monthNames[m],
                          style: const TextStyle(fontFamily: 'Rothek'),
                        ),
                        onTap: () {
                          controller.setMonth(m);
                          Navigator.of(ctx).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

    return GestureDetector(
      onTap: () => Get.toNamed('/history-detail', arguments: item.id),
      child: Container(
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
      ),
    );
  }
}
