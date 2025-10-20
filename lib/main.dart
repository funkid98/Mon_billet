import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/event_home_page.dart';
import 'constants/colors.dart';

void main() {
  runApp(const ProviderScope(child: EventsApp()));
}

class EventsApp extends StatelessWidget {
  const EventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events Discovery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const EventsHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
