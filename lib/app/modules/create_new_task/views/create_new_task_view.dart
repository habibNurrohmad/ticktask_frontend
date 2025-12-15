import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_new_task_controller.dart';

class CreateNewTaskView extends StatefulWidget {
  const CreateNewTaskView({super.key});

  @override
  State<CreateNewTaskView> createState() => _CreateNewTaskViewState();
}

class _CreateNewTaskViewState extends State<CreateNewTaskView> {
  final c = Get.put(CreateNewTaskController());

  final titleC = TextEditingController();
  final deadlineC = TextEditingController();
  final descC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: const Text(
          "Task Baru",
          style: TextStyle(
            fontFamily: 'Rothek',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // --- INPUT TITLE ---
              _inputBox(
                controller: titleC,
                hint: "Nama Task",
                onChanged: (v) => c.title.value = v,
              ),
              const SizedBox(height: 15),

              // --- INPUT DEADLINE ---
              _inputBox(
                controller: deadlineC,
                hint: "Tanggal (YYYY-MM-DD)",
                onChanged: (v) => c.deadline.value = v,
                readOnly: true,
                onTap: () async {
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  DateTime initial = today;
                  if (deadlineC.text.isNotEmpty) {
                    try {
                      final parts = deadlineC.text.split('-');
                      if (parts.length == 3) {
                        final y = int.parse(parts[0]);
                        final m = int.parse(parts[1]);
                        final d = int.parse(parts[2]);
                        initial = DateTime(y, m, d);
                        if (initial.isBefore(today)) initial = today;
                      }
                    } catch (_) {
                      initial = today;
                    }
                  }

                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: initial,
                    firstDate: today,
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    final formatted = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                    setState(() {
                      deadlineC.text = formatted;
                    });
                    c.deadline.value = formatted;
                  }
                },
              ),
              const SizedBox(height: 15),

              // --- PRIORITAS + SWITCH ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Prioritas",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rothek',
                    ),
                  ),
                  Obx(() {
                    return Switch(
                      value: c.isPriority.value,
                      activeColor: Colors.blue,
                      onChanged: (val) => c.isPriority.value = val,
                    );
                  }),
                ],
              ),

              const SizedBox(height: 10),

              // --- DESKRIPSI ---
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF5C8BAE),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: descC,
                  maxLines: null,
                  onChanged: (v) => c.description.value = v,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Deskripsi Task",
                    hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // --- BUTTON SUBMIT ---
              Obx(() {
                return GestureDetector(
                  onTap: c.isLoading.value ? null : () => c.submitTask(),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C8BAE),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child:
                          c.isLoading.value
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Tambahkan Task",
                                style: TextStyle(
                                  fontFamily: 'Rothek',
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------
  // CUSTOM INPUT BOX
  // -------------------------------------------
  Widget _inputBox({
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF5C8BAE),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
