import 'package:eazr_assignment/model/article_model.dart';
import 'package:flutter/material.dart';
import '../services/news_service.dart';

class NewsProvider with ChangeNotifier {
  List<ArticleElement> _articles = [];
  bool _isLoading = false;
  String _error = '';

  List<ArticleElement> get articles => _articles;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchArticles(String category) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _articles = await NewsService().fetchArticles(category);
    } catch (e) {
      _error = 'Failed to load articles$e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchArticles(String query) async {
    if (query.isEmpty) {
      _error = 'Search query cannot be empty';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _articles = await NewsService().searchArticles(query);
    } catch (e) {
      _error = 'Failed to load search results: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
