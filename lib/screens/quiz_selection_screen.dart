import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/vocabulary_provider.dart';
import 'quiz_screen.dart';

class QuizSelectionScreen extends StatelessWidget {
  const QuizSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Practice & Quiz',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<VocabularyProvider>(
        builder: (context, provider, child) {
          final categories = provider.getCategories();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Practice Modes Section
                const Text(
                  'Practice Modes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _buildModeCard(
                  context,
                  title: 'Flashcards',
                  description: 'Review words with interactive flashcards',
                  icon: Icons.flip_to_front,
                  color: Colors.blue,
                  onTap: () => _showCategoryDialog(context, 'flashcard'),
                ),

                const SizedBox(height: 12),

                _buildModeCard(
                  context,
                  title: 'Multiple Choice Quiz',
                  description:
                      'Test your knowledge with multiple choice questions',
                  icon: Icons.quiz,
                  color: Colors.green,
                  onTap: () => _showCategoryDialog(context, 'multiple_choice'),
                ),

                const SizedBox(height: 32),

                // Quick Practice Section
                const Text(
                  'Quick Practice',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _buildQuickPracticeCard(
                  context,
                  title: 'Review All Words',
                  subtitle: '${provider.vocabularyList.length} words',
                  icon: Icons.library_books,
                  onTap: () => _startQuiz(context, 'flashcard', null),
                ),

                const SizedBox(height: 12),

                _buildQuickPracticeCard(
                  context,
                  title: 'Practice Unmastered',
                  subtitle:
                      '${provider.vocabularyList.where((v) => !v.mastered).length} words',
                  icon: Icons.school,
                  onTap: () {
                    provider.setMasteredFilter(false);
                    _startQuiz(context, 'flashcard', null);
                  },
                ),

                const SizedBox(height: 32),

                // Categories Section
                if (categories.isNotEmpty) ...[
                  const Text(
                    'Practice by Category',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  ...categories.map((category) {
                    final categoryCount = provider.vocabularyList
                        .where((vocab) => vocab.category == category)
                        .length;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildCategoryCard(
                        context,
                        category: category,
                        count: categoryCount,
                      ),
                    );
                  }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickPracticeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade100,
          child: Icon(icon, color: Colors.indigo),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.play_arrow),
        onTap: onTap,
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String category,
    required int count,
  }) {
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(category).withOpacity(0.2),
          child: Icon(
            _getCategoryIcon(category),
            color: _getCategoryColor(category),
          ),
        ),
        title: Text(category),
        subtitle: Text('$count words'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _startQuiz(context, 'flashcard', category),
                  icon: const Icon(Icons.flip_to_front),
                  label: const Text('Flashcards'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      _startQuiz(context, 'multiple_choice', category),
                  icon: const Icon(Icons.quiz),
                  label: const Text('Quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Academic':
        return Colors.purple;
      case 'Business':
        return Colors.orange;
      case 'Technology':
        return Colors.green;
      case 'Science':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return Icons.school;
      case 'Business':
        return Icons.business;
      case 'Technology':
        return Icons.computer;
      case 'Science':
        return Icons.science;
      default:
        return Icons.category;
    }
  }

  void _showCategoryDialog(BuildContext context, String quizType) {
    final provider = context.read<VocabularyProvider>();
    final categories = provider.getCategories();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: const Text('All Categories'),
              onTap: () {
                Navigator.pop(context);
                _startQuiz(context, quizType, null);
              },
            ),
            const Divider(),
            ...categories.map(
              (category) => ListTile(
                leading: Icon(_getCategoryIcon(category)),
                title: Text(category),
                onTap: () {
                  Navigator.pop(context);
                  _startQuiz(context, quizType, category);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _startQuiz(BuildContext context, String quizType, String? category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QuizScreen(quizType: quizType, category: category),
      ),
    );
  }
}
