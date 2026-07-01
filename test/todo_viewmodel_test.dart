import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_app/domain/repositories/fake_todo_repository.dart';
import 'package:todo_app/domain/usecases/add_todo.dart';
import 'package:todo_app/domain/usecases/change_priority_todo.dart';
import 'package:todo_app/domain/usecases/delete_todo.dart';
import 'package:todo_app/domain/usecases/edit_todo.dart';
import 'package:todo_app/domain/usecases/toggle_todo.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/viewmodels/todo_viewmodel.dart';
import 'package:todo_app/data/todo_repository.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  TodoViewModel createViewModel(FakeTodoRepository repository) {
    return TodoViewModel(
      repository,
      AddTodoUseCase(repository),
      ToggleTodoUseCase(repository),
      DeleteTodoUseCase(repository),
      ChangePriorityUseCase(repository),
      EditTodoUseCase(repository),
    );
  }

  test('addTodo adds a new todo', () async {
    final repository = FakeTodoRepository();
    final viewModel = createViewModel(repository);

    await viewModel.addTodo('Task 1');
  });

  test('search filter todos', () async {
    final repository = FakeTodoRepository();
    final viewModel = createViewModel(repository);

    await viewModel.addTodo('Buy milk');
    await viewModel.addTodo('Do homework');

    viewModel.setSearchQuery('milk');

    expect(viewModel.filteredTodos.length, 1);
    expect(viewModel.filteredTodos.first.title, 'Buy milk');
  });

  test('filtered active todos', () async {
    final repository = FakeTodoRepository();
    final viewModel = createViewModel(repository);
    repository.todos = [
      Todo(id: 1, title: 'Task 1', isDone: true, priority: Priority.medium),
      Todo(id: 2, title: 'Task 2', isDone: false, priority: Priority.medium),
    ];
    await viewModel.loadTodos();
    viewModel.setFilter(TodoFilter.active);

    expect(viewModel.filteredTodos.length, 1);
    expect(viewModel.filteredTodos.first.id, 2);
  });

  test('filtered complete todos', () async {
    final repository = FakeTodoRepository();
    final viewModel = createViewModel(repository);
    repository.todos = [
      Todo(id: 1, title: 'Task 1', isDone: true, priority: Priority.medium),
      Todo(id: 2, title: 'Task 2', isDone: false, priority: Priority.medium),
    ];
    await viewModel.loadTodos();
    viewModel.setFilter(TodoFilter.completed);

    expect(viewModel.filteredTodos.length, 1);
    expect(viewModel.filteredTodos.first.id, 1);
  });

  test('filtered all todos', () async {
    final repository = FakeTodoRepository();
    final viewModel = createViewModel(repository);
    repository.todos = [
      Todo(id: 1, title: 'Task 1', isDone: true, priority: Priority.medium),
      Todo(id: 2, title: 'Task 2', isDone: false, priority: Priority.medium),
    ];
    await viewModel.loadTodos();
    viewModel.setFilter(TodoFilter.all);

    expect(viewModel.filteredTodos.length, 2);
    expect(viewModel.filteredTodos.first.id, 1);
  });

  test('search todos', () async {
    final repository = FakeTodoRepository();
    final viewModel = createViewModel(repository);
    repository.todos = [
      Todo(id: 1, title: 'Task 1', isDone: true, priority: Priority.medium),
      Todo(id: 2, title: 'Task 2', isDone: false, priority: Priority.medium),
    ];
    await viewModel.loadTodos();
    viewModel.setSearchQuery('1');

    expect(viewModel.filteredTodos.length, 1);
    expect(viewModel.filteredTodos.first.id, 1);
  });

  test('sorting priority todos', () async {
    final repository = FakeTodoRepository();
    final viewModel = createViewModel(repository);
    repository.todos = [
      Todo(id: 1, title: 'Task 1', isDone: true, priority: Priority.medium),
      Todo(id: 2, title: 'Task 2', isDone: false, priority: Priority.high),
    ];
    await viewModel.loadTodos();
    viewModel.setSort(TodoSort.priority);

    expect(viewModel.filteredTodos.length, 2);
    expect(viewModel.filteredTodos.first.id, 2);
  });
}
