import 'package:fluffy_mvp/models/login_model.dart';
import 'package:fluffy_mvp/services/event_service.dart';
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
  List<Event> _events = [];

  // // Event 리스트
  // final List<Event> _events = [
  //   Event(
  //     eventId: 1,
  //     title: "FeedBack",
  //     color: "#A6DAF4",
  //     startDate: "2024.10.01",
  //     endDate: "2024.10.09",
  //   ),
  //   Event(
  //       eventId: 2,
  //       title: "방명록",
  //       color: "#0047AB",
  //       startDate: "2024.10.23",
  //       endDate: "2024.10.26"),
  // ];

  void toggleDetail(bool isOpend) {
    setState(() {
      _isDetailOpend = isOpend;
    });
  }

  void selectDate(DateTime selectedDay) {
    setState(() {
      _selectedEvents = _events.where((event) {
        DateTime startDate =
            DateTime.parse(event.startDate.replaceAll('.', '-'));
        DateTime endDate = DateTime.parse(event.endDate.replaceAll('.', '-'));

        return selectedDay
                .isAfter(startDate.subtract(const Duration(days: 1))) &&
            selectedDay.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      _selectedDay = selectedDay;
    });
  }

  void _getEvents() async {
    List<Event> futureEvents = await EventService.getEvents();
    setState(() {
      _events = futureEvents;
    });
  }

  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
          width: 100,
        ),
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
