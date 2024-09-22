import 'package:flutter/material.dart';
import 'package:fluffy_mvp/models/event_model.dart';

class EventMarker extends StatefulWidget {
  const EventMarker({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  _EventMarkerState createState() => _EventMarkerState();
}

class _EventMarkerState extends State<EventMarker> {
  Color eventMarkerColor = const Color.fromARGB(255, 131, 117, 255);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: eventMarkerColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: eventMarkerColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event,
            color: eventMarkerColor,
            size: 13.0,
          ),
          const SizedBox(width: 5.0),
          Expanded(
            child: Text(
              widget.event.title,
              style: const TextStyle(
                fontSize: 10.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
