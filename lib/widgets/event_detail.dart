import 'package:flutter/material.dart';
import 'package:fluffy_mvp/models/event_model.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({
    super.key,
    required this.selectedDay,
    required this.events,
    required this.onBack,
  });

  final DateTime selectedDay;
  final List<Event> events;
  final VoidCallback onBack;

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  Color eventDeEventDetailEventDetailColor =
      const Color.fromARGB(255, 131, 117, 255);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black45,
              ),
              onPressed: widget.onBack,
            ),
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          " ${widget.selectedDay.year}년 ${widget.selectedDay.month}월 ${widget.selectedDay.day}일을 기록해보세요!",
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(
          height: 13.0,
        ),
      ],
    );
  }
}
