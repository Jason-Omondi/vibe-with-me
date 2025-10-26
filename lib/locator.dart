import 'package:get_it/get_it.dart';

import 'database/app_db.dart';
import 'repositories/vocabulary_repository.dart';

GetIt locator = GetIt.instance;

void setUp() {
  // Register the database first
  locator.registerLazySingleton(() => AppDb());

  // Then register the repository
  locator.registerLazySingleton(() => VocabularyRepository());
}
