import 'dart:convert';
import 'package:fluffy_mvp/models/auth_model.dart';
import 'package:fluffy_mvp/models/event_model.dart';
import 'package:http/http.dart' as http;

class EventService extends Auth {
  static Future<List<Event>> getEvents() async {
    const String url = "$domainUrl/api/calendars/:1/events";

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${Auth.jwtToken}",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));

        List<Event> events =
            responseData.map((event) => Event.fromJson(event)).toList();
        return events;
      } else {
        throw Exception('이벤트 조회 실패 : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
