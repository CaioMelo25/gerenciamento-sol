import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class SaldoCategoriaResult {
  final String nomeCategoria;
  final double saldo;

  SaldoCategoriaResult({required this.nomeCategoria, required this.saldo});

  @override
  String toString() {
    return 'SaldoCategoriaResult(nome: $nomeCategoria, saldo: ${saldo.toStringAsFixed(2)})';
  }
}

class _LancamentoComCategoria {
  final String categoriaNome;
  final String tipo;
  final double valor;
  _LancamentoComCategoria({required this.categoriaNome, required this.tipo, required this.valor});
}

class Categorias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text().withLength(min: 1, max: 50)();
}

@DataClassName('Lancamento')
class Lancamentos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoriaId => integer().references(Categorias, #id)();
  DateTimeColumn get data => dateTime()();
  RealColumn get valor => real()();
  TextColumn get tipo => text().withLength(min: 1, max: 10)();
}

@DriftDatabase(tables: [Categorias, Lancamentos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  Future<void> onCreate(Migrator m) async {
    await m.createAll();

    final categoriasIniciais = [
      'Hidratantes', 'Perfumes', 'Maquiagens',
      'Sabonetes', 'Infantil', 'Outros'
    ];

    for (final nomeCategoria in categoriasIniciais) {
      await into(categorias).insert(CategoriasCompanion.insert(nome: nomeCategoria));
    }
  }

  Future<void> adicionarLancamento(LancamentosCompanion entrada) {
    return into(lancamentos).insert(entrada);
  }

  Future<void> limparLancamentos() {
    return delete(lancamentos).go();
  }

  Future<double> _getTotalPorTipo(int ano, int mes, String tipo) async {
    final totalExp = lancamentos.valor.sum();
    final query = selectOnly(lancamentos)
      ..addColumns([totalExp])
      ..where(lancamentos.tipo.equals(tipo))
      ..where(lancamentos.data.year.equals(ano))
      ..where(lancamentos.data.month.equals(mes));
    final result = await query.getSingle();
    return result?.read(totalExp) ?? 0.0;
  }

  Future<double> getTotalVendas(int ano, int mes) => _getTotalPorTipo(ano, mes, 'venda');
  Future<double> getTotalCompras(int ano, int mes) => _getTotalPorTipo(ano, mes, 'compra');

  Future<double> getSaldoDoMes(int ano, int mes) async {
    final totalVendas = await getTotalVendas(ano, mes);
    final totalCompras = await getTotalCompras(ano, mes);
    return totalVendas - totalCompras;
  }

  Future<List<SaldoCategoriaResult>> getSaldoPorCategoria(int ano, int mes) async {
    final todasCategorias = await select(categorias).get();
    final mapaDeCategorias = { for (var c in todasCategorias) c.id: c.nome };
    final queryLancamentos = select(lancamentos)
      ..where((tbl) => tbl.data.year.equals(ano))
      ..where((tbl) => tbl.data.month.equals(mes));
    final listaDeLancamentos = await queryLancamentos.get();
    final saldos = <String, double>{};
    for (final lancamento in listaDeLancamentos) {
      final nomeCategoria = mapaDeCategorias[lancamento.categoriaId];
      if (nomeCategoria != null) {
        final valorComSinal = lancamento.tipo == 'venda' ? lancamento.valor : -lancamento.valor;
        saldos[nomeCategoria] = (saldos[nomeCategoria] ?? 0) + valorComSinal;
      }
    }
    return saldos.entries.map((e) => SaldoCategoriaResult(nomeCategoria: e.key, saldo: e.value)).toList();
  }

  Future<DashboardData> getDashboardData(int ano, int mes) async {
  final vendas = await getTotalVendas(ano, mes);
  final compras = await getTotalCompras(ano, mes);
  final saldo = await getSaldoDoMes(ano, mes);

  return DashboardData(
    totalVendas: vendas,
    totalCompras: compras,
    saldoDoMes: saldo,
  );
}

Stream<DashboardData> watchDashboardData(int ano, int mes) {
  final streamDeMudancas = select(lancamentos).watch();

  return streamDeMudancas.asyncMap((_) => getDashboardData(ano, mes));
}

Stream<List<SaldoCategoriaResult>> watchSaldoPorCategoria(int ano, int mes) {
  return select(lancamentos).watch().asyncMap((_) => getSaldoPorCategoria(ano, mes));
}

Future<List<int>> getAnosComLancamentos() async {
  final query = selectOnly(lancamentos, distinct: true)
    ..addColumns([lancamentos.data.year]);

  final anos = await query.map((row) => row.read(lancamentos.data.year)!).get();
  anos.sort((a, b) => b.compareTo(a));
  return anos;
}

Future<int> deletarLancamento(int id) {
  return (delete(lancamentos)..where((tbl) => tbl.id.equals(id))).go();
}

Future<bool> atualizarLancamento(LancamentosCompanion entrada) {
  return update(lancamentos).replace(entrada);
}

Stream<List<Lancamento>> watchLancamentosPorCategoria(int ano, int mes, int categoriaId) {
  final query = select(lancamentos)
    ..where((tbl) => tbl.data.year.equals(ano))
    ..where((tbl) => tbl.data.month.equals(mes))
    ..where((tbl) => tbl.categoriaId.equals(categoriaId))
    ..orderBy([(tbl) => OrderingTerm.desc(tbl.data)]);

  return query.watch();
}

}


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

class DashboardData {
  final double totalVendas;
  final double totalCompras;
  final double saldoDoMes;

  DashboardData({
    required this.totalVendas,
    required this.totalCompras,
    required this.saldoDoMes,
  });
}
