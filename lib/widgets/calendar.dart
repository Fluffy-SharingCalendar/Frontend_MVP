import 'package:fluffy_mvp/widgets/event_marker.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fluffy_mvp/models/event_model.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
    required this.events,
    required this.onDaySelected,
  });

  final List<Event> events;
  final ValueChanged<DateTime> onDaySelected;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final CalendarFormat _calendarFormat = CalendarFormat.month;

  List<Event> _getEventsForDay(DateTime day) {
    return widget.events.where((event) {
      DateTime startDate = DateTime.parse(event.startDate.replaceAll('.', '-'));
      DateTime endDate = DateTime.parse(event.endDate.replaceAll('.', '-'));

      return (isSameDay(day, startDate) || day.isAfter(startDate)) &&
          (isSameDay(day, endDate) || day.isBefore(endDate));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 15.0,
      ),
      child: TableCalendar<Event>(
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2024, 9, 1),
        lastDay: DateTime.utc(2024, 10, 31),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            widget.onDaySelected(selectedDay);
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
                DateTime startDate =
                    DateTime.parse(event.startDate.replaceAll('.', '-'));
                DateTime endDate =
                    DateTime.parse(event.endDate.replaceAll('.', '-'));

                bool isFirst = isSameDay(date, startDate);
                bool isLast = isSameDay(date, endDate);

                return EventMarker(
                  event: event,
                  isFirst: isFirst,
                  isLast: isLast,
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
