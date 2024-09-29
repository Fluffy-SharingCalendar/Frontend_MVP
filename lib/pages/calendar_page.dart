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

  final Map<DateTime, List<Event>> _events = {
    // DateTime.utc(2024, 9, 10): [
    //   Event(
    //     '플러터 공부하기',
    //     DateTime.utc(2024, 9, 10),
    //     DateTime.utc(2024, 9, 10),
    //   ),
    // ],
    // DateTime.utc(2024, 9, 12): [
    //   Event(
    //     '후추랑 놀기',
    //     DateTime.utc(2024, 9, 12),
    //     DateTime.utc(2024, 9, 12),
    //   ),
    // ],
  };

  void toggleDetail(bool isOpend) {
    setState(() {
      _isDetailOpend = isOpend;
    });
  }

  void selectDate(DateTime selectedDay) {
    _selectedEvents = _events[selectedDay] ?? [];
    _selectedDay = selectedDay;
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
