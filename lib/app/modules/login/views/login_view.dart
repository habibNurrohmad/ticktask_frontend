import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final cream = const Color(0xFFF7F6E9);
    final lightPurple = const Color(0xFFB89AF0);
    final darkPurple = const Color(0xFF2F2340);

    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 18),
              const SizedBox(height: 24),
              Text(
                'Welcome back',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkPurple,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Let's login to your account first!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkPurple.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              // Username field
              _buildPillField(
                child: TextFormField(
                  controller: controller.usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 14, right: 12),
                      child: Icon(Icons.email_outlined, color: Colors.white70),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 48),
                    hintText: 'Username',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: lightPurple,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                color: lightPurple,
              ),
              const SizedBox(height: 18),

              // Password field
              _buildPillField(
                child: Obx(() => TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.obscurePassword.value,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 14, right: 12),
                          child: Icon(Icons.lock_outline, color: Colors.white70),
                        ),
                        prefixIconConstraints: const BoxConstraints(minWidth: 48),
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: lightPurple,
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: controller.toggleObscure,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )),
                color: lightPurple,
              ),

              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => InkWell(
                        onTap: controller.toggleRememberMe,
                        child: Row(
                          children: [
                            Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (_) => controller.toggleRememberMe(),
                              activeColor: darkPurple,
                            ),
                            Text(
                              'Remember me',
                              style: TextStyle(color: darkPurple.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      )),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: darkPurple.withOpacity(0.7)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.HOME);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkPurple,
                    shape: const StadiumBorder(),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Don't Have an Account ? ",
                      style: TextStyle(color: darkPurple.withOpacity(0.7)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.REGISTER);
                      },
                      child: Text(
                        'Register here',
                        style: TextStyle(color: darkPurple, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillField({required Widget child, required Color color}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
