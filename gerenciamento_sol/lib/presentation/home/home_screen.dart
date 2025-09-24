// lib/presentation/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/presentation/reports/reports_screen.dart';
import 'package:gerenciamento_sol/presentation/transactions/add_transaction_screen.dart';
import 'package:gerenciamento_sol/providers.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget { // MUDANÇA: Agora é um ConsumerWidget
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // MUDANÇA: Adiciona WidgetRef
    final database = ref.watch(databaseProvider);

    // AGORA, o ano e mês vêm dos providers, permitindo que a UI os altere!
    final selectedYear = ref.watch(selectedYearProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle Financeiro', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ReportsScreen()),
              );
            },
            tooltip: 'Relatórios',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<DashboardData>(
        // O stream agora usa o ano e mês selecionados nos filtros!
        stream: database.watchDashboardData(selectedYear, selectedMonth),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum dado encontrado.'));
          }

          final data = snapshot.data!;
          final formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Gerencie suas entradas e gastos de forma simples',
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              const SizedBox(height: 24),

              // Card dos Filtros agora é um widget separado e interativo
              _FilterCard(),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _DashboardCard(
                      title: 'Entradas',
                      value: formatadorMoeda.format(data.totalVendas),
                      icon: Icons.trending_up,
                      iconColor: const Color(0xFF16A34A),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _DashboardCard(
                      title: 'Gastos',
                      value: formatadorMoeda.format(data.totalCompras),
                      icon: Icons.trending_down,
                      iconColor: const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _DashboardCard(
                title: 'Saldo Total',
                value: formatadorMoeda.format(data.saldoDoMes),
                icon: Icons.account_balance_wallet_outlined,
                iconColor: Theme.of(context).colorScheme.secondary,
                isTotal: true,
              ),
            ],
          );
        },
      ),
    );
  }
}

// WIDGET DOS FILTROS
class _FilterCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anosDisponiveis = ref.watch(anosProvider);
    final selectedYear = ref.watch(selectedYearProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);

    final meses = { 1: 'Janeiro', 2: 'Fevereiro', 3: 'Março', 4: 'Abril', 5: 'Maio', 6: 'Junho', 7: 'Julho', 8: 'Agosto', 9: 'Setembro', 10: 'Outubro', 11: 'Novembro', 12: 'Dezembro' };

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Dropdown de Ano
            anosDisponiveis.when(
              data: (anos) => DropdownButton<int>(
                value: anos.contains(selectedYear) ? selectedYear : anos.firstOrNull,
                underline: const SizedBox(),
                items: anos.map((ano) => DropdownMenuItem(value: ano, child: Text(ano.toString()))).toList(),
                onChanged: (novoAno) {
                  if (novoAno != null) {
                    ref.read(selectedYearProvider.notifier).state = novoAno;
                  }
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => const Text('Erro'),
            ),

            // Dropdown de Mês
            DropdownButton<int>(
              value: selectedMonth,
              underline: const SizedBox(),
              items: meses.entries.map((mes) => DropdownMenuItem(value: mes.key, child: Text(mes.value))).toList(),
              onChanged: (novoMes) {
                if (novoMes != null) {
                  ref.read(selectedMonthProvider.notifier).state = novoMes;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET DOS CARDS (agora sem estado)
class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final bool isTotal;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.titleMedium?.copyWith(
      color: Theme.of(context).colorScheme.secondary,
    );
    final valueStyle = (isTotal ? textTheme.headlineMedium : textTheme.headlineSmall)
        ?.copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: titleStyle),
                Icon(icon, color: iconColor),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: valueStyle),
          ],
        ),
      ),
    );
  }
}