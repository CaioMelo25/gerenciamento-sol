import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/presentation/transactions/add_transaction_screen.dart';
import 'package:gerenciamento_sol/providers.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final DateTime _dataAtual = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);
    final formatadorDeMes = DateFormat('MMMM de yyyy', 'pt_BR');
    final mesAtualFormatado = formatadorDeMes.format(_dataAtual);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento Sol'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: StreamBuilder<DashboardData>(
      stream: database.watchDashboardData(_dataAtual.year, _dataAtual.month),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Nenhum dado para este mês.'));
        }

        final data = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo de ${mesAtualFormatado[0].toUpperCase()}${mesAtualFormatado.substring(1)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            _buildDashboardCard(
              context,
              title: 'Vendas no Mês',
              value: data.totalVendas,
              icon: Icons.arrow_upward,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildDashboardCard(
              context,
              title: 'Compras no Mês',
              value: data.totalCompras,
              icon: Icons.arrow_downward,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            _buildDashboardCard(
              context,
              title: 'Saldo do Mês',
              value: data.saldoDoMes,
              icon: Icons.account_balance_wallet_outlined,
              color: data.saldoDoMes >= 0 ? Colors.blue : Colors.orange,
            ),
          ],
        );
      },
    ),
  ),
);
}

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required double value,
    required IconData icon,
    required Color color,
  }) {
    final formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  formatadorMoeda.format(value),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}