import 'package:flutter/material.dart';
import 'package:flutter_isar_databse/models/todo_model.dart';
import 'package:flutter_isar_databse/services/isar_services.dart';

class AddEditTodoPage extends StatefulWidget {
  const AddEditTodoPage({
    Key? key,
    this.todo,
    required this.isarService,
  }) : super(key: key);

  final TodoModel? todo;
  final IsarService isarService;

  @override
  State<AddEditTodoPage> createState() => _AddEditTodoPageState();
}

class _AddEditTodoPageState extends State<AddEditTodoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo?.title ?? '';
      _descriptionController.text = widget.todo?.description ?? '';
      _isDone = widget.todo?.done ?? false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleDeleteTodo() async {
    final popContext = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final isSuccess = await widget.isarService.deleteTodo(widget.todo!);
    if (isSuccess) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(' Todo deleted'),
        ),
      );

      popContext.pop();
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to delete todo'),
        ),
      );
    }
  }

  Future<void> _handleAddUpdateTodo() async {
    if (todoFormKey.currentState!.validate()) {
      todoFormKey.currentState!.save();

      final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
      final popContext = Navigator.of(context);

      try {
        if (widget.todo == null) {
          await widget.isarService.saveTodos(
            TodoModel()
              ..title = _titleController.text
              ..description = _descriptionController.text
              ..createdAt = DateTime.now()
              ..done = _isDone
              ..updatedAt = DateTime.now(),
          );
        } else {
          await widget.isarService.updateTodo(
            TodoModel()
              ..id = widget.todo!.id
              ..title = _titleController.text
              ..description = _descriptionController.text
              ..createdAt = widget.todo?.createdAt
              ..done = _isDone
              ..updatedAt = DateTime.now(),
          );
        }
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text("New Todo '${_titleController.text}' saved in DB")),
        );
        popContext.pop();
      } catch (err) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text("Something went wrong while saving Todo '${_titleController.text}'")),
        );
        debugPrint("Error :$err");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo != null ? 'Update Todo' : 'Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            TodoFormWidget(
              todo: widget.todo,
              titleController: _titleController,
              descriptionController: _descriptionController,
            ),
            TodoDoneSwitchWidget(
              isDone: _isDone,
              onChanged: (value) {
                setState(() {
                  _isDone = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (widget.todo != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleDeleteTodo,
                      child: const Text('Delete Todo'),
                    ),
                  ),
                if (widget.todo != null) const SizedBox(width: 40),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleAddUpdateTodo,
                    child: Text(widget.todo != null ? 'Update' : 'Add'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TodoDoneSwitchWidget extends StatefulWidget {
  const TodoDoneSwitchWidget({
    Key? key,
    required this.onChanged,
    this.isDone,
  }) : super(key: key);

  final ValueChanged<bool>? onChanged;
  final bool? isDone;

  @override
  State<TodoDoneSwitchWidget> createState() => _TodoDoneSwitchWidgetState();
}

class _TodoDoneSwitchWidgetState extends State<TodoDoneSwitchWidget> {
  bool? isCompleted;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      title: const Text('Completed'),
      value: isCompleted ?? widget.isDone ?? false,
      onChanged: (value) {
        setState(() {
          isCompleted = value;
        });
        widget.onChanged?.call(value);
      },
    );

    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     const Text('Completed'),
    //     Flexible(
    //       child: Switch(
    //         value: isCompleted ?? widget.isDone ?? false,
    //         onChanged: (value) {
    //           setState(() {
    //             isCompleted = value;
    //             widget.onChanged!(value);
    //           });
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}

final todoFormKey = GlobalKey<FormState>();

class TodoFormWidget extends StatelessWidget {
  const TodoFormWidget({
    Key? key,
    this.todo,
    required this.titleController,
    required this.descriptionController,
  }) : super(key: key);

  final TodoModel? todo;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: todoFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          TextFormField(
            // initialValue: todo?.title,
            autofocus: true,
            controller: titleController,
            textCapitalization: TextCapitalization.sentences,
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
            // initialValue: todo?.description,
            controller: descriptionController,
            textCapitalization: TextCapitalization.sentences,
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please enter some text';
            //   }
            //   return null;
            // },
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
