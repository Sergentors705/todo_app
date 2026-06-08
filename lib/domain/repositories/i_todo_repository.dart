import 'package:todo_app/models/todo.dart';

abstract class ITodoRepository {
  Future<List<Todo>> getTodos();

  Future<int> addTodo(Todo todo);

  Future<void> updateTodo(Todo todo);

  Future<void> deleteTodo(int id);
}
