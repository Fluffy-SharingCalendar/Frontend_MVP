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
    final String url = "$domainUrl/api/posts/${posting.eventId}";
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers['Authorization'] = Auth.jwtToken ?? "Null";
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
      for (String? base64Image in posting.files!) {
        if (base64Image != null && base64Image.isNotEmpty) {
          try {
            String type = "";
            Uint8List imageBytes = base64Decode(base64Image);
            if (imageBytes.length >= 4) {
              if (imageBytes[0] == 0x89 &&
                  imageBytes[1] == 0x50 &&
                  imageBytes[2] == 0x4E &&
                  imageBytes[3] == 0x47) {
                type = "png";
              } else if (imageBytes[0] == 0xFF &&
                  imageBytes[1] == 0xD8 &&
                  imageBytes[2] == 0xFF) {
                type = "jpeg";
              }
            }

            if (type == "jpeg") {
              request.files.add(http.MultipartFile.fromBytes(
                'file',
                imageBytes,
                filename: 'image.jpeg',
                contentType: MediaType('image', 'jpeg'),
              ));
            } else if (type == "png") {
              request.files.add(http.MultipartFile.fromBytes(
                'file',
                imageBytes,
                filename: 'image.png',
                contentType: MediaType('image', 'png'),
              ));
            }
          } catch (e) {
            throw Exception("이미지 처리 중 오류 발생: $e");
          }
        }
      }
    }
    try {
      var response = await request.send();

      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("error : $e");
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
        ArticleResponse articleResponse =
            ArticleResponse.fromJson(responseData);
        return articleResponse.posts;
      } else {
        throw Exception('게시글 전체 조회 실패 : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // 게시글 삭제
  static Future<bool> deleteArticle(int postId) async {
    final String url = "$domainUrl/api/posts/$postId";

    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {
          "Authorization": Auth.jwtToken ?? "Null",
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // 게시글 수정
  static Future<bool> modifyArticle(
      String content, int postId, List<String>? files) async {
    final String url = "$domainUrl/api/posts/$postId";
    var request = http.MultipartRequest('PATCH', Uri.parse(url));

    request.headers['Authorization'] = Auth.jwtToken ?? "Null";
    request.headers['Content-Type'] = 'multipart/form-data';

    var jsonPayload = jsonEncode({
      'content': content,
    });

    var jsonPart = http.MultipartFile.fromString(
      'post',
      jsonPayload,
      contentType: MediaType('application', 'json'),
    );
    request.files.add(jsonPart);

    if (files != null && files.isNotEmpty) {
      for (String? base64Image in files) {
        if (base64Image != null && base64Image.isNotEmpty) {
          try {
            String type = "";
            Uint8List imageBytes = base64Decode(base64Image);
            if (imageBytes.length >= 4) {
              if (imageBytes[0] == 0x89 &&
                  imageBytes[1] == 0x50 &&
                  imageBytes[2] == 0x4E &&
                  imageBytes[3] == 0x47) {
                type = "png";
              } else if (imageBytes[0] == 0xFF &&
                  imageBytes[1] == 0xD8 &&
                  imageBytes[2] == 0xFF) {
                type = "jpeg";
              }
            }

            if (type == "jpeg") {
              request.files.add(http.MultipartFile.fromBytes(
                'file',
                imageBytes,
                filename: 'image.jpeg',
                contentType: MediaType('image', 'jpeg'),
              ));
            } else if (type == "png") {
              request.files.add(http.MultipartFile.fromBytes(
                'file',
                imageBytes,
                filename: 'image.png',
                contentType: MediaType('image', 'png'),
              ));
            }
          } catch (e) {
            throw Exception("이미지 처리 중 오류 발생: $e");
          }
        }
      }
    }
    try {
      var response = await request.send();
      print(response.statusCode);

      String responseBody = await response.stream.bytesToString();
      print("Response Body: $responseBody");
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("error : $e");
      throw Exception("게시글 수정 중 에러 발생: $e");
    }
  }
}
