import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;

import '../database/app_db.dart';
import '../provider/vocabulary_provider.dart';

class AddVocabScreen extends StatefulWidget {
  final VocabularyData? vocabulary;

  const AddVocabScreen({super.key, this.vocabulary});

  @override
  State<AddVocabScreen> createState() => _AddVocabScreenState();
}

class _AddVocabScreenState extends State<AddVocabScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _wordController;
  late final TextEditingController _definitionController;
  late final TextEditingController _exampleController;
  String _selectedCategory = 'General';
  int _selectedDifficulty = 1;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(
      text: widget.vocabulary?.word ?? '',
    );
    _definitionController = TextEditingController(
      text: widget.vocabulary?.definition ?? '',
    );
    _exampleController = TextEditingController(
      text: widget.vocabulary?.exampleSentence ?? '',
    );
    _selectedCategory = widget.vocabulary?.category ?? 'General';
    _selectedDifficulty = widget.vocabulary?.difficulty ?? 1;
  }

  @override
  void dispose() {
    _wordController.dispose();
    _definitionController.dispose();
    _exampleController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.vocabulary != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Vocabulary' : 'Add Vocabulary',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextFormField(
                controller: _wordController,
                label: 'Word',
                hint: 'Enter the vocabulary word',
                helper: 'The main word to be added',
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _definitionController,
                label: 'Definition',
                hint: 'Enter the vocabulary definition',
                helper: 'The definition of the word',
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _exampleController,
                label: 'Example Sentence',
                hint: 'Enter an example sentence',
                helper: 'An example sentence using the vocabulary word',
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              Consumer<VocabularyProvider>(
                builder: (context, provider, child) {
                  final categories = [
                    'General',
                    'Academic',
                    'Business',
                    'Technology',
                    'Science',
                  ];
                  return DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      helperText: 'Choose a category for this vocabulary',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    items: categories
                        .map(
                          (category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value ?? 'General';
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // Difficulty Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Difficulty Level: $_selectedDifficulty',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _selectedDifficulty.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: Colors.indigo,
                    label: _getDifficultyLabel(_selectedDifficulty),
                    onChanged: (value) {
                      setState(() {
                        _selectedDifficulty = value.round();
                      });
                    },
                  ),
                  Text(
                    _getDifficultyDescription(_selectedDifficulty),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveVocabulary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _isEditing ? 'Update Vocabulary' : 'Add Vocabulary',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String helper,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helper,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a ${label.toLowerCase()}';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
    );
  }

  String _getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Very Easy';
      case 2:
        return 'Easy';
      case 3:
        return 'Medium';
      case 4:
        return 'Hard';
      case 5:
        return 'Very Hard';
      default:
        return 'Medium';
    }
  }

  String _getDifficultyDescription(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Simple, common words';
      case 2:
        return 'Everyday vocabulary';
      case 3:
        return 'Moderate complexity';
      case 4:
        return 'Advanced vocabulary';
      case 5:
        return 'Expert level words';
      default:
        return 'Moderate complexity';
    }
  }

  Future<void> _saveVocabulary() async {
    if (!_formKey.currentState!.validate()) return;

    final word = _wordController.text.trim();
    final definition = _definitionController.text.trim();
    final example = _exampleController.text.trim();

    try {
      final provider = context.read<VocabularyProvider>();

      if (_isEditing) {
        // Update existing vocabulary
        final companion = VocabularyCompanion(
          id: Value(widget.vocabulary!.id),
          word: Value(word),
          definition: Value(definition),
          exampleSentence: Value(example),
          category: Value(_selectedCategory),
          difficulty: Value(_selectedDifficulty),
        );
        await provider.updateVocabulary(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vocabulary updated successfully!')),
          );
        }
      } else {
        // Add new vocabulary
        final companion = VocabularyCompanion.insert(
          word: word,
          definition: definition,
          exampleSentence: example,
          category: Value(_selectedCategory),
          difficulty: Value(_selectedDifficulty),
          createdAt: Value(DateTime.now()),
        );
        await provider.addVocabulary(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vocabulary added successfully!')),
          );
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
