import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFDEB),
      appBar: AppBar(
        backgroundColor: const Color(0xffFFFDEB),
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
          "About",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 20),

              Center(
                child: Text(
                  "TickTask",
                  style: TextStyle(
                    fontFamily: 'Rothek', // Font Rhotek
                    fontSize: 36,
                    fontWeight: FontWeight.w900, // super bold
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              SizedBox(height: 20),

              Text(
                "TickTask adalah aplikasi manajemen tugas yang dirancang untuk "
                "membantu kamu mengatur aktivitas harian dengan lebih mudah dan "
                "terstruktur. Dengan tampilan yang sederhana dan intuitif, kamu "
                "dapat membuat daftar tugas, mengatur prioritas, serta menandai "
                "pekerjaan yang telah selesai dengan lebih praktis.\n\n"
                "TickTask hadir sebagai teman produktivitas yang membuatmu tetap "
                "fokus pada hal-hal penting. Setiap fitur dibuat agar kamu bisa "
                "merencanakan hari dengan lebih efisien, tanpa ribet. Mulai dari "
                "tugas kecil hingga aktivitas penting, semuanya tersimpan rapi "
                "dalam satu aplikasi.\n\n"
                "Dengan TickTask, kamu bisa menjalani hari dengan lebih tenang, "
                "teratur, dan terkontrol.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Rothek', // Font Rhotek
                  fontSize: 15,
                  height: 1.45,
                  fontWeight: FontWeight.w400, // regular
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
