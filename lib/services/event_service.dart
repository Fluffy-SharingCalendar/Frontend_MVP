import 'dart:convert';
import 'package:fluffy_mvp/models/auth_model.dart';
import 'package:fluffy_mvp/models/event_model.dart';
import 'package:fluffy_mvp/models/event_detail_model.dart';
import 'package:http/http.dart' as http;

class EventService extends Auth {
  static Future<List<Event>> getEvents() async {
    const String url = "$domainUrl/api/calendars/1/events";

    print(Auth.jwtToken);

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": Auth.jwtToken ?? "Null",
        },
      );

      print("이벤트 목록 ${response.statusCode}");
      if (response.statusCode == 200) {
        List<dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));

        List<Event> events =
            responseData.map((event) => Event.fromJson(event)).toList();
        return events;
      } else {
        throw Exception('캘린더 일정 목록 조회 실패 : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<EventDetail> getEventDetail(int eventId) async {
    final String url = "$domainUrl/api/events/$eventId";

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${Auth.jwtToken}",
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(utf8.decode(response.bodyBytes));
        return EventDetail.fromJson(responseData);
      } else {
        throw Exception('일정 상세 조회 실패 : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
