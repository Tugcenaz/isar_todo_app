import 'package:flutter/material.dart';
import 'package:isar_todo_app/services/database_service.dart';
import 'package:provider/provider.dart';

import '../models/todo_model.dart';

//context.watch dinleme işlemi yapar
//context.read okuma işlemi yapar yani fonksiyonlara erişip kullanmayı sağlar
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Görev Uygulaması"),
      ),
      body: FutureBuilder(
          future: context.read<DatabaseService>().fetchTodos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Hata: ${snapshot.error}"),
              );
            } else {
              return Center(
                child: Column(
                  children: [
                    _addTodoWidget(
                      context,
                    ),
                    _todoListWidget(),
                  ],
                ),
              );
            }
          }),
    );
  }

  Widget _addTodoWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () async {
                  if (_textEditingController.text.isNotEmpty) {
                    await context
                        .read<DatabaseService>()
                        .addTodo(_textEditingController.text);
                    _textEditingController.clear();
                  }
                },
                icon: const Icon(Icons.add)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            isDense: true,
            hintText: "Bir şeyler yazın..."),
      ),
    );
  }

  Widget _todoListWidget() {
    /* final databaseService = context.watch<
        DatabaseService>(); //bu watch database servicete meydana gelen değişiklikleri dinliyor
*/
    return Expanded(
      child: Consumer<DatabaseService>(
        builder: (BuildContext context, databaseService, child) =>
            ListView.separated(
          itemCount: databaseService.currentTodos.length,
          itemBuilder: (BuildContext context, int index) {
            final Todo todo = databaseService.currentTodos[index];

            return Dismissible(
              onDismissed: (DismissDirection dismissedDirection) {
                databaseService.deleteTodo(todo.id);
              },
              key: Key(todo.id.toString()),
              child: ListTile(
                title: Text(todo.text!),
                tileColor: Colors.grey.shade100,
                trailing: Checkbox(
                    value: todo.isDone,
                    onChanged: (val) {
                      todo.isDone = val!;
                      databaseService.updateTodo(todo: todo);
                    }),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.blueGrey.shade100,
              height: 0,
            );
          },
        ),
      ),
    );
  }
}
