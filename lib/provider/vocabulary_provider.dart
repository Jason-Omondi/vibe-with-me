import 'package:flutter/material.dart';
import 'package:tubongeapp/repositories/vocabulary_repository.dart';

import '../database/app_db.dart';

class VocabularyProvider extends ChangeNotifier {
  final VocabularyRepository _vocabularyRepository = VocabularyRepository();
  List<VocabularyData> _vocabularyList = [];
  List<VocabularyData> get vocabularyList => _vocabularyList;

  Future<void> fetchVocabulary() async {
    _vocabularyList = await _vocabularyRepository.getAllVocabulary();
    notifyListeners();
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
}
