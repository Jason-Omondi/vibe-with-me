//import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart' hide log;

import 'dart:developer';
import 'package:tubongeapp/database/app_db.dart';
import 'package:tubongeapp/locator.dart';

class VocabularyRepository {
  AppDb db = locator.get<AppDb>();

  Future<List<VocabularyData>> getAllVocabulary() async {
    try {
      return await db.select(db.vocabulary).get();
    } catch (e) {
      //log error
      log('Error fetching vocabulary: $e');
      return [];
      //throw Exception('Error fetching vocabulary: $e');
    }
  }

  //get vocab by id
  Future<VocabularyData?> getVocabularyById(int id) async {
    try {
      return await (db.select(
        db.vocabulary,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    } catch (e) {
      //log error
      log('Error fetching vocabulary by id: $e');
      return null;
      //throw Exception('Error fetching vocabulary by id: $e');
    }
  }

  //insert new vocab
  Future<int> insertVocabulary(VocabularyCompanion vocabulary) async {
    try {
      return await db.into(db.vocabulary).insert(vocabulary);
    } catch (e) {
      //log error
      log('Error inserting vocabulary: $e');
      return -1;
      //throw Exception('Error inserting vocabulary: $e');
    }
  }

  //update vocab
  Future<bool> updateVocabulary(VocabularyCompanion vocabulary) async {
    try {
      return await db.update(db.vocabulary).replace(vocabulary);
    } catch (e) {
      //log error
      log('Error updating vocabulary: $e');
      return false;
      //throw Exception('Error updating vocabulary: $e');
    }
  }

  //delete vocab
  Future<int> deleteVocabulary(int id) async {
    try {
      return await (db.delete(
        db.vocabulary,
      )..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      //log error
      log('Error deleting vocabulary: $e');
      return -1;
      //throw Exception('Error deleting vocabulary: $e');
    }
  }

  //delete all vocab
  Future<int> deleteAllVocabulary() async {
    try {
      return await db.delete(db.vocabulary).go();
    } catch (e) {
      //log error
      log('Error deleting all vocabulary: $e');
      return -1;
      //throw Exception('Error deleting all vocabulary: $e');
    }
  }
}
