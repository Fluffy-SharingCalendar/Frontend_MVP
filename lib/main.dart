import 'package:fluffy_mvp/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'package:fluffy_mvp/pages/calendar_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluffy MVP',
      debugShowCheckedModeBanner: false,
      initialRoute: '/start',
      routes: {
        '/calendar': (context) => const CalendarPage(),
        '/start': (context) => const StartPage(),
      },
    );
  }
}
