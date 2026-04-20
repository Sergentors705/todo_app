import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/data/todo_repository.dart';

class TodoViewModel extends ChangeNotifier {
  final TodoRepository repository;

  Todo? _pendingDelete;

  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoViewModel(this.repository);

  Future<void> loadTodos() async {
    _todos = await repository.getTodos();
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) return;

    final id = await repository.addTodo(Todo(title: title, isDone: false));

    final tempTodo = Todo(id: id, title: title, isDone: false);

    _todos = [..._todos, tempTodo];
    notifyListeners();

    try {
      final id = await repository.addTodo(Todo(title: title, isDone: false));

      _todos = _todos.map((t) {
        if (t.id == tempTodo.id) {
          return Todo(id: id, title: t.title, isDone: t.isDone);
        }
        return t;
      }).toList();

      notifyListeners();
    } catch (e) {
      _todos = _todos.where((t) => t.id != tempTodo.id).toList();
      notifyListeners();
    }
  }

  Future<void> toggleTodo(Todo todo) async {
    final oldTodos = _todos;

    _todos = _todos.map((t) {
      if (t.id == todo.id) {
        return Todo(id: t.id, title: t.title, isDone: !t.isDone);
      }
      return t;
    }).toList();

    notifyListeners();

    try {
      await repository.updateTodo(todo.id!, todo.isDone ? 0 : 1);
    } catch (e) {
      _todos = oldTodos;
      notifyListeners();
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    final oldTodos = _todos;

    _todos = _todos.where((t) => t.id != todo.id).toList();
    notifyListeners();

    try {
      await repository.deleteTodo(todo.id!);
    } catch (e) {
      _todos = oldTodos;
      notifyListeners();
    }
  }

  Future<void> deleteTodoWithUndo(Todo todo) async {
    _pendingDelete = todo;

    // deleting from UI
    _todos = _todos.where((t) => t.id != todo.id).toList();
    notifyListeners();

    // waiting 3 seconds
    await Future.delayed(Duration(seconds: 3));

    // if NOT cancelled
    if (_pendingDelete == todo) {
      await repository.deleteTodo(todo.id!);
      _pendingDelete = null;
    }
  }

  void undoDelete() {
    if (_pendingDelete == null) return;

    _todos = [..._todos, _pendingDelete!];
    notifyListeners();

    _pendingDelete = null;
  }
}
