import 'package:flutter/material.dart';
import 'package:isar_todo_app/services/database_service.dart';
import 'package:isar_todo_app/view/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  //Flutter ı hazırla
  WidgetsFlutterBinding.ensureInitialized();
  //Veritabanımızı başlattık
  await DatabaseService.initialize();
  //widetları çiz
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseService>(
          create: (context) => DatabaseService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
