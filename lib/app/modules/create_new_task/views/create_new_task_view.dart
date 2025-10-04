import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/create_new_task_controller.dart';

class CreateNewTaskView extends GetView<CreateNewTaskController> {
  const CreateNewTaskView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreateNewTaskView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CreateNewTaskView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
