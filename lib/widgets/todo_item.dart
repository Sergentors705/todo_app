import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/viewmodels/todo_viewmodel.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onChangePriority;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onChangePriority,
  });

  @override
  Widget build(BuildContext context) {
    // print('build item ${todo.id}');
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
        child: Consumer<TodoViewModel>(
          builder: (context, viewModel, _) {
            final todo = this.todo;
            return ListTile(
              onTap: onToggle,
              onLongPress: onChangePriority,
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
              subtitle: Text('Priority: ${todo.priority.name}'),
              trailing: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: Checkbox(
                  key: ValueKey(todo.isDone),
                  value: todo.isDone,
                  onChanged: (_) => onToggle(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
