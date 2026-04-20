import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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

      onDismissed: (_) => onDelete(),

      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: ListTile(
          key: ValueKey(todo.id),
          title: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 300),
            style: TextStyle(
              decoration: todo.isDone ? TextDecoration.lineThrough : null,
              color: todo.isDone ? Colors.grey : Colors.black,
              fontSize: 16,
            ),
            child: Text(todo.title),
          ),
          trailing: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: Checkbox(
              key: ValueKey(todo.isDone),
              value: todo.isDone,
              onChanged: (_) => onToggle(),
            ),
          ),
        ),
      ),
    );
  }
}
