import 'package:todo_app/domain/repositories/i_todo_repository.dart';
import 'package:todo_app/models/todo.dart';

class EditTodoUseCase {
  final ITodoRepository repository;
  EditTodoUseCase(this.repository);

  Future<Todo> call(Todo todo, String newTitle) async {
    if (newTitle.trim().isEmpty) throw Exception('Title is empty!');
    final updatedTodo = todo.copyWith(title: newTitle);

    await repository.updateTodo(updatedTodo);
    return updatedTodo;
  }
}
