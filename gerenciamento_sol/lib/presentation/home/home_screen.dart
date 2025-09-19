import 'package:flutter/material.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Categorias Fixas')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text('Suas categorias de produtos:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Categoria>>(
                stream: database.select(database.categorias).watch(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final categorias = snapshot.data ?? [];
                  if (categorias.isEmpty) {
                    return const Center(child: Text('Nenhuma categoria encontrada.'));
                  }
                  return ListView.builder(
                    itemCount: categorias.length,
                    itemBuilder: (context, index) {
                      final categoria = categorias[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text(categoria.nome),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}