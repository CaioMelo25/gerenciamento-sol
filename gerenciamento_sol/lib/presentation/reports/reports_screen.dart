import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/providers.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedYear = ref.watch(selectedYearProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final opportunitiesAsync = ref.watch(opportunityProvider);

    final dateToFormat = DateTime(selectedYear, selectedMonth);
    final formatadorDeMes = DateFormat('MMMM de yyyy', 'pt_BR');
    final mesFormatado = formatadorDeMes.format(dateToFormat);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights de Investimento'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildDateNavigator(context, ref, selectedYear, selectedMonth, mesFormatado),

          const Divider(),

          Expanded(
            child: opportunitiesAsync.when(
              data: (opportunities) {
                if (opportunities.isEmpty) {
                  return const Center(child: Text('Nenhum dado processado ainda.'));
                }

                return ListView.builder(
                  itemCount: opportunities.length,
                  itemBuilder: (context, index) {
                    final item = opportunities[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(
                          item.nome,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Categoria: ${item.categoria}'),
                            const SizedBox(height: 8),
                            Text(
                              item.dica,
                              style: TextStyle(color: Colors.grey[700], fontSize: 13),
                            ),
                          ],
                        ),
                        trailing: _buildStatusBadge(item.status),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erro ao conectar ao Supabase: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateNavigator(BuildContext context, WidgetRef ref, int year, int month, String mesStr) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              var newDate = DateTime(year, month - 1);
              ref.read(selectedYearProvider.notifier).state = newDate.year;
              ref.read(selectedMonthProvider.notifier).state = newDate.month;
            },
          ),
          Text(
            '${mesStr[0].toUpperCase()}${mesStr.substring(1)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              var newDate = DateTime(year, month + 1);
              ref.read(selectedYearProvider.notifier).state = newDate.year;
              ref.read(selectedMonthProvider.notifier).state = newDate.month;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.blueGrey;
    IconData icon = Icons.info_outline;

    if (status == 'OPORTUNIDADE DE REPOSIÇÃO') {
      color = Colors.green;
      icon = Icons.shopping_cart_checkout;
    } else if (status == 'PRODUTO DE BAIXO GIRO') {
      color = Colors.orange;
      icon = Icons.warning_amber_rounded;
    } else if (status == 'ESTOQUE ATIVO') {
      color = Colors.blue;
      icon = Icons.check_circle_outline;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          status.split(' ').last,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ],
    );
  }
}