import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;

import '../database/app_db.dart';
import '../provider/vocabulary_provider.dart';
import 'add_vocab_screen.dart';

class VocabHome extends StatefulWidget {
  const VocabHome({super.key});

  @override
  State<VocabHome> createState() => _VocabHomeState();
}

class _VocabHomeState extends State<VocabHome> {
  @override
  void initState() {
    super.initState();
    // Fetch vocabulary when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VocabularyProvider>().fetchVocabulary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vocabulary Home',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          Consumer<VocabularyProvider>(
            builder: (context, provider, child) {
              if (provider.vocabularyList.isNotEmpty) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    if (value == 'delete_all') {
                      _showDeleteAllDialog();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete_all',
                      child: Row(
                        children: [
                          Icon(Icons.delete_sweep, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete All'),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<VocabularyProvider>(
        builder: (context, provider, child) {
          if (provider.vocabularyList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No vocabularies added yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first vocabulary word!',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchVocabulary(),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: provider.vocabularyList.length,
              itemBuilder: (context, index) {
                final vocabulary = provider.vocabularyList[index];
                return _buildVocabularyCard(vocabulary);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddScreen(),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVocabularyCard(VocabularyData vocabulary) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          vocabulary.word,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(vocabulary.definition, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              '"${vocabulary.exampleSentence}"',
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                vocabulary.mastered
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: vocabulary.mastered ? Colors.green : Colors.grey,
              ),
              onPressed: () => _toggleMastered(vocabulary),
              tooltip: vocabulary.mastered
                  ? 'Mark as not mastered'
                  : 'Mark as mastered',
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _navigateToEditScreen(vocabulary);
                    break;
                  case 'delete':
                    _showDeleteDialog(vocabulary);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddVocabScreen()),
    );
  }

  void _navigateToEditScreen(VocabularyData vocabulary) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVocabScreen(vocabulary: vocabulary),
      ),
    );
  }

  Future<void> _toggleMastered(VocabularyData vocabulary) async {
    final provider = context.read<VocabularyProvider>();
    final companion = VocabularyCompanion(
      id: Value(vocabulary.id),
      mastered: Value(!vocabulary.mastered),
    );
    await provider.updateVocabulary(companion);
  }

  void _showDeleteDialog(VocabularyData vocabulary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vocabulary'),
        content: Text('Are you sure you want to delete "${vocabulary.word}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<VocabularyProvider>().deleteVocabulary(
                vocabulary.id,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${vocabulary.word} deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Vocabulary'),
        content: const Text(
          'Are you sure you want to delete all vocabulary? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<VocabularyProvider>().deleteAllVocabulary();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All vocabulary deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
