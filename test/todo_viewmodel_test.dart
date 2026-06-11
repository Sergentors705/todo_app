import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_app/domain/usecases/add_todo.dart';
import 'package:todo_app/domain/usecases/change_priority_todo.dart';
import 'package:todo_app/domain/usecases/delete_todo.dart';
import 'package:todo_app/domain/usecases/edit_todo.dart';
import 'package:todo_app/domain/usecases/toggle_todo.dart';
import 'package:todo_app/viewmodels/todo_viewmodel.dart';
import 'package:todo_app/data/todo_repository.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('addTodo adds a new todo', () async {
    final repository = TodoRepository();
    final viewModel = TodoViewModel(
      repository,
      AddTodoUseCase(repository),
      ToggleTodoUseCase(repository),
      DeleteTodoUseCase(repository),
      ChangePriorityUseCase(repository),
      EditTodoUseCase(repository),
    );

    await viewModel.addTodo('Test task');

    expect(viewModel.todos.length, 1);
    expect(viewModel.todos.first.title, 'Test task');
  });

  test('filter active todos', () async {
    final repository = TodoRepository();
    final viewModel = TodoViewModel(
      repository,
      AddTodoUseCase(repository),
      ToggleTodoUseCase(repository),
      DeleteTodoUseCase(repository),
      ChangePriorityUseCase(repository),
      EditTodoUseCase(repository),
    );

    await viewModel.addTodo('Task 1');
  });

  test('filter active todos', () async {
    final repository = TodoRepository();
    final viewModel = TodoViewModel(
      repository,
      AddTodoUseCase(repository),
      ToggleTodoUseCase(repository),
      DeleteTodoUseCase(repository),
      ChangePriorityUseCase(repository),
      EditTodoUseCase(repository),
    );

    await viewModel.addTodo('Task 1');
    await viewModel.addTodo('Task 2');

    await viewModel.toggleTodo(viewModel.todos.first);

    viewModel.setFilter(TodoFilter.active);

    expect(viewModel.filteredTodos.length, 1);
  });

  test('search filter todos', () async {
    final repository = TodoRepository();
    final viewModel = TodoViewModel(
      repository,
      AddTodoUseCase(repository),
      ToggleTodoUseCase(repository),
      DeleteTodoUseCase(repository),
      ChangePriorityUseCase(repository),
      EditTodoUseCase(repository),
    );

    await viewModel.addTodo('Buy milk');
    await viewModel.addTodo('Do homework');

    viewModel.setSearchQuery('milk');

    expect(viewModel.filteredTodos.length, 1);
    expect(viewModel.filteredTodos.first.title, 'Buy milk');
  });
}
