import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/presentation/home/home_screen.dart';
import 'package:gerenciamento_sol/providers.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  // Lógica de inicialização silenciosa
  final container = ProviderContainer();
  final database = container.read(databaseProvider);

  final categorias = await database.select(database.categorias).get();
  if (categorias.isEmpty) {
    // Se o banco não tiver categorias, ele as insere na primeira vez.
    final categoriasIniciais = [
      'Hidratantes', 'Perfumes', 'Maquiagens',
      'Sabonetes', 'Infantil', 'Outros'
    ];
    for (final nomeCategoria in categoriasIniciais) {
      await database.into(database.categorias).insert(CategoriasCompanion.insert(nome: nomeCategoria));
    }
  }

  runApp(ProviderScope(
    parent: container,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento Sol',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5A67D8),
          background: const Color(0xFFF8F9FA),
          surface: Colors.white,
        ),
        useMaterial3: true,
        // ... O resto do seu tema ...
      ),
      home: const HomePage(),
    );
  }
}