import 'dart:convert';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:fluffy_mvp/models/auth_model.dart';
import 'package:fluffy_mvp/models/posting_model.dart';
import 'package:http/http.dart' as http;

class PostService extends Auth {
  static Future<bool> postArticle(Posting posting) async {
    final String url = "$domainUrl/api/post/${posting.eventId}";

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers['Authorization'] = Auth.jwtToken ?? 'Null';
    request.headers['Content-Type'] = 'multipart/form-data';

    var jsonPayload = jsonEncode({
      'eventId': posting.eventId,
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

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("게시글 작성 중 에러 발생: $e");
    }
  }
}
