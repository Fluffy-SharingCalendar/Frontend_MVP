import 'package:flutter/material.dart';
import 'package:fluffy_mvp/models/event_model.dart';
import 'package:fluffy_mvp/services/color_service.dart';

class EventDetailMarker extends StatefulWidget {
  const EventDetailMarker({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  _EventDetailMarkerState createState() => _EventDetailMarkerState();
}

class _EventDetailMarkerState extends State<EventDetailMarker> {
  late Color eventMarkerColor;

  @override
  void initState() {
    super.initState();
    eventMarkerColor = hexToColor(widget.event.color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
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
            size: 18.0,
          ),
          const SizedBox(width: 5.0),
          Text(
            widget.event.title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
