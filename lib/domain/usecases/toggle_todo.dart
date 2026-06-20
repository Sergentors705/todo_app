import 'package:todo_app/domain/repositories/i_todo_repository.dart';
import 'package:todo_app/models/todo.dart';

class ToggleTodoUseCase {
  final ITodoRepository repository;

  ToggleTodoUseCase(this.repository);

  Future<Todo> call(Todo todo) async {
    final updatedTodo = todo.copyWith(isDone: !todo.isDone);
    await repository.updateTodo(updatedTodo);
    return updatedTodo;
  }
}
