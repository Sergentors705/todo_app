import 'package:todo_app/domain/repositories/i_todo_repository.dart';
import 'package:todo_app/models/todo.dart';

class DeleteTodoUseCase {
  final ITodoRepository repository;

  DeleteTodoUseCase(this.repository);

  Future<void> call(Todo todo) async {
    await repository.deleteTodo(todo.id!);
  }
}
