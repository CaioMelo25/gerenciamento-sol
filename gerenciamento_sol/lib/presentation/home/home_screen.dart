import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/presentation/history/history_screen.dart';
import 'package:gerenciamento_sol/presentation/reports/reports_screen.dart';
import 'package:gerenciamento_sol/presentation/transactions/add_transaction_screen.dart';
import 'package:gerenciamento_sol/providers.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart'; // Import necessário para o gráfico

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);
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
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
            tooltip: 'Histórico Completo',
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
              const _FilterCard(),
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
              const SizedBox(height: 24),

             LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 700) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(child: _GastosPieChartCard()),
                        SizedBox(width: 16),
                        Expanded(child: _VendasPieChartCard()),
                      ],
                    );
                  } else {
                    return Column(
                      children: const [
                        _GastosPieChartCard(),
                        SizedBox(height: 16),
                        _VendasPieChartCard(),
                      ],
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterCard extends ConsumerWidget {
  const _FilterCard();
  
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
              loading: () => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
              error: (e, st) => const Text('Erro'),
            ),
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
      color: isTotal ? Theme.of(context).colorScheme.primary : iconColor,
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
            
            FittedBox(
              fit: BoxFit.scaleDown, 
              child: Text(value, style: valueStyle),
            ),
          ],
        ),
      ),
    );
  }
}

class _GastosPieChartCard extends ConsumerWidget {
  const _GastosPieChartCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gastosProvider = ref.watch(gastosPorCategoriaProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gastos por Categoria",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            gastosProvider.when(
              data: (gastos) {
                if (gastos.isEmpty) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: Text("Nenhum gasto neste mês para exibir no gráfico.")),
                  );
                }
                
                final List<Color> chartColors = [ Colors.red.shade400, Colors.orange.shade400, Colors.amber.shade400, Colors.yellow.shade800, Colors.lime.shade700 ];
                
                double totalGastos = gastos.fold(0, (sum, item) => sum + item.total);
                List<PieChartSectionData> sections = gastos.asMap().entries.map((entry) {
                  int index = entry.key;
                  TransacaoPorCategoriaResult item = entry.value; // MUDANÇA AQUI
                  final percentage = (item.total / totalGastos) * 100;
                  
                  return PieChartSectionData(
                    color: chartColors[index % chartColors.length],
                    value: item.total,
                    title: '${percentage.toStringAsFixed(0)}%',
                    radius: 60,
                    titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 2)]),
                  );
                }).toList();

                return SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(sections: sections, sectionsSpace: 2, centerSpaceRadius: 30),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _Legend(transacoes: gastos, chartColors: chartColors), // MUDANÇA AQUI
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(height: 150, child: Center(child: CircularProgressIndicator())),
              error: (err, stack) => const SizedBox(height: 150, child: Center(child: Text("Erro ao carregar gráfico"))),
            ),
          ],
        ),
      ),
    );
  }
}

class _VendasPieChartCard extends ConsumerWidget {
  const _VendasPieChartCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendasProvider = ref.watch(vendasPorCategoriaProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Entradas por Categoria", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            vendasProvider.when(
              data: (vendas) {
                if (vendas.isEmpty) {
                  return const SizedBox(height: 150, child: Center(child: Text("Nenhuma entrada neste mês.")));
                }
                
                final List<Color> chartColors = [Colors.green.shade400, Colors.teal.shade400, Colors.cyan.shade400, Colors.lightGreen.shade400, Colors.blue.shade400];
                
                double totalVendas = vendas.fold(0, (sum, item) => sum + item.total);
                List<PieChartSectionData> sections = vendas.asMap().entries.map((entry) {
                  int index = entry.key;
                  TransacaoPorCategoriaResult item = entry.value;
                  final percentage = (item.total / totalVendas) * 100;
                  
                  return PieChartSectionData(
                    color: chartColors[index % chartColors.length],
                    value: item.total,
                    title: '${percentage.toStringAsFixed(0)}%',
                    radius: 60,
                    titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 2)]),
                  );
                }).toList();

                return SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      Expanded(child: PieChart(PieChartData(sections: sections, sectionsSpace: 2, centerSpaceRadius: 30))),
                      const SizedBox(width: 24),
                      Expanded(child: _Legend(transacoes: vendas, chartColors: chartColors)),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(height: 150, child: Center(child: CircularProgressIndicator())),
              error: (err, stack) => const SizedBox(height: 150, child: Center(child: Text("Erro ao carregar gráfico"))),
            ),
          ],
        ),
      ),
    );
  }
}


class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(width: 12, height: 12, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final List<TransacaoPorCategoriaResult> transacoes;   
  final List<Color> chartColors;

  const _Legend({required this.transacoes, required this.chartColors}); 

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: transacoes.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _LegendItem(
          color: chartColors[index % chartColors.length],
          text: item.nomeCategoria,
        );
      }).toList(),
    );
  }
}