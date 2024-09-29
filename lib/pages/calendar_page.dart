import 'package:fluffy_mvp/widgets/event_detail_modal.dart';
import 'package:flutter/material.dart';

import 'package:fluffy_mvp/models/event_model.dart';
import 'package:fluffy_mvp/widgets/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool _isDetailOpend = false;
  List<Event> _selectedEvents = [];
  DateTime? _selectedDay;

  // Event 리스트
  final List<Event> _events = [
    Event(
      eventId: 1,
      title: "FeedBack",
      color: "#A6DAF4",
      startDate: "2024.10.01",
      endDate: "2024.10.09",
    ),
    Event(
        eventId: 2,
        title: "방명록",
        color: "#0047AB",
        startDate: "2024.10.23",
        endDate: "2024.10.26"),
  ];

  // 상세보기 토글 함수
  void toggleDetail(bool isOpend) {
    setState(() {
      _isDetailOpend = isOpend;
    });
  }

  // 날짜를 선택했을 때 해당 날짜에 맞는 이벤트를 찾는 함수
  void selectDate(DateTime selectedDay) {
    setState(() {
      // 선택된 날짜와 겹치는 이벤트들을 필터링
      _selectedEvents = _events.where((event) {
        DateTime startDate = DateTime.parse(event.startDate);
        DateTime endDate = DateTime.parse(event.endDate);

        // 선택된 날짜가 이벤트의 시작일과 종료일 사이에 있는지 확인
        return selectedDay
                .isAfter(startDate.subtract(const Duration(days: 1))) &&
            selectedDay.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      _selectedDay = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FLUFFY"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: 0,
            right:
                _isDetailOpend ? MediaQuery.of(context).size.width * 0.25 : 0,
            child: Calendar(
              events: _events,
              onDaySelected: (DateTime selectedDay) {
                toggleDetail(true);
                selectDate(selectedDay);
              },
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _isDetailOpend
                ? MediaQuery.of(context).size.width * 0.75
                : MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.25,
            child: EventDetailModal(
              selectedDay: _selectedDay ?? DateTime.now(),
              events: _selectedEvents,
              onClose: () => toggleDetail(false),
            ),
          ),
        ],
      ),
    );
  }
}
