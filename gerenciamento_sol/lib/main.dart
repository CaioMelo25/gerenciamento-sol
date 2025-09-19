import 'package:flutter/material.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/presentation/home/home_screen.dart';

late final AppDatabase database;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  database = AppDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento Sol',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}