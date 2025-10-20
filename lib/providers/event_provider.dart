import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';

final eventsProvider = Provider<List<Event>>((ref) {
  return [
    Event(
      badge: "Popular",
      title: 'Concert in Tunis',
      imageUrl: 'assets/permoda.jpg',
      price: 'Free',
      type: 'Concert',
      place: 'Tunis',
      date: DateTime(2025, 10, 19),
    ),
  ];
});
