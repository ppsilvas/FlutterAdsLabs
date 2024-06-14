import 'package:adslabs/responsavel/responsible_menu.dart';
import 'package:adslabs/tarefas/task_add_ui.dart';
import 'package:adslabs/tarefas/task_api.dart';
import 'package:adslabs/tarefas/task_edit_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsibleTaskPage extends StatelessWidget {
  final int responsibleId;
  const ResponsibleTaskPage({super.key, required this.responsibleId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskProvider>(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        title: 'Responsible Tasks',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 61, 177, 240),
          ),
          useMaterial3: true,
        ),
        home: ResponsibleTaskList(
          title: 'Responsible Tasks',
          id: responsibleId,
        ),
      ),
    );
  }
}

class ResponsibleTaskList extends StatefulWidget {
  final String title;
  final int id;
  const ResponsibleTaskList({super.key, required this.title, required this.id});

  @override
  State<ResponsibleTaskList> createState() => _ResponsibleTaskListState();
}

class _ResponsibleTaskListState extends State<ResponsibleTaskList> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false)
        .fetchResponsible(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final responsibleProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
              child: Text('Responsible Tasks'),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ResponsibleMenu()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: responsibleProvider.tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: responsibleProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = responsibleProvider.tasks[index];
                return ListTile(
                  title: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 5),
                          Text('Descrição: ${task.description}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 5),
                          Text('Data de Conclusão: ${task.deadline}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.work),
                          const SizedBox(width: 5),
                          Text('Status: ${task.status}'),
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
                        onPressed: () =>
                            responsibleProvider.deleteTask(task.id),
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
