// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $VocabularyTable extends Vocabulary
    with TableInfo<$VocabularyTable, VocabularyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _definitionMeta = const VerificationMeta(
    'definition',
  );
  @override
  late final GeneratedColumn<String> definition = GeneratedColumn<String>(
    'definition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exampleSentenceMeta = const VerificationMeta(
    'exampleSentence',
  );
  @override
  late final GeneratedColumn<String> exampleSentence = GeneratedColumn<String>(
    'example_sentence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _masteredMeta = const VerificationMeta(
    'mastered',
  );
  @override
  late final GeneratedColumn<bool> mastered = GeneratedColumn<bool>(
    'mastered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mastered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    word,
    definition,
    exampleSentence,
    mastered,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularyData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('definition')) {
      context.handle(
        _definitionMeta,
        definition.isAcceptableOrUnknown(data['definition']!, _definitionMeta),
      );
    } else if (isInserting) {
      context.missing(_definitionMeta);
    }
    if (data.containsKey('example_sentence')) {
      context.handle(
        _exampleSentenceMeta,
        exampleSentence.isAcceptableOrUnknown(
          data['example_sentence']!,
          _exampleSentenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exampleSentenceMeta);
    }
    if (data.containsKey('mastered')) {
      context.handle(
        _masteredMeta,
        mastered.isAcceptableOrUnknown(data['mastered']!, _masteredMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabularyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      definition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}definition'],
      )!,
      exampleSentence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_sentence'],
      )!,
      mastered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mastered'],
      )!,
    );
  }

  @override
  $VocabularyTable createAlias(String alias) {
    return $VocabularyTable(attachedDatabase, alias);
  }
}

