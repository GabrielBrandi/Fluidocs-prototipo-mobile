import 'package:flutter/material.dart';

import '../models/repository_item.dart';
import '../services/app_database.dart';

class RepositoriesProvider with ChangeNotifier {
  RepositoriesProvider({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  final List<RepositoryItem> _repositories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<RepositoryItem> get repositories => List.unmodifiable(_repositories);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadRepositories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final items = await _database.getRepositories();
      _repositories
        ..clear()
        ..addAll(items);
    } catch (error) {
      _errorMessage = 'Erro ao carregar repositórios: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRepository(RepositoryItem repository) async {
    try {
      final savedRepository = await _database.insertRepository(repository);
      _repositories.insert(0, savedRepository);
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Erro ao salvar repositório: $error';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteRepository(int id) async {
    try {
      await _database.deleteRepository(id);
      _repositories.removeWhere((repository) => repository.id == id);
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Erro ao remover repositório: $error';
      notifyListeners();
    }
  }
}
