import 'package:get_it/get_it.dart';

import 'repositories/vocabulary_repository.dart';

GetIt locator = GetIt.instance;

void setUp() {
  locator.registerLazySingleton(() => VocabularyRepository());
}
