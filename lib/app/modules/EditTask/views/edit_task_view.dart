import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_task_controller.dart';

class EditTaskView extends GetView<EditTaskController> {
  const EditTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFF5F3E6); // soft cream
    const Color pillBlue = Color(0xFF5F8BB8); // medium blue

    String _formatDate(DateTime? dt) {
      if (dt == null) return "-";
      const months = [
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
      return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
    }

    return Scaffold(
        backgroundColor: const Color(0xffFCFEE8),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 30),
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: AppBar(
              backgroundColor: const Color(0xffFCFEE8),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 22,
                ),
                onPressed: () => Get.back(),
              ),
              title: const Text(
                "Edit Task",
                style: TextStyle(
                  fontFamily: 'Rhotek', // Font Rhotek
                  color: Colors.black,
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
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title pill input
                  _PillTextField(
                    controller: controller.titleC,
                    hintText: 'Judul',
                    blue: pillBlue,
                  ),
                  const SizedBox(height: 14),

                  // Date pill selector
                  _PillDateSelector(
                    valueText: _formatDate(controller.deadline.value),
                    blue: pillBlue,
                    onTap: () async {
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      final current = controller.deadline.value;
                      final safeInitial =
                          (current != null && current.isAfter(today))
                              ? current
                              : today;

                      final date = await showDatePicker(
                        context: context,
                        initialDate: safeInitial,
                        firstDate: today, // block past dates
                        lastDate: DateTime(2035),
                      );
                      if (date != null) {
                        controller.deadline.value = date;
                      }
                    },
                  ),
                  const SizedBox(height: 18),

                  // Prioritas switch row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Prioritas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Obx(
                        () => Switch(
                          value: controller.isPriority.value,
                          onChanged: (v) => controller.isPriority.value = v,
                          activeColor: Colors.white,
                          activeTrackColor: Colors.redAccent,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Description card styled like pill
                  _PillTextField(
                    controller: controller.descC,
                    hintText: 'Deskripsi',
                    blue: pillBlue,
                    minLines: 5,
                    maxLines: 8,
                  ),

                  const SizedBox(height: 40),

                  // Edit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.updateTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pillBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: const StadiumBorder(),
                        elevation: 6,
                      ),
                      child: const Text(
                        'Konfirmasi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
    );
  }
}

class _PillTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color blue;
  final int? minLines;
  final int? maxLines;

  const _PillTextField({
    required this.controller,
    required this.hintText,
    required this.blue,
    this.minLines,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: blue,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        minLines: minLines ?? 1,
        maxLines: maxLines ?? 1,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontWeight: FontWeight.w600,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _PillDateSelector extends StatelessWidget {
  final String valueText;
  final Color blue;
  final VoidCallback onTap;

  const _PillDateSelector({
    required this.valueText,
    required this.blue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: blue,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  valueText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(Icons.date_range, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
