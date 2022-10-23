import 'package:isar/isar.dart';

import '../models/todo_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  /// Open Db and return the instance if it is not open else return open isar instance
  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [TodoModelSchema],
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  /// Clean the database
  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  /// get all todos from isar database from stream
  Stream<List<TodoModel>> listenToTodos() async* {
    final isar = await db;
    yield* isar.todoModels.where().watch(fireImmediately: true);
  }

  /// get all todos from isar database from future
  Future<List<TodoModel>> getTodoList() async {
    final isar = await db;
    return await isar.todoModels.where().findAll();
  }

  /// save todo to isar database
  Future<int> saveTodos(TodoModel newTodo) async {
    final isar = await db;
    return isar.writeTxnSync<int>(() => isar.todoModels.putSync(newTodo));
  }
}
