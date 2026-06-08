enum Priority { low, medium, high }

class Todo {
  final int? id;
  final String title;
  bool isDone;
  Priority priority;

  Todo({
    this.id,
    required this.title,
    required this.isDone,
    required this.priority,
  });

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] == 1,
      priority: map['priority'] != null
          ? Priority.values[map['priority']]
          : Priority.medium,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0,
      'priority': priority.index,
    };
  }
}
