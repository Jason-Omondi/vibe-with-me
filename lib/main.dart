import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubongeapp/locator.dart';

import 'provider/vocabulary_provider.dart';
import 'screens/add_vocab_screen.dart';
import 'screens/vocab_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => VocabularyProvider())],
      child: MaterialApp(
        title: 'Tubonge App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const VocabHome(),
        routes: {
          '/vocab-home': (context) => const VocabHome(),
          '/add-vocabulary': (context) => const AddVocabScreen(),
        },
      ),
    );
  }
}
