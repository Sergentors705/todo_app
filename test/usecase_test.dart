import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/domain/repositories/fake_todo_repository.dart';
import 'package:todo_app/domain/usecases/add_todo.dart';
import 'package:todo_app/domain/usecases/change_priority_todo.dart';
import 'package:todo_app/domain/usecases/delete_todo.dart';
import 'package:todo_app/domain/usecases/edit_todo.dart';
import 'package:todo_app/domain/usecases/toggle_todo.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/viewmodels/todo_viewmodel.dart';

void main() {
  test('change priority medium -> high', () async {
    final repository = FakeTodoRepository();
    final useCase = ChangePriorityUseCase(repository);
    final todo = Todo(
      id: 1,
      title: 'Test',
      isDone: false,
      priority: Priority.medium,
    );

    final result = await useCase(todo);

    expect(result.priority, Priority.high);
    expect(repository.updatedTodo?.priority, Priority.high);
  });
}
