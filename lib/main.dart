import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/todo_repository.dart';
import 'package:todo_app/domain/usecases/add_todo.dart';
import 'package:todo_app/domain/usecases/change_priority_todo.dart';
import 'package:todo_app/domain/usecases/delete_todo.dart';
import 'package:todo_app/domain/usecases/edit_todo.dart';
import 'package:todo_app/domain/usecases/toggle_todo.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/viewmodels/todo_viewmodel.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => TodoRepository()),
        Provider(
          create: (context) => AddTodoUseCase(context.read<TodoRepository>()),
        ),
        Provider(
          create: (context) =>
              ToggleTodoUseCase(context.read<TodoRepository>()),
        ),
        Provider(
          create: (context) =>
              DeleteTodoUseCase(context.read<TodoRepository>()),
        ),
        Provider(
          create: (context) =>
              ChangePriorityUseCase(context.read<TodoRepository>()),
        ),
        Provider(
          create: (context) => EditTodoUseCase(context.read<TodoRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoViewModel(
            context.read<TodoRepository>(),
            context.read<AddTodoUseCase>(),
            context.read<ToggleTodoUseCase>(),
            context.read<DeleteTodoUseCase>(),
            context.read<ChangePriorityUseCase>(),
            context.read<EditTodoUseCase>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Todo App'),
    );
  }
}
