import 'package:todo_app/data/database_helper.dart';
import 'package:todo_app/models/todo.dart';

class TodoRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<List<Todo>> getTodos() async {
    final db = await dbHelper.database;
    final result = await db.query('todos');
    return result.map((e) => Todo.fromMap(e)).toList();
  }

  Future<int> addTodo(Todo todo) async {
    final db = await dbHelper.database;
    return await db.insert('todos', todo.toMap());
  }

  Future<void> updateTodo(int id, int isDone) async {
    final db = await dbHelper.database;

    await db.update(
      'todos',
      {'isDone': isDone},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTodo(int id) async {
    final db = await dbHelper.database;

    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
