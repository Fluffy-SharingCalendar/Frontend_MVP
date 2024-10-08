import 'package:fluffy_mvp/services/color_service.dart';
import 'package:flutter/material.dart';
import 'package:fluffy_mvp/models/event_model.dart';

class EventMarker extends StatefulWidget {
  const EventMarker({
    super.key,
    required this.event,
    required this.isFirst,
    required this.isLast,
  });

  final Event event;
  final bool isFirst;
  final bool isLast;

  @override
  _EventMarkerState createState() => _EventMarkerState();
}

class _EventMarkerState extends State<EventMarker> {
  late Color eventMarkerColor;

  @override
  void initState() {
    super.initState();
    eventMarkerColor = hexToColor(widget.event.color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 25.0,
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: eventMarkerColor.withOpacity(0.3),
          borderRadius: BorderRadius.horizontal(
            left: widget.isFirst ? const Radius.circular(5.0) : Radius.zero,
            right: widget.isLast ? const Radius.circular(5.0) : Radius.zero,
          ),
          border: Border(
            left: widget.isFirst
                ? BorderSide(color: eventMarkerColor)
                : BorderSide.none,
            right: widget.isLast
                ? BorderSide(color: eventMarkerColor)
                : BorderSide.none,
            top: BorderSide(color: eventMarkerColor),
            bottom: BorderSide(color: eventMarkerColor),
          ),
        ),
        child: widget.isFirst
            ? Row(
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
                      softWrap: false,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  const Icon(
                    Icons.event,
                    color: Color.fromARGB(0, 0, 0, 0),
                    size: 13.0,
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: Text(
                      widget.event.title,
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Color.fromARGB(0, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: false,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ));
  }
}
