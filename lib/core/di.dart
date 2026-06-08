import 'package:todo_app/data/todo_repository.dart';
import 'package:todo_app/domain/usecases/add_todo.dart';
import 'package:todo_app/domain/usecases/change_priority_todo.dart';
import 'package:todo_app/domain/usecases/delete_todo.dart';
import 'package:todo_app/domain/usecases/toggle_todo.dart';
import 'package:todo_app/viewmodels/todo_viewmodel.dart';

class AppDI {
  static final repository = TodoRepository();

  static final addTodoUseCase = AddTodoUseCase(repository);
  static final toggleTodoUseCase = ToggleTodoUseCase(repository);
  static final deleteTodoUseCase = DeleteTodoUseCase(repository);
  static final changePriorityUseCase = ChangePriorityUseCase(repository);

  static final todoViewModel = TodoViewModel(
    repository,
    addTodoUseCase,
    toggleTodoUseCase,
    deleteTodoUseCase,
    changePriorityUseCase,
  );
}
