import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fluffy_mvp/models/event_model.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  final Map<DateTime, List<Event>> _events = {
    DateTime.utc(2024, 9, 10): [const Event('블로그 쓰기'), const Event('플러터 공부하기')],
    DateTime.utc(2024, 9, 12): [const Event('후추랑 놀기')],
  };

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FLUFFY_CALENDAR"),
      ),
      body: Center(
        child: TableCalendar<Event>(
          focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2024, 12, 31),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarFormat: _calendarFormat,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
          eventLoader: _getEventsForDay,
        ),
      ),
    );
  }
}
