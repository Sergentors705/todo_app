import 'package:todo_app/domain/repositories/i_todo_repository.dart';
import 'package:todo_app/models/todo.dart';

class ToggleTodoUseCase {
  final ITodoRepository repository;

  ToggleTodoUseCase(this.repository);

  Future<void> call(Todo todo) async {
    await repository.updateTodo(todo);
  }
}
