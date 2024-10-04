import 'dart:convert';
import 'dart:typed_data';
import 'package:fluffy_mvp/models/article_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:fluffy_mvp/models/auth_model.dart';
import 'package:fluffy_mvp/models/posting_model.dart';
import 'package:http/http.dart' as http;

class PostService extends Auth {
  // 게시글 등록
  static Future<bool> postArticle(Posting posting) async {
    final String url = "$domainUrl/api/post/${posting.eventId}";

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers['Authorization'] = Auth.jwtToken ?? 'Null';
    request.headers['Content-Type'] = 'multipart/form-data';

    var jsonPayload = jsonEncode({
      'eventDate': posting.eventDate,
      'content': posting.content,
    });

    var jsonPart = http.MultipartFile.fromString(
      'post',
      jsonPayload,
      contentType: MediaType('application', 'json'),
    );
    request.files.add(jsonPart);

    if (posting.files != null && posting.files!.isNotEmpty) {
      for (String base64Image in posting.files!) {
        if (base64Image.isNotEmpty) {
          try {
            Uint8List imageBytes = base64Decode(base64Image);
            request.files.add(http.MultipartFile.fromBytes(
              'file',
              imageBytes,
              filename: 'image.jpeg',
              contentType: MediaType('image', 'jpeg'),
            ));
          } catch (e) {
            throw Exception(e);
          }
        }
      }
    }

    try {
      var response = await request.send();
      print(response.statusCode);

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("게시글 작성 중 에러 발생: $e");
    }
  }

  // 게시글 전체 조회
  static Future<List<Article>> getArticles(int eventId, int page) async {
    final String url = "$domainUrl/api/posts/$eventId?page=$page";
    print(page);

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": Auth.jwtToken ?? "Null",
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(utf8.decode(response.bodyBytes));
        print(responseData);
        ArticleResponse articleResponse =
            ArticleResponse.fromJson(responseData);
        print(articleResponse.posts);
        return articleResponse.posts;
      } else {
        throw Exception('일정 상세 조회 실패 : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
