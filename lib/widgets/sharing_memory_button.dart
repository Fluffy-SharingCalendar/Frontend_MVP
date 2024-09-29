import 'package:fluffy_mvp/pages/sharing_memory_page.dart';
import 'package:flutter/material.dart';
import 'package:fluffy_mvp/models/event_model.dart';

class SharingMemoryButton extends StatefulWidget {
  const SharingMemoryButton({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  _SharingMemoryButtonState createState() => _SharingMemoryButtonState();
}

class _SharingMemoryButtonState extends State<SharingMemoryButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SharingMemoryPage()),
        );
      },
      child: Container(
        height: 150,
        width: 150,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(96, 96, 125, 139),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "추억",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "공유하기",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
