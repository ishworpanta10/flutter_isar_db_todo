import 'package:flutter/material.dart';
import 'package:flutter_isar_databse/models/todo_model.dart';
import 'package:flutter_isar_databse/services/isar_services.dart';

import 'add_todo_page.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({
    Key? key,
    required this.isarService,
  }) : super(key: key);

  final IsarService isarService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Center(
        child: StreamBuilder<List<TodoModel>>(
          stream: isarService.listenToTodos(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final List<TodoModel> todos = snapshot.data;
              return TodoListView(todos: todos, isarService: isarService);
            } else if (snapshot.hasError) {
              return const Icon(Icons.error_outline);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditTodoPage(isarService: isarService),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoListView extends StatelessWidget {
  const TodoListView({
    Key? key,
    required this.todos,
    required this.isarService,
  }) : super(key: key);

  final List<TodoModel> todos;
  final IsarService isarService;

  @override
  Widget build(BuildContext context) {
    return todos.isEmpty
        ? const Text('Empty Todo List')
        : ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final TodoModel todo = todos[index];
              return TodoWidget(todo: todo, isarService: isarService);
            },
          );
  }
}

class TodoWidget extends StatelessWidget {
  const TodoWidget({
    Key? key,
    required this.todo,
    required this.isarService,
  }) : super(key: key);

  final TodoModel todo;
  final IsarService isarService;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todo.title ?? '',
        style: TextStyle(
          decoration: todo.done ?? false ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      subtitle: Text(
        todo.description ?? '',
        style: TextStyle(
          decoration: todo.done ?? false ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      trailing: Checkbox(
        value: todo.done ?? false,
        onChanged: (value) async {
          await isarService.updateTodo(
            TodoModel()
              ..id = todo.id
              ..title = todo.title
              ..description = todo.description
              ..createdAt = todo.createdAt
              ..done = value
              ..updatedAt = DateTime.now(),
          );
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditTodoPage(
              isarService: IsarService(),
              todo: todo,
            ),
          ),
        );
      },
    );
  }
}
