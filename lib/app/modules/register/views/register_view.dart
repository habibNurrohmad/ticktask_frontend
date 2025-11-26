import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  static const Color _background = Color(0xFFFAFBE6);
  static const Color _inputPurple = Color(0xFF8F6BE6);
  static const Color _buttonDark = Color(0xFF2B2133);

  Widget _buildPill({
    required IconData leading,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    Widget? trailing,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: _inputPurple,
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(leading, color: Colors.white.withOpacity(0.9), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: TextStyle(color: Colors.white.withOpacity(0.95)),
              decoration: InputDecoration.collapsed(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Register Now',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2B2033),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create an account and start getting your\ntask done!',
                style: TextStyle(fontSize: 16, color: Color(0xFF6B6970)),
              ),
              const SizedBox(height: 28),

              // Name
              _buildPill(
                leading: Icons.person_outline,
                hint: 'Your full name',
                controller: controller.usernameController,
              ),
              const SizedBox(height: 18),

              // Email
              _buildPill(
                leading: Icons.mail_outline,
                hint: 'youremail@example.com',
                controller: controller.emailController,
              ),
              const SizedBox(height: 18),

              // Password
              Obx(() {
                return _buildPill(
                  leading: Icons.lock_outline,
                  hint: '***********',
                  obscure: controller.obscurePassword.value,
                  controller: controller.passwordController,
                  trailing: IconButton(
                    onPressed: controller.toggleObscure,
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.remove_red_eye_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 18),

              // CONFIRM PASSWORD (BARU DITAMBAH)
              Obx(() {
                return _buildPill(
                  leading: Icons.lock_reset_outlined,
                  hint: 'Confirm password',
                  obscure: controller.obscureConfirmPassword.value,
                  controller: controller.confirmPasswordController,
                  trailing: IconButton(
                    onPressed: controller.toggleObscureConfirm,
                    icon: Icon(
                      controller.obscureConfirmPassword.value
                          ? Icons.remove_red_eye_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 28),

              // Register button
              GestureDetector(
                onTap: controller.register,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _buttonDark,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Center(
                child: Wrap(
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Color(0xFF9B9B9B)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.LOGIN);
                      },
                      child: const Text(
                        'Login here',
                        style: TextStyle(
                          color: Color(0xFF2B2033),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
