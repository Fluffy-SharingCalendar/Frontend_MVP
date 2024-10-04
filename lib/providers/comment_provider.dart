import 'package:fluffy_mvp/models/comment_model.dart';
import 'package:fluffy_mvp/services/comment_service.dart';
import 'package:flutter/material.dart';

class CommentProvider with ChangeNotifier {
  List<Comment> comments = [];
  bool loading = false;

  void _setLoading(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loading = value;
      notifyListeners();
    });
  }

  Future<void> getComments(int postId) async {
    _setLoading(true);
    try {
      comments = await CommentService.getAllComments(postId);
      print(comments);
    } catch (e) {
      throw Exception(e);
    }
    _setLoading(false);
  }
}
