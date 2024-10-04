import 'dart:convert';
import 'package:fluffy_mvp/models/auth_model.dart';
import 'package:fluffy_mvp/models/comment_model.dart';
import 'package:http/http.dart' as http;

class CommentService extends Auth {
  static Future<List<Comment>> getAllComments(int postId) async {
    final String url = "$domainUrl/api/comments/$postId";
    print(url);

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": Auth.jwtToken ?? "Null",
        },
      );

      print(response.statusCode);
      print(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        List<dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));

        List<Comment> comments =
            responseData.map((comment) => Comment.fromJson(comment)).toList();
        return comments;
      } else {
        throw Exception('댓글 전체 조회 실패 : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
