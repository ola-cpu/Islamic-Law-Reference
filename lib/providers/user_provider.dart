import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class UserProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<int> _favorites = [];
  Map<int, String> _notes = {};

  List<int> get favorites => _favorites;
  Map<int, String> get notes => _notes;

  UserProvider() {
    _loadFromDatabase();
  }

  Future<void> _loadFromDatabase() async {
    _favorites = await _dbHelper.getFavorites();
    _notes = await _dbHelper.getAllNotes();
    notifyListeners();
  }

  Future<void> toggleFavorite(int lawId) async {
    if (_favorites.contains(lawId)) {
      _favorites.remove(lawId);
      await _dbHelper.removeFavorite(lawId);
    } else {
      _favorites.add(lawId);
      await _dbHelper.addFavorite(lawId);
    }
    notifyListeners();
  }

  bool isFavorite(int lawId) {
    return _favorites.contains(lawId);
  }

  Future<void> addNote(int lawId, String note) async {
    _notes[lawId] = note;
    await _dbHelper.saveNote(lawId, note);
    notifyListeners();
  }

  String? getNote(int lawId) {
    return _notes[lawId];
  }
}
