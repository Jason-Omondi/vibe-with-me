import 'package:drift/drift.dart';

class Vocabulary extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get word => text()();
  TextColumn get definition => text()();
  TextColumn get exampleSentence => text()();
  BoolColumn get mastered => boolean().withDefault(const Constant(false))();
  TextColumn get category => text().withDefault(const Constant('General'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get lastReviewed => dateTime().nullable()();
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();
  IntColumn get difficulty =>
      integer().withDefault(const Constant(1))(); // 1-5 scale
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get description => text().nullable()();
  TextColumn get color => text().withDefault(const Constant('#2196F3'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class QuizResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get quizDate => dateTime().nullable()();
  IntColumn get totalQuestions => integer()();
  IntColumn get correctAnswers => integer()();
  IntColumn get timeSpentMinutes => integer()();
  TextColumn get quizType => text()(); // 'flashcard', 'multiple_choice'
  TextColumn get category => text().nullable()();
}
