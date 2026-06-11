import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/viewmodels/todo_viewmodel.dart';

enum TodoAction { edit, priority, delete }

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onChangePriority;
  final VoidCallback onEdit;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onChangePriority,
    required this.onEdit,
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
              leading: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: Checkbox(
                  key: ValueKey(todo.isDone),
                  value: todo.isDone,
                  onChanged: (_) => onToggle(),
                ),
              ),
              trailing: PopupMenuButton<TodoAction>(
                onSelected: (value) {
                  switch (value) {
                    case TodoAction.priority:
                      onChangePriority();
                      break;
                    case TodoAction.delete:
                      onDelete();
                      break;
                    case TodoAction.edit:
                      onEdit();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: TodoAction.edit,
                    child: Text('Edit title'),
                  ),
                  PopupMenuItem(
                    value: TodoAction.priority,
                    child: Text('Edit priority'),
                  ),
                  PopupMenuItem(
                    value: TodoAction.delete,
                    child: Text('Delete'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
