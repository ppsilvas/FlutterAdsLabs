import 'package:adslabs/main.dart';
import 'package:adslabs/tarefas/task_add_ui.dart';
import 'package:adslabs/tarefas/task_edit_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adslabs/tarefas/task_api.dart';
import 'package:intl/intl.dart';

class TaskMenu extends StatelessWidget {
  const TaskMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskProvider>(
        create: (_) => TaskProvider(),
        child: MaterialApp(
          title: 'Tasks',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 240, 168, 61)),
            useMaterial3: true,
          ),
          home: const TaskPage(title: 'Tasks'),
        ));
  }
}

class TaskPage extends StatefulWidget {
  final String title;
  const TaskPage({super.key, required this.title});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
              child: Text('Tasks'),
            ),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: taskProvider.tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                bool condition;
                if (task.status == 'pendente') {
                  condition = true;
                } else {
                  condition = false;
                }
                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: condition ? Colors.red : Colors.black),
                  ),
                  // subtitle: Text('${task.status} - ${task.priority}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 5),
                          Text('pessoaId: ${task.responsible}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 5),
                          Text('descricao: ${task.description}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 5),
                          Text(
                              'dataConclusao: ${DateFormat('yyyy-MM-dd').format(task.deadline)}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.work),
                          const SizedBox(width: 5),
                          Text(task.status),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => navigateToEditTask(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => taskProvider.deleteTask(task.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => navigateToAddTask(),
      ),
    );
  }

  void navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    );
  }

  void navigateToEditTask(int key) {
    final taskId =
        Provider.of<TaskProvider>(context, listen: false).tasks[key].id;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditTaskPage(
                taskId: taskId,
              )),
    );
  }
}
