import 'package:flutter/material.dart';

import 'package:to_do/services/todo_service.dart';
import 'package:to_do/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key, this.todo});

  final Map? todo;

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  bool isEdit = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final todo = widget.todo;

    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];

      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Map get body {
    // Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      'title': title,
      'description': description,
      'is_completed': false,
    };
  }

  Future<void> submitData() async {
    // Submit data to the server
    final isSuccess = await TodoService.createTodo(body);

    // Show success or fail message based on status
    if (isSuccess) {
      titleController.clear();
      descriptionController.clear();

      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: 'Creation Success');
    } else {
      // ignore: use_build_context_synchronously
      showErroMessage(context, message: 'Creation Failed');
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo['_id'];

    // Submit updated data to the server
    final isSuccess = await TodoService.updateTodo(id, body);

    // Show success or fail message based on status
    if (isSuccess) {
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: 'Updation Success');
    } else {
      // ignore: use_build_context_synchronously
      showErroMessage(context, message: 'Updation Failed');
    }
  }
}
