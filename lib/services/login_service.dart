import 'dart:convert';

import 'package:fluffy_mvp/models/auth_model.dart';
import 'package:fluffy_mvp/models/login_model.dart';
import 'package:http/http.dart' as http;

class LoginService extends Auth {
  static Future<bool> login(Login login) async {
    const String url = "$domainUrl/login";

    try {
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(login.toJson()),
      );

      if (response.statusCode == 200) {
        Auth.jwtToken = response.headers['authorization'];

        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> checkNickname(String nickname) async {
    print("닉네임 중복 체크");
    print(nickname);
    const String url = "$domainUrl/api/users/validation";

    try {
      var response = await http.post(
        Uri.parse(url),
        body: nickname,
      );

      print(response.statusCode);
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
