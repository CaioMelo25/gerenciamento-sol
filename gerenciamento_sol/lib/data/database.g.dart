// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, Categoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nome];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(Insertable<Categoria> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Categoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Categoria(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }
}

class Categoria extends DataClass implements Insertable<Categoria> {
  final int id;
  final String nome;
  const Categoria({required this.id, required this.nome});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nome: Value(nome),
    );
  }

  factory Categoria.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Categoria(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
    };
  }

  Categoria copyWith({int? id, String? nome}) => Categoria(
        id: id ?? this.id,
        nome: nome ?? this.nome,
      );
  Categoria copyWithCompanion(CategoriasCompanion data) {
    return Categoria(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Categoria(')
          ..write('id: $id, ')
          ..write('nome: $nome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Categoria && other.id == this.id && other.nome == this.nome);
}

class CategoriasCompanion extends UpdateCompanion<Categoria> {
  final Value<int> id;
  final Value<String> nome;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
  });
  CategoriasCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
  }) : nome = Value(nome);
  static Insertable<Categoria> custom({
    Expression<int>? id,
    Expression<String>? nome,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
    });
  }

  CategoriasCompanion copyWith({Value<int>? id, Value<String>? nome}) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome')
          ..write(')'))
        .toString();
  }
}

class $LancamentosTable extends Lancamentos
    with TableInfo<$LancamentosTable, Lancamento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LancamentosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoriaIdMeta =
      const VerificationMeta('categoriaId');
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
      'categoria_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categorias (id)'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
      'data', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
      'valor', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, categoriaId, data, valor, tipo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lancamentos';
  @override
  VerificationContext validateIntegrity(Insertable<Lancamento> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
          _categoriaIdMeta,
          categoriaId.isAcceptableOrUnknown(
              data['categoria_id']!, _categoriaIdMeta));
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
          _valorMeta, valor.isAcceptableOrUnknown(data['valor']!, _valorMeta));
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lancamento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lancamento(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoriaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}categoria_id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data'])!,
      valor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}valor'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
    );
  }

  @override
  $LancamentosTable createAlias(String alias) {
    return $LancamentosTable(attachedDatabase, alias);
  }
}

