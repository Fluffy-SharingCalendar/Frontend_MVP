import 'dart:convert';

import 'package:fluffy_mvp/models/auth_model.dart';
import 'package:fluffy_mvp/models/login_model.dart';
import 'package:http/http.dart' as http;

class PostService extends Auth {
  static Future<bool> postArticle(Login login) async {
    const String url = "$domainUrl/login";

    try {
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(login.toJson()),
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print("로그인 성공");
        print(utf8.decode(response.bodyBytes));
        return true;
      } else {
        print("로그인 실패: ${response.statusCode}");
        print(utf8.decode(response.bodyBytes));
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
