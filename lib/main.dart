import 'package:flutter/material.dart';
import 'package:todo_app/data/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/todo_repository.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/viewmodels/todo_viewmodel.dart';
import 'package:todo_app/widgets/todo_input.dart';
import 'package:todo_app/widgets/todo_list.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoViewModel(TodoRepository()),
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TodoViewModel>().loadTodos();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoViewModel>();
    final todos = viewModel.todos;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          TodoInput(
            controller: controller,
            onAdd: () {
              viewModel.addTodo(controller.text);
              controller.clear();
            },
          ),

          Expanded(
            child: TodoList(
              todos: todos,
              onToggle: viewModel.toggleTodo,
              onDelete: (todo) {
                viewModel.deleteTodoWithUndo(todo);

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('Task deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: viewModel.undoDelete,
                      ),
                    ),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}
