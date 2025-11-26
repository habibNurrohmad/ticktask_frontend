import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ticktask_frontend/app/core/values/app_colors.dart';

import '../controllers/history_controller.dart';

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

              // Search pill
              Row(
                children: [
                  Expanded(
                    child: Container(
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
                      child: const Text(
                        'Search By Kerwords',
                        style: TextStyle(
                          fontFamily: 'Rothek',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Filters row
              Row(
                children: [
                  _filterChip('Tahun'),
                  const SizedBox(width: 12),
                  _filterChip('Bulan'),
                ],
              ),

              const SizedBox(height: 16),

              // List of cards
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: _sampleTasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _historyCard(_sampleTasks[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Simple sample data for history list
final List<_HistoryItem> _sampleTasks = [
  _HistoryItem(
    title: 'Rapat Lanik 2',
    dateLabel: '01 Oktober 2025',
    timeLabel: '20.20 WIB',
    status: HistoryStatus.done,
  ),
  _HistoryItem(
    title: 'Rapat Studi Ekskursi',
    dateLabel: '01 Oktober 2025',
    timeLabel: '20.20 WIB',
    status: HistoryStatus.late,
  ),
  _HistoryItem(
    title: 'Rapat Lanik 2',
    dateLabel: '01 Oktober 2025',
    timeLabel: '20.20 WIB',
    status: HistoryStatus.done,
  ),
  _HistoryItem(
    title: 'Rapat Studi Ekskursi',
    dateLabel: '01 Oktober 2025',
    timeLabel: '20.20 WIB',
    status: HistoryStatus.late,
  ),
  _HistoryItem(
    title: 'Rapat Lanik 2',
    dateLabel: '01 Oktober 2025',
    timeLabel: '20.20 WIB',
    status: HistoryStatus.done,
  ),
];

enum HistoryStatus { done, late }

class _HistoryItem {
  final String title;
  final String dateLabel;
  final String timeLabel;
  final HistoryStatus status;

  _HistoryItem({
    required this.title,
    required this.dateLabel,
    required this.timeLabel,
    required this.status,
  });
}


Widget _filterChip(String label) {
  return Container(
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
  );
}

Widget _historyCard(_HistoryItem item) {
  final statusText = item.status == HistoryStatus.done ? 'Selesai' : 'Terlambat';
  final statusColor = item.status == HistoryStatus.done ? const Color(0xFF3CB371) : const Color(0xFFD14A4A);

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
                    item.dateLabel,
                    style: TextStyle(
                      fontFamily: 'Rothek',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(
                    item.timeLabel,
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
          child: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
        ),
      ],
    ),
  );
}
