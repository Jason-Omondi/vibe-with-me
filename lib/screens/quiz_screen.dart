import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'dart:math';
import '../database/app_db.dart';
import '../provider/vocabulary_provider.dart';

class QuizScreen extends StatefulWidget {
  final String quizType; // 'flashcard' or 'multiple_choice'
  final String? category;

  const QuizScreen({super.key, required this.quizType, this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<VocabularyData> _quizWords = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _showAnswer = false;
  bool _isAnswered = false;
  String? _selectedAnswer;
  List<String> _options = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  void _initializeQuiz() {
    final provider = context.read<VocabularyProvider>();
    var allWords = provider.vocabularyList;

    if (widget.category != null) {
      allWords = allWords
          .where((word) => word.category == widget.category)
          .toList();
    }

    // Shuffle and take up to 10 words for quiz
    allWords.shuffle(_random);
    _quizWords = allWords.take(10).toList();

    if (_quizWords.isNotEmpty) {
      _generateOptions();
    }
  }

  void _generateOptions() {
    if (widget.quizType == 'multiple_choice') {
      final currentWord = _quizWords[_currentIndex];
      final allWords = context.read<VocabularyProvider>().vocabularyList;

      // Get wrong answers
      var wrongAnswers = allWords
          .where((word) => word.id != currentWord.id)
          .map((word) => word.definition)
          .toList();
      wrongAnswers.shuffle(_random);

      _options = [currentWord.definition, ...wrongAnswers.take(3)];
      _options.shuffle(_random);
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _quizWords.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
        _isAnswered = false;
        _selectedAnswer = null;
      });
      _generateOptions();
    } else {
      _showResults();
    }
  }

  void _answerQuestion(String answer) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      _selectedAnswer = answer;

      if (answer == _quizWords[_currentIndex].definition) {
        _score++;
      }
    });

    // Mark as reviewed
    context.read<VocabularyProvider>().markAsReviewed(
      _quizWords[_currentIndex].id,
    );

    // Auto advance after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _nextQuestion();
    });
  }

  void _showResults() {
    final percentage = (_score / _quizWords.length * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              percentage >= 70 ? Icons.emoji_events : Icons.thumb_up,
              size: 64,
              color: percentage >= 70 ? Colors.amber : Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'Score: $_score/${_quizWords.length}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('$percentage%', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(_getEncouragementMessage(percentage)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close quiz screen
            },
            child: const Text('Finish'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _restartQuiz();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getEncouragementMessage(int percentage) {
    if (percentage >= 90) return 'Excellent! You\'re mastering these words!';
    if (percentage >= 70) return 'Great job! Keep up the good work!';
    if (percentage >= 50) return 'Good effort! Practice makes perfect!';
    return 'Don\'t give up! Review and try again!';
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _showAnswer = false;
      _isAnswered = false;
      _selectedAnswer = null;
    });
    _initializeQuiz();
  }

  @override
  Widget build(BuildContext context) {
    if (_quizWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          backgroundColor: Colors.indigo,
        ),
        body: const Center(
          child: Text(
            'No vocabulary available for quiz.\nAdd some words first!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.quizType == 'flashcard' ? 'Flashcard' : 'Quiz'} Mode',
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${_currentIndex + 1}/${_quizWords.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _quizWords.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
            ),

            const SizedBox(height: 32),

            // Score
            Text(
              'Score: $_score/${_currentIndex + (_isAnswered ? 1 : 0)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 32),

            // Question content
            if (widget.quizType == 'flashcard')
              _buildFlashcard()
            else
              _buildMultipleChoice(),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashcard() {
    final currentWord = _quizWords[_currentIndex];

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showAnswer = !_showAnswer;
              });
            },
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.indigo.shade400, Colors.indigo.shade600],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _showAnswer ? Icons.lightbulb : Icons.quiz,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _showAnswer ? currentWord.definition : currentWord.word,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_showAnswer) ...[
                        const SizedBox(height: 16),
                        Text(
                          '"${currentWord.exampleSentence}"',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          Text(
            _showAnswer ? 'Tap to see word' : 'Tap to see definition',
            style: TextStyle(color: Colors.grey[600]),
          ),

          const SizedBox(height: 32),

          if (_showAnswer) ...[
            const Text(
              'How well did you know this word?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDifficultyButton('Hard', Colors.red, 1),
                _buildDifficultyButton('Medium', Colors.orange, 2),
                _buildDifficultyButton('Easy', Colors.green, 3),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDifficultyButton(String label, Color color, int difficulty) {
    return ElevatedButton(
      onPressed: () {
        // Update difficulty and mark as reviewed
        final companion = VocabularyCompanion(
          id: Value(_quizWords[_currentIndex].id),
          difficulty: Value(difficulty),
          lastReviewed: Value(DateTime.now()),
          reviewCount: Value(_quizWords[_currentIndex].reviewCount + 1),
        );
        context.read<VocabularyProvider>().updateVocabulary(companion);

        _nextQuestion();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }

  Widget _buildMultipleChoice() {
    final currentWord = _quizWords[_currentIndex];

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'What does this word mean?',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.shade200),
            ),
            child: Text(
              currentWord.word,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),

          const SizedBox(height: 32),

          ...List.generate(_options.length, (index) {
            final option = _options[index];
            final isCorrect = option == currentWord.definition;
            final isSelected = _selectedAnswer == option;

            Color? backgroundColor;
            Color? textColor;

            if (_isAnswered) {
              if (isCorrect) {
                backgroundColor = Colors.green;
                textColor = Colors.white;
              } else if (isSelected) {
                backgroundColor = Colors.red;
                textColor = Colors.white;
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAnswered ? null : () => _answerQuestion(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor ?? Colors.grey.shade100,
                    foregroundColor: textColor ?? Colors.black87,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
