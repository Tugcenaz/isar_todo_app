import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:isar_todo_app/models/todo_model.dart';
import 'package:path_provider/path_provider.dart';
//databaseservice sınıfına providerı dahil edicez bunun için de extend kullanıcaz

//sadece homescreen e bir provider eklersek home screen ve altındaki widgetlar görünümler bundan etkilenecek

class DatabaseService extends ChangeNotifier {
  //Isar başlatılsın
  static late Isar isar;

  static Future<void> initialize() async {
    final dir =
        await getApplicationDocumentsDirectory(); // veritabanını kaydedeceğimiz dosya
    isar = await Isar.open(
      [TodoSchema],
      directory: dir.path,
    );
  }

  //Görevler iiçin liste oluştur
  List<Todo> currentTodos = [];

  //Görev ekle
  Future<void> addTodo(String text) async {
    final newTodo = Todo()..text = text;
    await isar.writeTxn(() => isar.todos.put(newTodo));
    fetchTodos(); //liste elemanları buraya eklensin diye

  }

  //Görev getir
  Future<void> fetchTodos() async {
    currentTodos =
        await isar.todos.where().findAll(); //tüm todoları getirmek için
    notifyListeners(); //değişiklikleri bildirmek için provider paketinin kendine özgü set state methodu diyebiliriz
  }

  //Görev güncelle

  Future<void> updateTodo({required Todo todo}) async {
    final Todo? existingTodo = await isar.todos.get(todo.id);
    if (existingTodo != null) {
      existingTodo
        ..text = todo.text
        ..isDone = todo.isDone;
      await isar.writeTxn(() => isar.todos.put(existingTodo));
    }
    fetchTodos();
  }

  //Görev Sil
  Future<void> deleteTodo(int id) async {
    await isar.writeTxn(() => isar.todos.delete(id));

    fetchTodos();
  }
}