class VocabularyData extends DataClass implements Insertable<VocabularyData> {
  final int id;
  final String word;
  final String definition;
  final String exampleSentence;
  final bool mastered;
  const VocabularyData({
    required this.id,
    required this.word,
    required this.definition,
    required this.exampleSentence,
    required this.mastered,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word'] = Variable<String>(word);
    map['definition'] = Variable<String>(definition);
    map['example_sentence'] = Variable<String>(exampleSentence);
    map['mastered'] = Variable<bool>(mastered);
    return map;
  }

  VocabularyCompanion toCompanion(bool nullToAbsent) {
    return VocabularyCompanion(
      id: Value(id),
      word: Value(word),
      definition: Value(definition),
      exampleSentence: Value(exampleSentence),
      mastered: Value(mastered),
    );
  }

  factory VocabularyData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyData(
      id: serializer.fromJson<int>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      definition: serializer.fromJson<String>(json['definition']),
      exampleSentence: serializer.fromJson<String>(json['exampleSentence']),
      mastered: serializer.fromJson<bool>(json['mastered']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'word': serializer.toJson<String>(word),
      'definition': serializer.toJson<String>(definition),
      'exampleSentence': serializer.toJson<String>(exampleSentence),
      'mastered': serializer.toJson<bool>(mastered),
    };
  }

  VocabularyData copyWith({
    int? id,
    String? word,
    String? definition,
    String? exampleSentence,
    bool? mastered,
  }) => VocabularyData(
    id: id ?? this.id,
    word: word ?? this.word,
    definition: definition ?? this.definition,
    exampleSentence: exampleSentence ?? this.exampleSentence,
    mastered: mastered ?? this.mastered,
  );
  VocabularyData copyWithCompanion(VocabularyCompanion data) {
    return VocabularyData(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      definition: data.definition.present
          ? data.definition.value
          : this.definition,
      exampleSentence: data.exampleSentence.present
          ? data.exampleSentence.value
          : this.exampleSentence,
      mastered: data.mastered.present ? data.mastered.value : this.mastered,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyData(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('definition: $definition, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('mastered: $mastered')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, word, definition, exampleSentence, mastered);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyData &&
          other.id == this.id &&
          other.word == this.word &&
          other.definition == this.definition &&
          other.exampleSentence == this.exampleSentence &&
          other.mastered == this.mastered);
}

class VocabularyCompanion extends UpdateCompanion<VocabularyData> {
  final Value<int> id;
  final Value<String> word;
  final Value<String> definition;
  final Value<String> exampleSentence;
  final Value<bool> mastered;
  const VocabularyCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.definition = const Value.absent(),
    this.exampleSentence = const Value.absent(),
    this.mastered = const Value.absent(),
  });
  VocabularyCompanion.insert({
    this.id = const Value.absent(),
    required String word,
    required String definition,
    required String exampleSentence,
    this.mastered = const Value.absent(),
  }) : word = Value(word),
       definition = Value(definition),
       exampleSentence = Value(exampleSentence);
  static Insertable<VocabularyData> custom({
    Expression<int>? id,
    Expression<String>? word,
    Expression<String>? definition,
    Expression<String>? exampleSentence,
    Expression<bool>? mastered,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (definition != null) 'definition': definition,
      if (exampleSentence != null) 'example_sentence': exampleSentence,
      if (mastered != null) 'mastered': mastered,
    });
  }

  VocabularyCompanion copyWith({
    Value<int>? id,
    Value<String>? word,
    Value<String>? definition,
    Value<String>? exampleSentence,
    Value<bool>? mastered,
  }) {
    return VocabularyCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      definition: definition ?? this.definition,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      mastered: mastered ?? this.mastered,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (definition.present) {
      map['definition'] = Variable<String>(definition.value);
    }
    if (exampleSentence.present) {
      map['example_sentence'] = Variable<String>(exampleSentence.value);
    }
    if (mastered.present) {
      map['mastered'] = Variable<bool>(mastered.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('definition: $definition, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('mastered: $mastered')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $VocabularyTable vocabulary = $VocabularyTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [vocabulary];
}

typedef $$VocabularyTableCreateCompanionBuilder =
    VocabularyCompanion Function({
      Value<int> id,
      required String word,
      required String definition,
      required String exampleSentence,
      Value<bool> mastered,
    });
typedef $$VocabularyTableUpdateCompanionBuilder =
    VocabularyCompanion Function({
      Value<int> id,
      Value<String> word,
      Value<String> definition,
      Value<String> exampleSentence,
      Value<bool> mastered,
    });

class $$VocabularyTableFilterComposer
    extends Composer<_$AppDb, $VocabularyTable> {
  $$VocabularyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get definition => $composableBuilder(
    column: $table.definition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleSentence => $composableBuilder(
    column: $table.exampleSentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mastered => $composableBuilder(
    column: $table.mastered,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VocabularyTableOrderingComposer
    extends Composer<_$AppDb, $VocabularyTable> {
  $$VocabularyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get definition => $composableBuilder(
    column: $table.definition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleSentence => $composableBuilder(
    column: $table.exampleSentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mastered => $composableBuilder(
    column: $table.mastered,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VocabularyTableAnnotationComposer
    extends Composer<_$AppDb, $VocabularyTable> {
  $$VocabularyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get definition => $composableBuilder(
    column: $table.definition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleSentence => $composableBuilder(
    column: $table.exampleSentence,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mastered =>
      $composableBuilder(column: $table.mastered, builder: (column) => column);
}

class $$VocabularyTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $VocabularyTable,
          VocabularyData,
          $$VocabularyTableFilterComposer,
          $$VocabularyTableOrderingComposer,
          $$VocabularyTableAnnotationComposer,
          $$VocabularyTableCreateCompanionBuilder,
          $$VocabularyTableUpdateCompanionBuilder,
          (
            VocabularyData,
            BaseReferences<_$AppDb, $VocabularyTable, VocabularyData>,
          ),
          VocabularyData,
          PrefetchHooks Function()
        > {
  $$VocabularyTableTableManager(_$AppDb db, $VocabularyTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabularyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabularyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabularyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<String> definition = const Value.absent(),
                Value<String> exampleSentence = const Value.absent(),
                Value<bool> mastered = const Value.absent(),
              }) => VocabularyCompanion(
                id: id,
                word: word,
                definition: definition,
                exampleSentence: exampleSentence,
                mastered: mastered,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String word,
                required String definition,
                required String exampleSentence,
                Value<bool> mastered = const Value.absent(),
              }) => VocabularyCompanion.insert(
                id: id,
                word: word,
                definition: definition,
                exampleSentence: exampleSentence,
                mastered: mastered,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VocabularyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $VocabularyTable,
      VocabularyData,
      $$VocabularyTableFilterComposer,
      $$VocabularyTableOrderingComposer,
      $$VocabularyTableAnnotationComposer,
      $$VocabularyTableCreateCompanionBuilder,
      $$VocabularyTableUpdateCompanionBuilder,
      (
        VocabularyData,
        BaseReferences<_$AppDb, $VocabularyTable, VocabularyData>,
      ),
      VocabularyData,
      PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$VocabularyTableTableManager get vocabulary =>
      $$VocabularyTableTableManager(_db, _db.vocabulary);
}
