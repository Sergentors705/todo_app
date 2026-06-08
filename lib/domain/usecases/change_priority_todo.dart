import 'package:todo_app/domain/repositories/i_todo_repository.dart';
import 'package:todo_app/models/todo.dart';

class ChangePriorityUseCase {
  final ITodoRepository repository;

  ChangePriorityUseCase(this.repository);

  Future<void> call(Todo todo) async {
    switch (todo.priority) {
      case Priority.low:
        todo.priority = Priority.medium;
        break;
      case Priority.medium:
        todo.priority = Priority.high;
        break;
      case Priority.high:
        todo.priority = Priority.low;
        break;
    }

    await repository.updateTodo(todo);
  }
}
