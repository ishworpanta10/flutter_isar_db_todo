import 'package:isar/isar.dart';

part 'todo_model.g.dart';

@collection
class TodoModel {
  Id id = Isar.autoIncrement;
  String? title;
  String? description;
  bool? done;
  DateTime? createdAt;
  DateTime? updatedAt;
}
