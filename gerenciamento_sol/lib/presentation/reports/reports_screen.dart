import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/providers.dart';
import 'package:gerenciamento_sol/presentation/reports/transaction_detail_screen.dart'; // Importe a tela de detalhes
import 'package:intl/intl.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedYear = ref.watch(selectedYearProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final database = ref.watch(databaseProvider);
    
    final dateToFormat = DateTime(selectedYear, selectedMonth);
    final formatadorDeMes = DateFormat('MMMM de yyyy', 'pt_BR');
    final mesFormatado = formatadorDeMes.format(dateToFormat);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório por Categoria'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    var newDate = DateTime(selectedYear, selectedMonth - 1);
                    ref.read(selectedYearProvider.notifier).state = newDate.year;
                    ref.read(selectedMonthProvider.notifier).state = newDate.month;
                  },
                ),
                Text(
                  '${mesFormatado[0].toUpperCase()}${mesFormatado.substring(1)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    var newDate = DateTime(selectedYear, selectedMonth + 1);
                    ref.read(selectedYearProvider.notifier).state = newDate.year;
                    ref.read(selectedMonthProvider.notifier).state = newDate.month;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<SaldoCategoriaResult>>(
              stream: database.watchSaldoPorCategoria(selectedYear, selectedMonth),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                final resultados = snapshot.data ?? [];
                if (resultados.isEmpty) {
                  return const Center(
                    child: Text('Nenhum lançamento encontrado para este mês.'),
                  );
                }
                
                resultados.sort((a, b) => b.saldo.compareTo(a.saldo));

                return ListView.builder(
                  itemCount: resultados.length,
                  itemBuilder: (context, index) {
                    final resultado = resultados[index];
                    final corDoSaldo = resultado.saldo >= 0 ? Colors.green : Colors.red;
                    final formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: Icon(
                          resultado.saldo >= 0 ? Icons.trending_up : Icons.trending_down,
                          color: corDoSaldo,
                        ),
                        title: Text(resultado.nomeCategoria),
                        trailing: Text(
                          formatadorMoeda.format(resultado.saldo),
                          style: TextStyle(
                            color: corDoSaldo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TransactionDetailScreen(
                                categoriaId: resultado.categoriaId,
                                categoriaNome: resultado.nomeCategoria,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}