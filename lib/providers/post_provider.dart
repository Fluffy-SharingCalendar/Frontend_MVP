import 'package:fluffy_mvp/models/article_model.dart';
import 'package:fluffy_mvp/services/post_service.dart';
import 'package:flutter/material.dart';

class PostProvider with ChangeNotifier {
  List<Article> articles = [];
  bool loading = false;

  void _setLoading(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loading = value;
      notifyListeners();
    });
  }

  Future<void> update(int eventId) async {
    _setLoading(true);
    try {
      int size = articles.length;
      articles = [];
      articles = await PostService.getArticles(eventId, 0, size);
    } catch (e) {
      throw Exception(e);
    }
    _setLoading(false);
  }

  Future<void> getInitialArticles(int eventId) async {
    _setLoading(true);
    try {
      articles = await PostService.getArticles(eventId, 0, 10);
    } catch (e) {
      throw Exception(e);
    }
    _setLoading(false);
  }

  Future<void> getMoreArticles(int eventId, int page) async {
    _setLoading(true);
    try {
      articles.addAll(await PostService.getArticles(eventId, page, 10));
    } catch (e) {
      throw Exception(e);
    }
    _setLoading(false);
  }
}
