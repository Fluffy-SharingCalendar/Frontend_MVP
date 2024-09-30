import 'package:fluffy_mvp/widgets/sharing_memory_button.dart';
import 'package:flutter/material.dart';
import 'package:fluffy_mvp/models/event_model.dart';
import 'package:intl/intl.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({
    super.key,
    required this.selectedDay,
    required this.event,
    required this.onBack,
  });

  final DateTime selectedDay;
  final Event event;
  final VoidCallback onBack;

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy.MM.dd');
    return formatter.format(date);
  }

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
          " ${widget.selectedDay.year}년 ${widget.selectedDay.month}월 ${widget.selectedDay.day}일,",
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const Text(" 소중한 사람과 함께 소중한 하루를 기록해보세요✨"),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            const Icon(
              Icons.event,
              color: Colors.black54,
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(widget.event.title),
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        Row(
          children: [
            const Icon(
              Icons.date_range,
              color: Colors.black54,
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              widget.event.startDate,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black54,
                size: 15.0,
              ),
            ),
            Text(
              widget.event.endDate,
            ),
          ],
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          " ${widget.selectedDay.year}년 ${widget.selectedDay.month}월 ${widget.selectedDay.day}일의 ${widget.event.title},",
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const Text(
          " 이야기를 공유해보세요.",
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        SharingMemoryButton(
          event: widget.event,
          selectedDay: formatDate(widget.selectedDay),
        ),
      ],
    );
  }
}
