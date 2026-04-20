import 'package:flutter/material.dart';
import 'package:todo_app/data/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/todo_repository.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/viewmodels/todo_viewmodel.dart';

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
          TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'New task'),
          ),
          Expanded(
            child: todos.isEmpty
                ? Center(
                    child: Text(
                      'No tasks',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];

                      return Dismissible(
                        key: ValueKey(todo.id),
                        direction: DismissDirection.endToStart,
                        resizeDuration: Duration(milliseconds: 300),

                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          viewModel.deleteTodoWithUndo(todo);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Task deleted'),
                              action: SnackBarAction(
                                label: 'Cancel',
                                onPressed: () {
                                  viewModel.undoDelete();
                                },
                              ),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        },
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween(
                                  begin: Offset(0, 0.2),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: ListTile(
                            title: AnimatedDefaultTextStyle(
                              duration: Duration(milliseconds: 300),
                              style: TextStyle(
                                decoration: todo.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: todo.isDone ? Colors.grey : Colors.black,
                              ),
                              child: Text(todo.title),
                            ),
                            trailing: AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: Checkbox(
                                value: todo.isDone,
                                onChanged: (_) {
                                  viewModel.toggleTodo(todo);
                                },
                              ),
                            ),
                            onTap: () => viewModel.toggleTodo(todo),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.addTodo(controller.text);
              controller.clear();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
