import 'package:todo_app/domain/repositories/i_todo_repository.dart';
import 'package:todo_app/models/todo.dart';

class ChangePriorityUseCase {
  final ITodoRepository repository;

  ChangePriorityUseCase(this.repository);

  Future<Todo> call(Todo todo) async {
    Todo updatedTodo;

    switch (todo.priority) {
      case Priority.low:
        updatedTodo = todo.copyWith(priority: Priority.medium);
        break;
      case Priority.medium:
        updatedTodo = todo.copyWith(priority: Priority.high);
        break;
      case Priority.high:
        updatedTodo = todo.copyWith(priority: Priority.low);
        break;
    }

    await repository.updateTodo(updatedTodo);
    return updatedTodo;
  }
}
