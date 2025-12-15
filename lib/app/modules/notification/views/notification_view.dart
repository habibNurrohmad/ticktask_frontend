import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ticktask_frontend/app/core/values/app_colors.dart';

import '../controllers/notification_controller.dart';
import '../model/notification_model.dart';

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
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final error = controller.errorMessage.value;
                  if (error != null && error.isNotEmpty) {
                    return Center(
                      child: Text(
                        error,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Rothek',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  final sections = controller.sections;
                  if (sections.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada notifikasi',
                        style: TextStyle(
                          fontFamily: 'Rothek',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: sections.length,
                    itemBuilder: (context, sIdx) {
                      final section = sections[sIdx];
                      final List<Widget> children = <Widget>[];

                      if (section.label.isNotEmpty) {
                        children.addAll([
                          const SizedBox(height: 8),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
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
                        ]);
                      }

                      children.addAll(
                        section.items.map((NotificationItem it) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 40,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.lightCream,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                          18,
                                          18,
                                          18,
                                          18,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      it.title,
                                                      style: const TextStyle(
                                                        fontFamily: 'Rothek',
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    it.formattedDate,
                                                    style: TextStyle(
                                                      fontFamily: 'Rothek',
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black
                                                          .withOpacity(0.6),
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
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                              const SizedBox(height: 18),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: TextButton(
                                                  onPressed:
                                                      () =>
                                                          Navigator.of(
                                                            ctx,
                                                          ).pop(),
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFEFEFEF),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 8,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                  ),
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
                          );
                        }),
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: children,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _notificationCard(NotificationItem it) {
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
                    it.formattedDate,
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
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}
