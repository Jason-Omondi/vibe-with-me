import 'package:drift/drift.dart';

class Vocabulary extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get word => text()();
  TextColumn get definition => text()();
  TextColumn get exampleSentence => text()();
  BoolColumn get mastered => boolean().withDefault(const Constant(false))();
}
