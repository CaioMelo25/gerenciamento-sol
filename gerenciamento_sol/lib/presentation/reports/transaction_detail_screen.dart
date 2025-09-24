import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package.gerenciamento_sol/presentation/transactions/add_transaction_screen.dart';
import 'package.gerenciamento_sol/providers.dart';
import 'package.intl/intl.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final int categoriaId;
  final String categoriaNome;

  const TransactionDetailScreen({
    super.key,
    required this.categoriaId,
    required this.categoriaNome,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedYear = ref.watch(selectedYearProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final database = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoriaNome),
      ),
      body: StreamBuilder<List<Lancamento>>(
        stream: database.watchLancamentosPorCategoria(selectedYear, selectedMonth, categoriaId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final lancamentos = snapshot.data ?? [];
          if (lancamentos.isEmpty) {
            return const Center(child: Text('Nenhum lançamento nesta categoria para o mês.'));
          }

          final formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
          final formatadorData = DateFormat('dd/MM/yyyy');

          return ListView.builder(
            itemCount: lancamentos.length,
            itemBuilder: (context, index) {
              final lancamento = lancamentos[index];
              final isVenda = lancamento.tipo == 'venda';
              final cor = isVenda ? Colors.green : Colors.red;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: Icon(isVenda ? Icons.arrow_upward : Icons.arrow_downward, color: cor),
                  title: Text(
                    formatadorMoeda.format(lancamento.valor),
                    style: TextStyle(fontWeight: FontWeight.bold, color: cor),
                  ),
                  subtitle: Text(formatadorData.format(lancamento.data)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botão de Editar
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddTransactionScreen(lancamentoParaEditar: lancamento),
                            ),
                          );
                        },
                      ),
                      // Botão de Excluir
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                        onPressed: () => _confirmarExclusao(context, database, lancamento.id),
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