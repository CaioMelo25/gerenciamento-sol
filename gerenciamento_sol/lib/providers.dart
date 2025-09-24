import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/data/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final selectedYearProvider = StateProvider<int>((ref) => DateTime.now().year);
final selectedMonthProvider = StateProvider<int>((ref) => DateTime.now().month);

final anosProvider = FutureProvider<List<int>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.getAnosComLancamentos();
});

final gastosPorCategoriaProvider = StreamProvider<List<TransacaoPorCategoriaResult>>((ref) {
  final database = ref.watch(databaseProvider);
  final selectedYear = ref.watch(selectedYearProvider);
  final selectedMonth = ref.watch(selectedMonthProvider);
  return database.watchGastosPorCategoria(selectedYear, selectedMonth);
});

final vendasPorCategoriaProvider = StreamProvider<List<TransacaoPorCategoriaResult>>((ref) {
  final database = ref.watch(databaseProvider);
  final selectedYear = ref.watch(selectedYearProvider);
  final selectedMonth = ref.watch(selectedMonthProvider);
  return database.watchVendasPorCategoria(selectedYear, selectedMonth);
});