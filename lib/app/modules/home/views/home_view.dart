import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // <-- tambah impor ini

import 'package:get/get.dart';
import 'package:ticktask_frontend/app/core/values/app_colors.dart';
import 'package:ticktask_frontend/app/modules/notification/views/notification_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  // Selector state (local reactive)
  final Rxn<int> _selectedYear = Rxn<int>(); // null = Semua Tahun
  final Rxn<int> _selectedMonth = Rxn<int>(); // 1..12, null = Semua Bulan

  static const List<int> _years = [2025, 2026, 2027];
  static const List<String> _monthNames = [
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

  // Sample data untuk daftar kartu
  final List<_TaskCardData> _sampleTasks = [
    _TaskCardData(
      title: 'Rapat Lanik 2',
      start: DateTime(2025, 12, 30),
      end: DateTime(2026, 1, 31),
      timeRange: '19.00 – 23.00',
      isPriority: true,
    ),
    _TaskCardData(
      title: 'Kuliah PBO',
      start: DateTime(2025, 10, 10),
      end: DateTime(2025, 10, 10),
      timeRange: '08.00 – 10.00',
      isPriority: false,
    ),
    _TaskCardData(
      title: 'UTS Basis Data',
      start: DateTime(2025, 11, 5),
      end: DateTime(2025, 11, 5),
      timeRange: '09.00 – 11.00',
      isPriority: true,
    ),
    _TaskCardData(
      title: 'Proyek Kelompok',
      start: DateTime(2026, 3, 1),
      end: DateTime(2026, 6, 30),
      timeRange: 'Flexible',
      isPriority: false,
    ),
    _TaskCardData(
      title: 'Seminar Teknologi',
      start: DateTime(2027, 2, 15),
      end: DateTime(2027, 2, 15),
      timeRange: '13.00 – 16.00',
      isPriority: true,
    ),
  ];

  String get _yearLabel => _selectedYear.value?.toString() ?? 'Semua Tahun';
  String get _monthLabel =>
      _selectedMonth.value != null
          ? _monthNames[_selectedMonth.value! - 1]
          : 'Semua Bulan';

  // Format rentang tanggal seperti contoh: "30 Desember 2025 – 31 Januari 2026"
  String _formatDateRange(DateTime start, DateTime end) {
    String fmt(DateTime d) => '${d.day} ${_monthNames[d.month - 1]} ${d.year}';
    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return fmt(start);
    }
    return '${fmt(start)} – ${fmt(end)}';
  }

  // Cek apakah task cocok dengan filter Tahun/Bulan yang dipilih
  bool _taskMatchesSelection(_TaskCardData t, int? year, int? month) {
    final start = t.start;
    final end = t.end;

    if (year == null && month == null) return true;

    // Jika hanya tahun
    if (year != null && month == null) {
      return !(end.year < year || start.year > year);
    }

    // Jika tahun dan bulan
    if (year != null && month != null) {
      final monthStart = DateTime(year, month, 1);
      final monthEnd = DateTime(year, month + 1, 0); // hari terakhir bulan tsb
      return end.isAfter(monthStart.subtract(const Duration(days: 1))) &&
          start.isBefore(monthEnd.add(const Duration(days: 1)));
    }

    // Jika hanya bulan (tanpa tahun) -> cocokkan jika start/end jatuh pada bulan tsb
    if (year == null && month != null) {
      return start.month == month || end.month == month;
    }

    return true;
  }

  // Widget kartu sesuai contoh
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    fontFamily: 'Rothek',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // TODO: aksi menu
                },
                child: const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.more_horiz, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _formatDateRange(data.start, data.end),
            style: TextStyle(
              fontFamily: 'Rothek',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Waktu pill
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  'Waktu: ${data.timeRange}',
                  style: const TextStyle(
                    fontFamily: 'Rothek',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              if (data.isPriority)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD14A4A),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
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
            ],
          ),
        ],
      ),
    );
  }

  // Tombol filter reusable (aktif/non-aktif)
  Widget _filterButton({required String label, required TaskFilter value}) {
    final isSelected = controller.selectedFilter.value == value;
    return GestureDetector(
      onTap: () => controller.setFilter(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        alignment: Alignment.center, // center content
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBlue : AppColors.skyBlue,
          borderRadius: BorderRadius.circular(10),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 5,
                      spreadRadius: 0,
                    ),
                  ]
                  : [],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          textAlign: TextAlign.center, // center text
          style: TextStyle(
            fontFamily: 'Rothek',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _selectorButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightCream,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.black),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Rothek',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom sheet adaptif: tinggi mengikuti jumlah item, scroll hanya jika perlu
  void _showAdaptiveSelectorSheet({
    required BuildContext context,
    required String title,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.lightCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final screenHeight = MediaQuery.of(ctx).size.height;
        final maxHeight = screenHeight * 0.9; // batasi 90% layar

        // Perkiraan tinggi header + tinggi ListTile (~56)
        const headerApprox = 64.0; // handle + title + divider
        const tileApprox = 56.0;

        final needsScroll = headerApprox + tileApprox * itemCount > maxHeight;

        return SafeArea(
          child: ConstrainedBox(
            constraints:
                needsScroll
                    ? BoxConstraints(maxHeight: maxHeight)
                    : const BoxConstraints(), // wrap ke konten jika cukup
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Rothek',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Divider(height: 0),
                if (needsScroll)
                  Expanded(
                    child: ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: itemBuilder,
                    ),
                  )
                else
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: itemCount,
                    itemBuilder: itemBuilder,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showYearSelector(BuildContext context) {
    _showAdaptiveSelectorSheet(
      context: context,
      title: 'Pilih Tahun',
      itemCount: 1 + _years.length, // "Semua Tahun" + daftar tahun
      itemBuilder: (context, index) {
        if (index == 0) {
          // Tambahkan pemisah setelah "Semua Tahun"
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.all_inclusive),
                title: const Text('Semua Tahun'),
                onTap: () {
                  _selectedYear.value = null;
                  Navigator.of(context).pop();
                },
              ),
              const Divider(height: 0),
            ],
          );
        }
        final year = _years[index - 1];
        return ListTile(
          title: Text(year.toString()),
          onTap: () {
            _selectedYear.value = year;
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showMonthSelector(BuildContext context) {
    _showAdaptiveSelectorSheet(
      context: context,
      title: 'Pilih Bulan',
      itemCount: 13, // "Semua Bulan" + 12 bulan
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.all_inclusive),
                title: const Text('Semua Bulan'),
                onTap: () {
                  _selectedMonth.value = null;
                  Navigator.of(context).pop();
                },
              ),
              const Divider(height: 0),
            ],
          );
        }
        final i = index - 1;
        final monthIndex = i + 1;
        return ListTile(
          title: Text(_monthNames[i]),
          onTap: () {
            _selectedMonth.value = monthIndex;
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // Custom right-to-left push with parallax (Home bergeser sedikit ke kiri)
  Route<void> _createNotificationRoute() {
    return CupertinoPageRoute<void>(
      builder: (context) => NotificationView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // Title at top center
            const Center(
              child: Text(
                'TickTask',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Rothek',
                  fontSize: 32,
                  fontWeight: FontWeight.w900, // Rothek Black
                  color: AppColors.lightCream,
                ),
              ),
            ),
            const Center(
              child: Text(
                'Hi, Someone',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Rothek',
                  fontSize: 20,
                  fontWeight: FontWeight.w400, // Rothek Regular
                  color: AppColors.lightCream,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                    // Search bar
                    Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                      color: AppColors.lightCream,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                        ),
                      ],
                      ),
                      padding: const EdgeInsets.fromLTRB(30, 3, 3, 3),
                      child: Row(
                      children: [
                        const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                          hintText: 'Search by keywords',
                          border: InputBorder.none,
                          isCollapsed: true,
                          ),
                          style: TextStyle(
                          fontFamily: 'Rothek',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          ),
                        ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        ),
                      ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Notification button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightCream,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(1),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(_createNotificationRoute());
                      },
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.black,
                      ),
                      iconSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Row filter: Prioritas, Terdekat, Semua (rata kiri, eksklusif)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _filterButton(
                        label: 'Prioritas',
                        value: TaskFilter.prioritas,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _filterButton(
                        label: 'Terdekat',
                        value: TaskFilter.terdekat,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _filterButton(
                        label: 'Semua',
                        value: TaskFilter.semua,
                      ),
                    ),
                  ],
                );
              }),
            ),

            // Selector row: Tahun & Bulan
            Obx(() {
              final show = controller.selectedFilter.value == TaskFilter.semua;
              final yearLabel = _yearLabel; // observe _selectedYear
              final monthLabel = _monthLabel; // observe _selectedMonth
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final slide = Tween<Offset>(
                    begin: const Offset(0, -0.05),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: -1.0, // collapse/expand dari atas
                      child: SlideTransition(position: slide, child: child),
                    ),
                  );
                },
                child:
                    show
                        ? Column(
                          key: const ValueKey('selectors'),
                          children: [
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _selectorButton(
                                      label: yearLabel,
                                      icon: Icons.calendar_today,
                                      onTap: () => _showYearSelector(context),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _selectorButton(
                                      label: monthLabel,
                                      icon: Icons.event,
                                      onTap: () => _showMonthSelector(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        : const SizedBox.shrink(),
              );
            }),

            // Daftar kartu (sesuai filter terpilih)
            Expanded(
              child: Obx(() {
                // Sentuh Rxn agar Obx bereaksi pada perubahan selector
                final selectedYear = _selectedYear.value;
                final selectedMonth = _selectedMonth.value;
                final filter = controller.selectedFilter.value;

                // Kumpulkan item sesuai filter
                List<_TaskCardData> items;
                if (filter == TaskFilter.semua) {
                  // Terapkan filter Tahun/Bulan lalu urutkan dari deadline terdekat
                  items =
                      _sampleTasks
                          .where(
                            (t) => _taskMatchesSelection(
                              t,
                              selectedYear,
                              selectedMonth,
                            ),
                          )
                          .toList();
                  items.sort((a, b) => a.end.compareTo(b.end));
                } else if (filter == TaskFilter.prioritas) {
                  // Hanya prioritas
                  items =
                      _sampleTasks.where((t) => t.isPriority).toList()..sort(
                        (a, b) => a.end.compareTo(b.end),
                      ); // urutkan by deadline
                } else {
                  // Terdekat: ambil 5 dengan deadline terdekat dari sekarang
                  final now = DateTime.now();
                  final upcoming =
                      _sampleTasks
                          .where((t) => !t.end.isBefore(now)) // end >= now
                          .toList()
                        ..sort((a, b) => a.end.compareTo(b.end));

                  if (upcoming.isNotEmpty) {
                    items = upcoming.take(3).toList();
                  } else {
                    // fallback jika semua sudah lewat: ambil 5 paling dekat secara umum
                    items =
                        _sampleTasks.toList()
                          ..sort((a, b) => a.end.compareTo(b.end));
                    items = items.take(5).toList();
                  }
                }

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada tugas untuk filter ini',
                      style: TextStyle(
                        fontFamily: 'Rothek',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Stack(
                    children: [
                      // List card
                      ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 205),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder:
                            (context, index) => _taskCard(items[index]),
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
                );
              }),
            ),

            // ... add other content below as needed
          ],
        ),
      ),
    );
  }
}

// Model data sederhana untuk kartu
class _TaskCardData {
  final String title;
  final DateTime start;
  final DateTime end;
  final String timeRange;
  final bool isPriority;

  _TaskCardData({
    required this.title,
    required this.start,
    required this.end,
    required this.timeRange,
    required this.isPriority,
  });
}
