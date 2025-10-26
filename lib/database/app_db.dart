import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'db_tables.dart';

part 'app_db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() {
    return driftDatabase(name: 'db.sqlite');
  });
}

@DriftDatabase(tables: [Vocabulary, Categories, QuizResults])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Insert default categories
        await _insertDefaultCategories();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // For simplicity during development, recreate all tables
        if (to == 4) {
          // Drop and recreate all tables to ensure clean schema
          await m.deleteTable('vocabulary');
          await m.deleteTable('categories');
          await m.deleteTable('quiz_results');

          // Recreate all tables with new schema
          await m.createAll();

          // Insert default categories
          await _insertDefaultCategories();
        }
      },
    );
  }

  Future<void> _insertDefaultCategories() async {
    final now = DateTime.now();
    final defaultCategories = [
      CategoriesCompanion.insert(
        name: 'General',
        description: const Value('General vocabulary'),
        color: const Value('#2196F3'),
        createdAt: Value(now),
      ),
      CategoriesCompanion.insert(
        name: 'Academic',
        description: const Value('Academic and formal words'),
        color: const Value('#9C27B0'),
        createdAt: Value(now),
      ),
      CategoriesCompanion.insert(
        name: 'Business',
        description: const Value('Business and professional terms'),
        color: const Value('#FF9800'),
        createdAt: Value(now),
      ),
      CategoriesCompanion.insert(
        name: 'Technology',
        description: const Value('Technology and computing'),
        color: const Value('#4CAF50'),
        createdAt: Value(now),
      ),
      CategoriesCompanion.insert(
        name: 'Science',
        description: const Value('Scientific terminology'),
        color: const Value('#F44336'),
        createdAt: Value(now),
      ),
    ];

    for (final category in defaultCategories) {
      await into(categories).insertOnConflictUpdate(category);
    }
  }
}