class Lancamento extends DataClass implements Insertable<Lancamento> {
  final int id;
  final int categoriaId;
  final DateTime data;
  final double valor;
  final String tipo;
  const Lancamento(
      {required this.id,
      required this.categoriaId,
      required this.data,
      required this.valor,
      required this.tipo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['categoria_id'] = Variable<int>(categoriaId);
    map['data'] = Variable<DateTime>(data);
    map['valor'] = Variable<double>(valor);
    map['tipo'] = Variable<String>(tipo);
    return map;
  }

  LancamentosCompanion toCompanion(bool nullToAbsent) {
    return LancamentosCompanion(
      id: Value(id),
      categoriaId: Value(categoriaId),
      data: Value(data),
      valor: Value(valor),
      tipo: Value(tipo),
    );
  }

  factory Lancamento.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lancamento(
      id: serializer.fromJson<int>(json['id']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
      data: serializer.fromJson<DateTime>(json['data']),
      valor: serializer.fromJson<double>(json['valor']),
      tipo: serializer.fromJson<String>(json['tipo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoriaId': serializer.toJson<int>(categoriaId),
      'data': serializer.toJson<DateTime>(data),
      'valor': serializer.toJson<double>(valor),
      'tipo': serializer.toJson<String>(tipo),
    };
  }

  Lancamento copyWith(
          {int? id,
          int? categoriaId,
          DateTime? data,
          double? valor,
          String? tipo}) =>
      Lancamento(
        id: id ?? this.id,
        categoriaId: categoriaId ?? this.categoriaId,
        data: data ?? this.data,
        valor: valor ?? this.valor,
        tipo: tipo ?? this.tipo,
      );
  Lancamento copyWithCompanion(LancamentosCompanion data) {
    return Lancamento(
      id: data.id.present ? data.id.value : this.id,
      categoriaId:
          data.categoriaId.present ? data.categoriaId.value : this.categoriaId,
      data: data.data.present ? data.data.value : this.data,
      valor: data.valor.present ? data.valor.value : this.valor,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lancamento(')
          ..write('id: $id, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('data: $data, ')
          ..write('valor: $valor, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoriaId, data, valor, tipo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lancamento &&
          other.id == this.id &&
          other.categoriaId == this.categoriaId &&
          other.data == this.data &&
          other.valor == this.valor &&
          other.tipo == this.tipo);
}

class LancamentosCompanion extends UpdateCompanion<Lancamento> {
  final Value<int> id;
  final Value<int> categoriaId;
  final Value<DateTime> data;
  final Value<double> valor;
  final Value<String> tipo;
  const LancamentosCompanion({
    this.id = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.data = const Value.absent(),
    this.valor = const Value.absent(),
    this.tipo = const Value.absent(),
  });
  LancamentosCompanion.insert({
    this.id = const Value.absent(),
    required int categoriaId,
    required DateTime data,
    required double valor,
    required String tipo,
  })  : categoriaId = Value(categoriaId),
        data = Value(data),
        valor = Value(valor),
        tipo = Value(tipo);
  static Insertable<Lancamento> custom({
    Expression<int>? id,
    Expression<int>? categoriaId,
    Expression<DateTime>? data,
    Expression<double>? valor,
    Expression<String>? tipo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (data != null) 'data': data,
      if (valor != null) 'valor': valor,
      if (tipo != null) 'tipo': tipo,
    });
  }

  LancamentosCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoriaId,
      Value<DateTime>? data,
      Value<double>? valor,
      Value<String>? tipo}) {
    return LancamentosCompanion(
      id: id ?? this.id,
      categoriaId: categoriaId ?? this.categoriaId,
      data: data ?? this.data,
      valor: valor ?? this.valor,
      tipo: tipo ?? this.tipo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LancamentosCompanion(')
          ..write('id: $id, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('data: $data, ')
          ..write('valor: $valor, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $LancamentosTable lancamentos = $LancamentosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [categorias, lancamentos];
}

typedef $$CategoriasTableCreateCompanionBuilder = CategoriasCompanion Function({
  Value<int> id,
  required String nome,
});
typedef $$CategoriasTableUpdateCompanionBuilder = CategoriasCompanion Function({
  Value<int> id,
  Value<String> nome,
});

final class $$CategoriasTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriasTable, Categoria> {
  $$CategoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LancamentosTable, List<Lancamento>>
      _lancamentosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.lancamentos,
              aliasName: $_aliasNameGenerator(
                  db.categorias.id, db.lancamentos.categoriaId));

  $$LancamentosTableProcessedTableManager get lancamentosRefs {
    final manager = $$LancamentosTableTableManager($_db, $_db.lancamentos)
        .filter((f) => f.categoriaId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_lancamentosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriasTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  Expression<bool> lancamentosRefs(
      Expression<bool> Function($$LancamentosTableFilterComposer f) f) {
    final $$LancamentosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lancamentos,
        getReferencedColumn: (t) => t.categoriaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LancamentosTableFilterComposer(
              $db: $db,
              $table: $db.lancamentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  Expression<T> lancamentosRefs<T extends Object>(
      Expression<T> Function($$LancamentosTableAnnotationComposer a) f) {
    final $$LancamentosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lancamentos,
        getReferencedColumn: (t) => t.categoriaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LancamentosTableAnnotationComposer(
              $db: $db,
              $table: $db.lancamentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriasTable,
    Categoria,
    $$CategoriasTableFilterComposer,
    $$CategoriasTableOrderingComposer,
    $$CategoriasTableAnnotationComposer,
    $$CategoriasTableCreateCompanionBuilder,
    $$CategoriasTableUpdateCompanionBuilder,
    (Categoria, $$CategoriasTableReferences),
    Categoria,
    PrefetchHooks Function({bool lancamentosRefs})> {
  $$CategoriasTableTableManager(_$AppDatabase db, $CategoriasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
          }) =>
              CategoriasCompanion(
            id: id,
            nome: nome,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
          }) =>
              CategoriasCompanion.insert(
            id: id,
            nome: nome,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriasTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({lancamentosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (lancamentosRefs) db.lancamentos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lancamentosRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CategoriasTableReferences
                            ._lancamentosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriasTableReferences(db, table, p0)
                                .lancamentosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoriaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriasTable,
    Categoria,
    $$CategoriasTableFilterComposer,
    $$CategoriasTableOrderingComposer,
    $$CategoriasTableAnnotationComposer,
    $$CategoriasTableCreateCompanionBuilder,
    $$CategoriasTableUpdateCompanionBuilder,
    (Categoria, $$CategoriasTableReferences),
    Categoria,
    PrefetchHooks Function({bool lancamentosRefs})>;
typedef $$LancamentosTableCreateCompanionBuilder = LancamentosCompanion
    Function({
  Value<int> id,
  required int categoriaId,
  required DateTime data,
  required double valor,
  required String tipo,
});
typedef $$LancamentosTableUpdateCompanionBuilder = LancamentosCompanion
    Function({
  Value<int> id,
  Value<int> categoriaId,
  Value<DateTime> data,
  Value<double> valor,
  Value<String> tipo,
});

final class $$LancamentosTableReferences
    extends BaseReferences<_$AppDatabase, $LancamentosTable, Lancamento> {
  $$LancamentosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias(
          $_aliasNameGenerator(db.lancamentos.categoriaId, db.categorias.id));

  $$CategoriasTableProcessedTableManager? get categoriaId {
    if ($_item.categoriaId == null) return null;
    final manager = $$CategoriasTableTableManager($_db, $_db.categorias)
        .filter((f) => f.id($_item.categoriaId!));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LancamentosTableFilterComposer
    extends Composer<_$AppDatabase, $LancamentosTable> {
  $$LancamentosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valor => $composableBuilder(
      column: $table.valor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoriaId,
        referencedTable: $db.categorias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriasTableFilterComposer(
              $db: $db,
              $table: $db.categorias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LancamentosTableOrderingComposer
    extends Composer<_$AppDatabase, $LancamentosTable> {
  $$LancamentosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valor => $composableBuilder(
      column: $table.valor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoriaId,
        referencedTable: $db.categorias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriasTableOrderingComposer(
              $db: $db,
              $table: $db.categorias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LancamentosTableAnnotationComposer
    extends Composer<_$AppDatabase, $LancamentosTable> {
  $$LancamentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoriaId,
        referencedTable: $db.categorias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriasTableAnnotationComposer(
              $db: $db,
              $table: $db.categorias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LancamentosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LancamentosTable,
    Lancamento,
    $$LancamentosTableFilterComposer,
    $$LancamentosTableOrderingComposer,
    $$LancamentosTableAnnotationComposer,
    $$LancamentosTableCreateCompanionBuilder,
    $$LancamentosTableUpdateCompanionBuilder,
    (Lancamento, $$LancamentosTableReferences),
    Lancamento,
    PrefetchHooks Function({bool categoriaId})> {
  $$LancamentosTableTableManager(_$AppDatabase db, $LancamentosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LancamentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LancamentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LancamentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoriaId = const Value.absent(),
            Value<DateTime> data = const Value.absent(),
            Value<double> valor = const Value.absent(),
            Value<String> tipo = const Value.absent(),
          }) =>
              LancamentosCompanion(
            id: id,
            categoriaId: categoriaId,
            data: data,
            valor: valor,
            tipo: tipo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoriaId,
            required DateTime data,
            required double valor,
            required String tipo,
          }) =>
              LancamentosCompanion.insert(
            id: id,
            categoriaId: categoriaId,
            data: data,
            valor: valor,
            tipo: tipo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LancamentosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({categoriaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoriaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoriaId,
                    referencedTable:
                        $$LancamentosTableReferences._categoriaIdTable(db),
                    referencedColumn:
                        $$LancamentosTableReferences._categoriaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LancamentosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LancamentosTable,
    Lancamento,
    $$LancamentosTableFilterComposer,
    $$LancamentosTableOrderingComposer,
    $$LancamentosTableAnnotationComposer,
    $$LancamentosTableCreateCompanionBuilder,
    $$LancamentosTableUpdateCompanionBuilder,
    (Lancamento, $$LancamentosTableReferences),
    Lancamento,
    PrefetchHooks Function({bool categoriaId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$LancamentosTableTableManager get lancamentos =>
      $$LancamentosTableTableManager(_db, _db.lancamentos);
}
