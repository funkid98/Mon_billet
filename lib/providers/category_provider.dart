import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_category.dart';

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final categoriesProvider = Provider<List<EventCategory>>((ref) => [
      EventCategory(name: 'All Events', icon: Icons.event, count: 267),
      EventCategory(name: 'Concerts', icon: Icons.music_note, count: 89),
      EventCategory(name: 'Sports', icon: Icons.sports_basketball, count: 58),
      EventCategory(name: 'Theater', icon: Icons.theater_comedy, count: 34),
      EventCategory(name: 'Workshops', icon: Icons.work_outline, count: 42),
      EventCategory(name: 'Arts & Culture', icon: Icons.palette, count: 28),
    ]);
