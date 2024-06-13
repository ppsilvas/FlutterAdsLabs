//import 'dart:js';

import 'package:adslabs/tarefas/task_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:provider/provider.dart';

class EditTaskPage extends StatefulWidget {
  final int taskId;
  const EditTaskPage({super.key, Key? id, required this.taskId});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  //final _id = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _responsibleController = TextEditingController();
  late Task _task;
  DateTime _deadline = DateTime.now();
  DateTime updatedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  void loadTask() async {
    final Task taskByPk =
        await Provider.of<TaskProvider>(context, listen: false)
            .fetchByPk(widget.taskId);
    _task = taskByPk;
    setState(() {
      _titleController.text = _task.title;
      _descriptionController.text = _task.description ?? '';
      _statusController.text = _task.status;
      _responsibleController.text = _task.responsible.toString();
      _deadline = _task.deadline;
      updatedAt = _task.updatedAt;
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'description'),
              ),
              TextField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'status'),
              ),
              TextField(
                controller: _responsibleController,
                decoration: const InputDecoration(labelText: 'Responsavel'),
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
                            _deadline = date;
                          });
                        },
                      );
                    },
                    child: Text(_deadline.toString()),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  final responsibleId =
                      int.tryParse(_responsibleController.text);
                  if (responsibleId == null) {
                    throw Exception('Responsavel não pode ser nulo');
                  }
                  final task = Task(
                    id: _task.id,
                    title: _titleController.text,
                    responsible: responsibleId,
                    status: _statusController.text,
                    deadline: _deadline,
                    createdAt: _task.createdAt,
                    updatedAt: updatedAt,
                  );
                  taskProvider.editTask(_task.id, task).then((_) {
                    Navigator.pop(context);
                    taskProvider.fetchTasks();
                  }).catchError((error) {});
                },
                child: const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
