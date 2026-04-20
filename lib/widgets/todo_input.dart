import 'package:flutter/material.dart';

class TodoInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const TodoInput({super.key, required this.controller, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onSubmitted: (_) => onAdd(),
            decoration: InputDecoration(labelText: 'New task'),
          ),
        ),
        IconButton(icon: Icon(Icons.add), onPressed: onAdd),
      ],
    );
  }
}
