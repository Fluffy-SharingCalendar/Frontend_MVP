import 'package:fluffy_mvp/widgets/event_marker.dart';
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
    DateTime.utc(2024, 9, 10): [const Event('플러터 공부하기')],
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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          child: TableCalendar<Event>(
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2024, 9, 1),
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
            rowHeight: 100.0,
            calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, events) => Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFd8d7e4),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                todayBuilder: (context, date, events) => Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFadb9ca),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: events.map((event) {
                      return EventMarker(event: event);
                    }).toList(),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
