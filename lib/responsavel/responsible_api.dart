import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Responsible {
  int id;
  final String name;
  final DateTime birthday;
  final DateTime createdAt;
  final DateTime updatedAt;

  Responsible(
      {required this.id,
      required this.name,
      required this.birthday,
      required this.createdAt,
      required this.updatedAt});

  factory Responsible.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'];
      final name = json['nome'];
      final birthday = DateTime.parse(json['dataNascimento']);
      final createdAt = DateTime.parse(json['createdAt']);
      final updatedAt = DateTime.parse(json['updatedAt']);

      return Responsible(
        id: id,
        name: name,
        birthday: birthday,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      rethrow; // Rethrow a exceção para que possa ser tratada adequadamente
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': name,
        'dataNascimento': birthday.toIso8601String(),
      };
  Map<String, dynamic> toJsonForAdd() => {
        'nome': name,
        'dataNascimento': birthday.toIso8601String(),
      };
}

class ResponsibleProvider extends ChangeNotifier {
  List<Responsible> responsibles = [];

  Future<void> fetchResponsibles() async {
    const url = 'http://localhost:3001/responsavel';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('pessoa')) {
        final List<dynamic> taskData = data['pessoa'];
        responsibles =
            taskData.map((item) => Responsible.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected JSON structure');
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Responsible> fetchByPk(int respkId) async {
    final url = 'http://localhost:3001/responsavel/?id=$respkId';
    final response = await http.get(Uri.parse(url));
    late Responsible responsible;
    if (response.statusCode != 200) {
      throw Exception('Failed to edit task');
    } else {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('pessoa')) {
        final index = responsibles
            .indexWhere((responsibles) => responsibles.id == respkId);
        responsible = responsibles[index];
      }
      return responsible;
    }
  }

  Future<void> addResponsibles(Responsible responsible) async {
    const url = 'http://localhost:3001/responsavel';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(responsible.toJsonForAdd()),
    );
    if (response.statusCode != 201) {
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to add task');
    } else {
      responsibles.add(responsible);
      notifyListeners();
    }
  }

  Future<void> deleteResponsibles(int respkId) async {
    final url = 'http://localhost:3001/responsavel/$respkId';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    } else {
      responsibles.removeWhere((task) => task.id == respkId);
      notifyListeners();
    }
  }

  Future<void> editResponsibles(int respkId, Responsible updatedresp) async {
    final url = 'http://localhost:3001/responsavel/$respkId';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedresp.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit task');
    } else {
      final index =
          responsibles.indexWhere((responsible) => responsible.id == respkId);
      responsibles[index] = updatedresp;
      notifyListeners();
    }
  }
}
