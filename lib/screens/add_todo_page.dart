import 'package:flutter/material.dart';
import 'package:flutter_isar_databse/models/todo_model.dart';

class AddTodoPage extends StatelessWidget {
  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  final TodoModel? todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo != null ? 'Update Todo' : 'Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: todo?.title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: todo?.description,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Done'),
                Flexible(
                  child: Switch(
                    value: todo?.done ?? false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text(todo != null ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}
