import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mildPink,
      appBar: AppBar(
        backgroundColor: AppColors.mildPink,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontFamily: 'Rothek',
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Pastikan password baru berbeda dari password lama Anda.',
                style: TextStyle(
                  fontFamily: 'Rothek',
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              _PasswordField(
                label: 'Current Password',
                controller: controller.currentPasswordController,
                validator: controller.validateCurrentPassword,
                obscureText: controller.isObscureCurrent,
                onToggleVisibility: controller.toggleCurrentVisibility,
              ),
              const SizedBox(height: 20),
              _PasswordField(
                label: 'New Password',
                controller: controller.newPasswordController,
                validator: controller.validateNewPassword,
                obscureText: controller.isObscureNew,
                onToggleVisibility: controller.toggleNewVisibility,
              ),
              const SizedBox(height: 20),
              _PasswordField(
                label: 'Confirm Password',
                controller: controller.confirmPasswordController,
                validator: controller.validateConfirmPassword,
                obscureText: controller.isObscureConfirm,
                onToggleVisibility: controller.toggleConfirmVisibility,
              ),
              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed:
                        controller.isSubmitting.value
                            ? null
                            : controller.submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:
                        controller.isSubmitting.value
                            ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text(
                              'Update Password',
                              style: TextStyle(
                                fontFamily: 'Rothek',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.validator,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final RxBool obscureText;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText.value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'Rothek'),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.black54),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText.value ? Icons.visibility_off : Icons.visibility,
              color: Colors.black54,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }
}
