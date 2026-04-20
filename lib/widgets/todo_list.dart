import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/widgets/todo_item.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final Function(Todo) onToggle;
  final Function(Todo) onDelete;

  const TodoList({
    super.key,
    required this.todos,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return Center(child: Text('No tasks'));
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItem(
          todo: todo,
          onToggle: () => onToggle(todo),
          onDelete: () => onDelete(todo),
        );
      },
    );
  }
}
