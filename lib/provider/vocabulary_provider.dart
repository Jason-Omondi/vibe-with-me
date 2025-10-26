import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:tubongeapp/repositories/vocabulary_repository.dart';

import '../database/app_db.dart';

class VocabularyProvider extends ChangeNotifier {
  final VocabularyRepository _vocabularyRepository = VocabularyRepository();
  List<VocabularyData> _vocabularyList = [];
  List<VocabularyData> _filteredVocabularyList = [];

  // Search and Filter state
  String _searchQuery = '';
  String? _categoryFilter;
  bool? _masteredFilter;
  String _sortBy = 'word_asc';

  List<VocabularyData> get vocabularyList => _filteredVocabularyList;
  String get searchQuery => _searchQuery;
  String? get categoryFilter => _categoryFilter;
  bool? get masteredFilter => _masteredFilter;
  String get sortBy => _sortBy;

  Future<void> fetchVocabulary() async {
    _vocabularyList = await _vocabularyRepository.getAllVocabulary();
    _applyFiltersAndSort();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFiltersAndSort();
    notifyListeners();
  }

  void setCategoryFilter(String? category) {
    _categoryFilter = category;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void setMasteredFilter(bool? mastered) {
    _masteredFilter = mastered;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void _applyFiltersAndSort() {
    var filtered = List<VocabularyData>.from(_vocabularyList);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((vocab) {
        return vocab.word.toLowerCase().contains(_searchQuery) ||
            vocab.definition.toLowerCase().contains(_searchQuery) ||
            vocab.exampleSentence.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply category filter
    if (_categoryFilter != null) {
      filtered = filtered
          .where((vocab) => vocab.category == _categoryFilter)
          .toList();
    }

    // Apply mastered filter
    if (_masteredFilter != null) {
      filtered = filtered
          .where((vocab) => vocab.mastered == _masteredFilter)
          .toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'word_asc':
        filtered.sort((a, b) => a.word.compareTo(b.word));
        break;
      case 'word_desc':
        filtered.sort((a, b) => b.word.compareTo(a.word));
        break;
      case 'created_desc':
        filtered.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return b.createdAt!.compareTo(a.createdAt!);
        });
        break;
      case 'created_asc':
        filtered.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return a.createdAt!.compareTo(b.createdAt!);
        });
        break;
      case 'difficulty_asc':
        filtered.sort((a, b) => a.difficulty.compareTo(b.difficulty));
        break;
      case 'difficulty_desc':
        filtered.sort((a, b) => b.difficulty.compareTo(a.difficulty));
        break;
      case 'review_count_desc':
        filtered.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }

    _filteredVocabularyList = filtered;
  }

  List<String> getCategories() {
    final categories = _vocabularyList
        .map((vocab) => vocab.category)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  Map<String, dynamic> getStatistics() {
    final total = _vocabularyList.length;
    final mastered = _vocabularyList.where((vocab) => vocab.mastered).length;
    final learning = total - mastered;

    final categoryBreakdown = <String, int>{};
    for (final vocab in _vocabularyList) {
      categoryBreakdown[vocab.category] =
          (categoryBreakdown[vocab.category] ?? 0) + 1;
    }

    final masteryPercentage = total > 0 ? (mastered / total) * 100 : 0.0;

    // Calculate learning streak (simplified - would need more complex logic with dates)
    final currentStreak = _calculateCurrentStreak();
    final longestStreak = _calculateLongestStreak();

    return {
      'totalWords': total,
      'masteredWords': mastered,
      'learningWords': learning,
      'totalCategories': categoryBreakdown.length,
      'masteryPercentage': masteryPercentage,
      'categoryBreakdown': categoryBreakdown,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
    };
  }

  int _calculateCurrentStreak() {
    // Simplified streak calculation
    // In a real app, you'd track daily activity
    final recentlyReviewed = _vocabularyList
        .where(
          (vocab) =>
              vocab.lastReviewed != null &&
              DateTime.now().difference(vocab.lastReviewed!).inDays < 1,
        )
        .length;
    return recentlyReviewed;
  }

  int _calculateLongestStreak() {
    // Simplified - in real app, track historical data
    return _vocabularyList.fold(
      0,
      (max, vocab) => vocab.reviewCount > max ? vocab.reviewCount : max,
    );
  }

  //create new vocab
  Future<void> addVocabulary(VocabularyCompanion vocabulary) async {
    await _vocabularyRepository.insertVocabulary(vocabulary);
    await fetchVocabulary();
  }

  //update vocab
  Future<void> updateVocabulary(VocabularyCompanion vocabulary) async {
    await _vocabularyRepository.updateVocabulary(vocabulary);
    await fetchVocabulary();
  }

  //delete vocab
  Future<void> deleteVocabulary(int id) async {
    await _vocabularyRepository.deleteVocabulary(id);
    await fetchVocabulary();
  }

  //delete all vocab
  Future<void> deleteAllVocabulary() async {
    await _vocabularyRepository.deleteAllVocabulary();
    await fetchVocabulary();
  }

  // Mark vocabulary as reviewed
  Future<void> markAsReviewed(int id) async {
    final vocab = _vocabularyList.firstWhere((v) => v.id == id);
    final companion = VocabularyCompanion(
      id: Value(id),
      lastReviewed: Value(DateTime.now()),
      reviewCount: Value(vocab.reviewCount + 1),
    );
    await updateVocabulary(companion);
  }
}
