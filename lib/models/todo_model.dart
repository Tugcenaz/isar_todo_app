import 'package:isar/isar.dart';

part 'todo_model.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement; // otomatik olarak artan bi id bizim elle artırmamız gerekmiyor
  String? text;

  DateTime dateTime = DateTime.now();
  bool isDone = false;
}
//bu kodu otomatik olarak isar koduna dönüştürcez => dart run build_runner build