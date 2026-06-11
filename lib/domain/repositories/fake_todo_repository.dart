import 'package:todo_app/domain/repositories/i_todo_repository.dart';
import 'package:todo_app/models/todo.dart';

class FakeTodoRepository implements ITodoRepository {
  Todo? updatedTodo;

  @override
  Future<void> updateTodo(Todo todo) async {
    updatedTodo = todo;
  }

  @override
  Future<int> addTodo(Todo todo) async {
    return 1;
  }

  @override
  Future<void> deleteTodo(int id) async {}

  @override
  Future<List<Todo>> getTodos() async {
    return [];
  }
}
