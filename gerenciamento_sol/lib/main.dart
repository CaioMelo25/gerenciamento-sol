import 'package:flutter/material.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/presentation/home/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
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