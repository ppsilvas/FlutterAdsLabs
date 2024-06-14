import 'package:adslabs/responsavel/responsible_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:provider/provider.dart';

class EditResponsiblePage extends StatefulWidget {
  final int responsibleId;
  const EditResponsiblePage({super.key, Key? id, required this.responsibleId});

  @override
  State<EditResponsiblePage> createState() => _EditResponsiblePageState();
}

class _EditResponsiblePageState extends State<EditResponsiblePage> {
  final TextEditingController _nameController = TextEditingController();
  DateTime birthday = DateTime.now();
  DateTime updateAt = DateTime.now();
  late Responsible _responsible;

  @override
  void initState() {
    super.initState();
    loadResponsible();
  }

  void loadResponsible() async {
    final Responsible taskByPk =
        await Provider.of<ResponsibleProvider>(context, listen: false)
            .fetchByPk(widget.responsibleId);
    _responsible = taskByPk;
    setState(() {
      _nameController.text = _responsible.name;
      birthday = _responsible.birthday;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsibleProvider = Provider.of<ResponsibleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Responsible'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'name'),
              ),
              Row(
                children: [
                  const Text('Deadline: '),
                  TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        maxTime: DateTime(2014, 12, 31),
                        onConfirm: (date) {
                          setState(() {
                            birthday = date;
                          });
                        },
                      );
                    },
                    child: Text(birthday.toString()),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  final responsible = Responsible(
                    id: _responsible.id,
                    name: _nameController.text,
                    birthday: birthday,
                    createdAt: _responsible.createdAt,
                    updatedAt: updateAt,
                  );
                  responsibleProvider
                      .editResponsibles(_responsible.id, responsible)
                      .then((_) {
                    Navigator.pop(context);
                    responsibleProvider.fetchResponsibles();
                  }).catchError((error) {});
                },
                child: const Text('Update Responsible'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
