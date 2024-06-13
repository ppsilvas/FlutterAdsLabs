import 'package:adslabs/main.dart';
import 'package:adslabs/responsavel/responsible_add_ui.dart';
import 'package:adslabs/responsavel/responsible_api.dart';
import 'package:adslabs/responsavel/responsible_edit_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsibleMenu extends StatelessWidget {
  const ResponsibleMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResponsibleProvider>(
        create: (_) => ResponsibleProvider(),
        child: MaterialApp(
          title: 'Tasks',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 240, 168, 61)),
            useMaterial3: true,
          ),
          home: const ResponsiblePage(title: 'Responsibles'),
        ));
  }
}

class ResponsiblePage extends StatefulWidget {
  final String title;
  const ResponsiblePage({super.key, required this.title});

  @override
  State<ResponsiblePage> createState() => _ResponsiblePageState();
}

class _ResponsiblePageState extends State<ResponsiblePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ResponsibleProvider>(context, listen: false)
        .fetchResponsibles();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<ResponsibleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
              child: Text('Responsibles'),
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
      body: taskProvider.responsibles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: taskProvider.responsibles.length,
              itemBuilder: (context, index) {
                final task = taskProvider.responsibles[index];
                return ListTile(
                  title: Text(
                    task.name,
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
                          Text('dataNascimento: ${task.birthday}'),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => navigateToEditResponsible(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            taskProvider.deleteResponsibles(task.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => navigateToAddResponsible(),
      ),
    );
  }

  void navigateToAddResponsible() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddResponsiblePage()),
    );
  }

  void navigateToEditResponsible(int key) {
    final responsibleId =
        Provider.of<ResponsibleProvider>(context, listen: false)
            .responsibles[key]
            .id;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditResponsiblePage(
                responsibleId: responsibleId,
              )),
    );
  }
}
