import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ticktask_frontend/app/core/values/app_colors.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              // Header row with back arrow and title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Notifikasi',
                        style: TextStyle(
                          fontFamily: 'Rothek',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.lightCream,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // keep symmetric spacing
                ],
              ),

              const SizedBox(height: 12),

              // List grouped by section labels
              Expanded(
                child: ListView.builder(
                  itemCount: _sections.length,
                  itemBuilder: (context, sIdx) {
                    final section = _sections[sIdx];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (section.label.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.lightCream,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                section.label,
                                style: const TextStyle(
                                  fontFamily: 'Rothek',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // cards (tappable -> show detail dialog)
                        ...section.items.map((it) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.lightCream,
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        it.title,
                                                        style: const TextStyle(
                                                          fontFamily: 'Rothek',
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w900,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      it.date,
                                                      style: TextStyle(
                                                        fontFamily: 'Rothek',
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black.withOpacity(0.6),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  it.body,
                                                  style: TextStyle(
                                                    fontFamily: 'Rothek',
                                                    fontSize: 14,
                                                    color: Colors.black.withOpacity(0.8),
                                                  ),
                                                ),
                                                const SizedBox(height: 18),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: TextButton(
                                                    onPressed: () => Navigator.of(ctx).pop(),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: const Color(0xFFEFEFEF),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                    ),
                                                    child: const Icon(Icons.close, color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: _notificationCard(it),
                              ),
                            )),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// model and sample data
class _NotificationSection {
  final String label;
  final List<_NotificationItem> items;
  _NotificationSection({required this.label, required this.items});
}

class _NotificationItem {
  final String title;
  final String date;
  final String body;
  _NotificationItem({required this.title, required this.date, required this.body});
}

final List<_NotificationSection> _sections = [
  _NotificationSection(
    label: 'Hari ini',
    items: List.generate(
      2,
      (i) => _NotificationItem(
        title: 'Rapat Lanik 2',
        date: '08 Oktober 2025',
        body: 'Task ini deadline hari ini pada tanggal 08 Oktober 2025. kamu bisa mengkonfirmasi tugas ini selesai jika sudah ....',
      ),
    ),
  ),
  _NotificationSection(
    label: 'Kemarin',
    items: List.generate(
      3,
      (i) => _NotificationItem(
        title: 'Rapat Lanik 2',
        date: '07 Oktober 2025',
        body: 'Task ini deadline hari ini pada tanggal 07 Oktober 2025. kamu bisa mengkonfirmasi tugas ini selesai jika sudah ....',
      ),
    ),
  ),
  _NotificationSection(
    label: '06 Oktober 2025',
    items: [
      _NotificationItem(
        title: 'Rapat Lanik 2',
        date: '06 Oktober 2025',
        body: 'Task ini deadline hari ini pada tanggal 06 Oktober 2025. kamu bisa mengkonfirmasi tugas ini selesai jika sudah ....',
      ),
    ],
  ),
];


Widget _notificationCard(_NotificationItem it) {
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
    padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      it.title,
                      style: const TextStyle(
                        fontFamily: 'Rothek',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    it.date,
                    style: TextStyle(
                      fontFamily: 'Rothek',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                it.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Rothek',
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
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
