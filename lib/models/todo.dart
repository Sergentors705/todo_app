enum Priority { low, medium, high }

class Todo {
  final int? id;
  final String title;
  final bool isDone;
  final Priority priority;

  Todo({
    this.id,
    required this.title,
    required this.isDone,
    required this.priority,
  });

  Todo copyWith({int? id, String? title, bool? isDone, Priority? priority}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      priority: priority ?? this.priority,
    );
  }

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
