import 'package:flutter/material.dart';
import 'package:fluffy_mvp/models/event_model.dart';
import 'package:fluffy_mvp/widgets/event_detail_marker.dart';

class EventList extends StatefulWidget {
  const EventList({
    super.key,
    required this.selectedDay,
    required this.events,
    required this.onClose,
    required this.onTapDetail,
  });

  final DateTime selectedDay;
  final List<Event> events;
  final VoidCallback onClose;
  final VoidCallback onTapDetail;

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  Color eventListEventListColor = const Color.fromARGB(255, 131, 117, 255);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black45,
              ),
              onPressed: widget.onClose,
            ),
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          " ${widget.selectedDay.year}년 ${widget.selectedDay.month}월 ${widget.selectedDay.day}일",
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(
          height: 13.0,
        ),
        widget.events.isEmpty
            ? const Text(" 등록된 일정이 없습니다.")
            : Expanded(
                child: ListView.builder(
                  itemCount: widget.events.length,
                  itemBuilder: ((context, index) {
                    final event = widget.events[index];
                    return InkWell(
                      onTap: widget.onTapDetail,
                      child: EventDetailMarker(event: event),
                    );
                  }),
                ),
              ),
      ],
    );
  }
}
