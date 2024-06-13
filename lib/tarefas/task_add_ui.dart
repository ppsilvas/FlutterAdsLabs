import 'package:adslabs/tarefas/task_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:provider/provider.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _responsibleController = TextEditingController();
  DateTime deadline = DateTime.now();
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: _responsibleController,
                decoration: const InputDecoration(labelText: 'Responsible'),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  const Text('Deadline: '),
                  TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        onConfirm: (date) {
                          setState(() {
                            deadline = date;
                          });
                        },
                      );
                    },
                    child: Text(deadline.toString()),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  final responsibleId =
                      int.tryParse(_responsibleController.text);
                  if (responsibleId == null) {
                    throw Exception('Deve Conter o responsavel!');
                  }
                  final task = Task(
                    id: 0,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    responsible: responsibleId,
                    status: _statusController.text,
                    deadline: deadline,
                    createdAt: createdAt,
                    updatedAt: updatedAt,
                  );
                  taskProvider.addTask(task).then((_) {
                    Navigator.pop(context);
                    taskProvider.fetchTasks();
                  }).catchError((error) {
                    throw Exception('Não foi possível adicionar o responsável');
                  });
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
