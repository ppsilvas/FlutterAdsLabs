import 'package:adslabs/responsavel/responsible_menu.dart';
import 'package:adslabs/tarefas/task_menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'HOME'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAIN MENU'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TaskMenu()),
                  );
                },
                child: const Text('Tasks'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResponsibleMenu()),
                  );
                },
                child: const Text('Responsibles'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
