import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/presentation/transactions/add_transaction_screen.dart';
import 'package:gerenciamento_sol/providers.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico Completo'),
      ),
      body: StreamBuilder<List<LancamentoComCategoria>>(
        stream: database.watchTodosLancamentos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final lancamentos = snapshot.data ?? [];
          if (lancamentos.isEmpty) {
            return const Center(
              child: Text('Nenhum lançamento registrado ainda.'),
            );
          }

          final formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
          final formatadorData = DateFormat('dd/MM/yyyy');

          return ListView.builder(
            itemCount: lancamentos.length,
            itemBuilder: (context, index) {
              final item = lancamentos[index];
              final lancamento = item.lancamento;
              final categoria = item.categoria;
              
              final isVenda = lancamento.tipo == 'venda';
              final cor = isVenda ? Colors.green : Colors.red;

              // ===== A MUDANÇA ESTÁ AQUI: TROCAMOS O LISTTILE POR ESTE CARD CUSTOMIZADO =====
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Ícone da Esquerda
                      Icon(isVenda ? Icons.arrow_upward : Icons.arrow_downward, color: cor, size: 28),
                      const SizedBox(width: 12),

                      // Coluna Central que se expande para ocupar o espaço
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoria.nome,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis, // Evita quebra de linha se o nome for muito grande
                            ),
                            Text(
                              formatadorData.format(lancamento.data),
                              style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Coluna da Direita com valor e botões
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatadorMoeda.format(lancamento.valor),
                            style: TextStyle(color: cor, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Row(
                            children: [
                              IconButton(
                                constraints: const BoxConstraints(), // Remove padding extra
                                padding: const EdgeInsets.all(4),
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AddTransactionScreen(lancamentoParaEditar: lancamento),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                constraints: const BoxConstraints(), // Remove padding extra
                                padding: const EdgeInsets.all(4),
                                icon: Icon(Icons.delete_outline, size: 20, color: Theme.of(context).colorScheme.error),
                                onPressed: () => _confirmarExclusao(context, database, lancamento.id),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmarExclusao(BuildContext context, AppDatabase database, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem certeza que deseja apagar este lançamento?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Apagar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                database.deletarLancamento(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}