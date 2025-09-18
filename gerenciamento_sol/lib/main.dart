import 'package:flutter/material.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/presentation/home/home_screen.dart';


late final AppDatabase database;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  database = AppDatabase();

  final allCategories = await database.select(database.categorias).get();

  if (allCategories.isEmpty) {
    final categoriasIniciais = [
      'Hidratantes', 'Perfumes', 'Maquiagens',
      'Sabonetes', 'Infantil', 'Outros'
    ];

    await database.batch((batch) {
      batch.insertAll(
        database.categorias,
        categoriasIniciais.map(
          (nome) => CategoriasCompanion.insert(nome: nome)
        ).toList(),
      );
    });
  }
  
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento Sol',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

