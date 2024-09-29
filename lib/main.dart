import 'package:fluffy_mvp/pages/phone_num_page.dart';
import 'package:fluffy_mvp/pages/post_article_page.dart';
import 'package:fluffy_mvp/pages/sharing_memory_page.dart';
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
      // initialRoute: '/start',
      initialRoute: '/sharing_memory',
      routes: {
        '/calendar': (context) => const CalendarPage(),
        '/start': (context) => const StartPage(),
        '/phone_num': (context) => const PhoneNumPage(),
        '/post_article': (context) => const PostArticlePage(),
        '/sharing_memory': (context) => const SharingMemoryPage(),
      },
    );
  }
}
