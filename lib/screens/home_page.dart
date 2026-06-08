import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/viewmodels/todo_viewmodel.dart';
import 'package:todo_app/widgets/todo_input.dart';
import 'package:todo_app/widgets/todo_list.dart';

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
    final viewModel = context.read<TodoViewModel>();

    return Scaffold(
      body: Column(
        children: [
          TodoInput(
            controller: controller,
            onAdd: () {
              viewModel.addTodo(controller.text);
              controller.clear();
            },
          ),

          // FILTER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => viewModel.setFilter(TodoFilter.all),
                child: Text('All'),
              ),
              TextButton(
                onPressed: () => viewModel.setFilter(TodoFilter.active),
                child: Text('Active'),
              ),
              TextButton(
                onPressed: () => viewModel.setFilter(TodoFilter.completed),
                child: Text('Done'),
              ),
            ],
          ),

          // SEARCH
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                viewModel.setSearchQuery(value);
              },
            ),
          ),

          Expanded(
            child: Consumer<TodoViewModel>(
              builder: (context, viewModel, _) {
                return TodoList(
                  todos: viewModel.filteredTodos,
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
                            onPressed: () {
                              viewModel.undoDelete(todo.id!);
                            },
                          ),
                        ),
                      );
                  },
                  onChangePriority: viewModel.changePriorityTodo,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
