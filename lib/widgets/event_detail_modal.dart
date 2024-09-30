import 'package:flutter/material.dart';

import 'package:fluffy_mvp/widgets/event_list.dart';
import 'package:fluffy_mvp/widgets/event_detail_view.dart';

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
  bool isClickedDetail = false;
  Event? selectedEvent;

  void toggleClicked(bool isClicked, Event? event) {
    setState(() {
      isClickedDetail = isClicked;
      selectedEvent = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: isClickedDetail
            ? EventDetailView(
                selectedDay: widget.selectedDay,
                event: selectedEvent!,
                onBack: () => toggleClicked(false, null),
              )
            : EventList(
                selectedDay: widget.selectedDay,
                events: widget.events,
                onClose: widget.onClose,
                onTapDetail: (event) => toggleClicked(true, event),
              ),
      ),
    );
  }
}
