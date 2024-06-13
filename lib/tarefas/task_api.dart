import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Task {
  int id;
  final String title;
  final String? description;
  final int responsible;
  final String status;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.responsible,
    required this.status,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'];
      final title = json['titulo'];
      final deadline = DateTime.parse(json['dataConclusao']);
      final status = json['status'];
      final description =
          json['descricao'] ?? ""; // Definir descrição como vazia se for nulo
      final responsible = json['pessoaId'];
      final createdAt = DateTime.parse(json['createdAt']);
      final updatedAt = DateTime.parse(json['updatedAt']);

      return Task(
        id: id,
        title: title,
        deadline: deadline,
        status: status,
        description: description,
        responsible: responsible,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      rethrow; // Rethrow a exceção para que possa ser tratada adequadamente
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': title,
        'descricao': description,
        'pessoaId': responsible,
        'status': status,
        'dataConclusao': deadline.toIso8601String(),
      };
  Map<String, dynamic> toJsonForAdd() => {
        'titulo': title,
        'descricao': description,
        'pessoaId': responsible,
        'status': status,
        'dataConclusao': deadline.toIso8601String(),
      };
}

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];

  Future<void> fetchTasks() async {
    const url = 'http://localhost:3001/tarefa';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('tarefas')) {
        final List<dynamic> taskData = data['tarefas'];
        tasks = taskData.map((item) => Task.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected JSON structure');
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> fetchByPk(int taskId) async {
    final url = 'http://localhost:3001/tarefa/?id=$taskId';
    final response = await http.get(Uri.parse(url));
    late Task task;
    if (response.statusCode != 200) {
      throw Exception('Failed to edit task');
    } else {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('tarefas')) {
        final index = tasks.indexWhere((task) => task.id == taskId);
        task = tasks[index];
      }
      return task;
    }
  }

  Future<void> addTask(Task task) async {
    const url = 'http://localhost:3001/tarefa';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJsonForAdd()),
    );
    if (response.statusCode != 201) {
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to add task');
    } else {
      tasks.add(task);
      notifyListeners();
    }
  }

  Future<void> deleteTask(int taskId) async {
    final url = 'http://localhost:3001/tarefa/$taskId';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    } else {
      tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    }
  }

  Future<void> editTask(int taskId, Task updatedTask) async {
    final url = 'http://localhost:3001/tarefa/$taskId';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedTask.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit task');
    } else {
      final index = tasks.indexWhere((task) => task.id == taskId);
      tasks[index] = updatedTask;
      notifyListeners();
    }
  }
}
