import 'package:todo_app/domain/repositories/i_todo_repository.dart';
import 'package:todo_app/models/todo.dart';

class AddTodoUseCase {
  final ITodoRepository repository;

  AddTodoUseCase(this.repository);

  Future<int> call(String title) async {
    return await repository.addTodo(
      Todo(title: title, isDone: false, priority: Priority.medium),
    );
  }
}
