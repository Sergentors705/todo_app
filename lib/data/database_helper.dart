import 'dart:ffi';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_app/models/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
  CREATE TABLE todos(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  isDone INTEGER DEFAULT 0
  )''');
      },
    );
  }
}

Future<void> insertTodo(Database db, String title) async {
  await db.insert('todos', {'title': title, 'isDone': 0});
}

Future<List<Todo>> getTodos(Database db) async {
  final result = await db.query('todos');

  return result.map((map) => Todo.fromMap(map)).toList();
}
