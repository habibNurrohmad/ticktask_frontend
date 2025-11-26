import 'package:flutter/material.dart';

class CreateNewTaskView extends StatefulWidget {
  const CreateNewTaskView({super.key});

  @override
  State<CreateNewTaskView> createState() => _CreateNewTaskViewState();
}

class _CreateNewTaskViewState extends State<CreateNewTaskView> {
  bool _isPriority = false; // ← variabel agar switch dinamis

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
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

              _inputBox("Nama Task"),
              const SizedBox(height: 15),

              _inputBox("Tanggal"),
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
                  Switch(
                    value: _isPriority,
                    activeColor: Colors.blue,
                    onChanged: (val) {
                      setState(() {
                        _isPriority = val;
                      });
                    },
                  ),
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
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Deskripsi Task",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // --- BUTTON ---
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF5C8BAE),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Center(
                  child: Text(
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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // INPUT BOX
  Widget _inputBox(String hint) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF5C8BAE),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.centerLeft,
      child: Text(
        hint,
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );
  }
}
