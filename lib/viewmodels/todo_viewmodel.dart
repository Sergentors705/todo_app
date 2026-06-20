import 'package:flutter/material.dart';
import 'package:todo_app/domain/repositories/i_todo_repository.dart';
import 'package:todo_app/domain/usecases/add_todo.dart';
import 'package:todo_app/domain/usecases/change_priority_todo.dart';
import 'package:todo_app/domain/usecases/delete_todo.dart';
import 'package:todo_app/domain/usecases/edit_todo.dart';
import 'package:todo_app/domain/usecases/toggle_todo.dart';
import 'package:todo_app/models/todo.dart';

enum TodoFilter { all, active, completed }

enum TodoSort { none, priority }

class TodoViewModel extends ChangeNotifier {
  final ITodoRepository repository;
  final AddTodoUseCase addTodoUseCase;
  final ToggleTodoUseCase toggleTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;
  final ChangePriorityUseCase changePriorityUseCase;
  final EditTodoUseCase editTodoUseCase;

  final Map<int, Todo> _pendingDeletes = {};

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoViewModel(
    this.repository,
    this.addTodoUseCase,
    this.toggleTodoUseCase,
    this.deleteTodoUseCase,
    this.changePriorityUseCase,
    this.editTodoUseCase,
  );

  TodoFilter _filter = TodoFilter.all;
  TodoFilter get filter => _filter;
  void setFilter(TodoFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  TodoSort _sort = TodoSort.none;
  TodoSort get sort => _sort;
  void setSort(TodoSort sort) {
    _sort = sort;
    notifyListeners();
  }

  void _replaceTodo(Todo updatedTodo) {
    _todos = _todos.map((t) {
      if (t.id == updatedTodo.id) {
        return updatedTodo;
      }
      return t;
    }).toList();
    notifyListeners();
  }

  // FILTER
  List<Todo> get filteredTodos {
    List<Todo> result;

    // FILTER
    switch (_filter) {
      case TodoFilter.active:
        result = _todos.where((t) => !t.isDone).toList();
        break;

      case TodoFilter.completed:
        result = _todos.where((t) => t.isDone).toList();
        break;

      case TodoFilter.all:
        result = [..._todos];
        break;
    }

    // SEARCH
    if (_searchQuery.isNotEmpty) {
      result = result.where((t) {
        return t.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // SORT
    switch (_sort) {
      case TodoSort.priority:
        result.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case TodoSort.none:
        break;
    }
    return result;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // LOAD
  Future<void> loadTodos() async {
    _todos = await repository.getTodos();
    notifyListeners();
  }

  // ADD
  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) return;

    final id = await addTodoUseCase(title);

    final newTodo = Todo(
      id: id,
      title: title,
      isDone: false,
      priority: Priority.medium,
    );

    _todos = [..._todos, newTodo];
    notifyListeners();
  }

  // TOGGLE
  Future<void> toggleTodo(Todo todo) async {
    try {
      final updatedTodo = await toggleTodoUseCase(todo);
      _replaceTodo(updatedTodo);
    } catch (e) {
      print(e);
    }
  }

  // DELETE
  Future<void> deleteTodo(Todo todo) async {
    final oldTodos = _todos;

    _todos = _todos.where((t) => t.id != todo.id).toList();
    notifyListeners();

    try {
      await deleteTodoUseCase(todo);
    } catch (e) {
      _todos = oldTodos;
      notifyListeners();
    }
  }

  // DELETE WITH UNDO
  Future<void> deleteTodoWithUndo(Todo todo) async {
    _pendingDeletes[todo.id!] = todo;

    // deleting from UI
    _todos = _todos.where((t) => t.id != todo.id).toList();
    notifyListeners();

    // waiting 3 seconds
    await Future.delayed(Duration(seconds: 3));

    // if NOT cancelled
    if (_pendingDeletes.containsKey(todo.id)) {
      await repository.deleteTodo(todo.id!);
      _pendingDeletes.remove(todo.id);
    }
  }

  void undoDelete(int id) {
    final todo = _pendingDeletes[id];
    if (todo == null) return;

    _todos = [..._todos, todo];
    notifyListeners();

    _pendingDeletes.remove(id);
  }

  // PRIORITY
  Future<void> changePriorityTodo(Todo todo) async {
    try {
      final updatedTodo = await changePriorityUseCase(todo);
      _replaceTodo(updatedTodo);
    } catch (e) {
      // notifyListeners();
    }
  }

  // EDIT
  Future<void> editTodo(Todo todo, String newTitle) async {
    try {
      final updatedTodo = await editTodoUseCase(todo, newTitle);
      _replaceTodo(updatedTodo);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
