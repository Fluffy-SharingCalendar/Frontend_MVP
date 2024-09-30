import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:fluffy_mvp/models/auth_model.dart';
import 'package:fluffy_mvp/models/posting_model.dart';
import 'package:fluffy_mvp/services/image_util.dart';
import 'package:http/http.dart' as http;

class PostService extends Auth {
  static Future<bool> postArticle(Posting posting) async {
    final String url = "$domainUrl/api/post/${posting.eventId}";
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    request.headers['Authorization'] = Auth.jwtToken ?? 'Null';
    print(Auth.jwtToken);

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

    if (posting.files!.isNotEmpty) {
      for (String imagePath in posting.files!) {
        if (imagePath.isNotEmpty) {
          var file = await ImageUtil.compressImageToMultipartFile(
            'file',
            imagePath,
          );
          request.files.add(file);
        }
      }
    }

    var response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }

    //   try {
    //     var response = await request.send();
    //     print(response.statusCode);

    //     if (response.statusCode == 204) {
    //       return true;
    //     } else {
    //       return false;
    //     }
    //   } catch (e) {
    //     throw Exception("게시글 작성 에러 : $e");
    //   }
  }
}
