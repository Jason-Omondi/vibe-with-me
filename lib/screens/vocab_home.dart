import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/vocabulary_provider.dart';

class VocabHome extends StatelessWidget {
  const VocabHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vocabulary Home'), centerTitle: true),
      body: Consumer<VocabularyProvider>(
        builder: (context, provider, child) {
          if (provider.vocabularyList.isEmpty) {
            return const Center(
              child: Text(
                'No vocabularies added yet. Add some using the floating button!',
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.vocabularyList.length,
            itemBuilder: (context, index) {
              final vocabulary = provider.vocabularyList[index];
              return ListTile(
                title: Text(vocabulary.word),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Definition: ${vocabulary.definition}'),
                    Text('Example: ${vocabulary.exampleSentence}'),
                  ],
                ),
                trailing: Icon(
                  vocabulary.mastered
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: vocabulary.mastered ? Colors.green : Colors.grey,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-vocabulary');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
