import 'package:fluffy_mvp/widgets/event_detail_marker.dart';
import 'package:flutter/material.dart';

import 'package:fluffy_mvp/models/event_model.dart';

class EventDetailModal extends StatefulWidget {
  const EventDetailModal({
    super.key,
    required this.selectedDay,
    required this.events,
    required this.onClose,
  });

  final DateTime selectedDay;
  final List<Event> events;
  final VoidCallback onClose;

  @override
  State<EventDetailModal> createState() => _EventDetailModalState();
}

class _EventDetailModalState extends State<EventDetailModal> {
  Color eventMarkerColor = const Color.fromARGB(255, 131, 117, 255);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
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
                        return EventDetailMarker(event: event);
                      }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
