import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFDEB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 30),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: AppBar(
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
              "Ubah Password",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _PasswordField(
                hint: 'Password Lama',
                controller: controller.currentPasswordController,
                validator: controller.validateCurrentPassword,
                obscureText: controller.isObscureCurrent,
              ),
              const SizedBox(height: 20),
              _PasswordField(
                hint: 'Password Baru',
                controller: controller.newPasswordController,
                validator: controller.validateNewPassword,
                obscureText: controller.isObscureNew,
              ),
              const SizedBox(height: 20),
              _PasswordField(
                hint: 'Ulangi Password Baru',
                controller: controller.confirmPasswordController,
                validator: controller.validateConfirmPassword,
                obscureText: controller.isObscureConfirm,
              ),
              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        controller.isSubmitting.value
                            ? null
                            : controller.submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
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
                              'Ubah Password',
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
    required this.hint,
    required this.controller,
    required this.validator,
    required this.obscureText,
  });

  final String hint;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final RxBool obscureText;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText.value,
          cursorColor: Colors.white,
          style: const TextStyle(
            fontFamily: 'Rothek',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            // Hide error text to avoid layout jump; we use snackbars instead
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Rothek',
              color: Color(0xFFBDBDBD),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              onPressed: () => obscureText.value = !obscureText.value,
              icon: Icon(
                obscureText.value ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
                size: 20,
              ),
              splashRadius: 20,
            ),
          ),
        ),
      ),
    );
  }
}
