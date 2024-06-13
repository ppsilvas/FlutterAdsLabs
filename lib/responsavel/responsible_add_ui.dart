import 'package:adslabs/responsavel/responsible_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:provider/provider.dart';

class AddResponsiblePage extends StatefulWidget {
  const AddResponsiblePage({super.key});

  @override
  State<AddResponsiblePage> createState() => _AddResponsiblePageState();
}

class _AddResponsiblePageState extends State<AddResponsiblePage> {
  final TextEditingController _nameController = TextEditingController();
  DateTime _date = DateTime.now();
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final responsibleProvider = Provider.of<ResponsibleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Responsible'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              Row(
                children: [
                  const Text('Birthday: '),
                  TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        maxTime: DateTime(2014, 12, 31),
                        onConfirm: (date) {
                          setState(() {
                            _date = date;
                          });
                        },
                      );
                    },
                    child: Text(_date.toString()),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  DateTime birthday =
                      DateTime(_date.year, _date.month, _date.day);
                  final responsible = Responsible(
                    id: 0,
                    name: _nameController.text,
                    birthday: birthday,
                    createdAt: createdAt,
                    updatedAt: updatedAt,
                  );
                  responsibleProvider.addResponsibles(responsible).then((_) {
                    Navigator.pop(context);
                    responsibleProvider.fetchResponsibles();
                  }).catchError((error) {
                    print(error);
                    throw Exception('Não foi possível adicionar o responsável');
                  });
                },
                child: const Text('Add Responsible'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
