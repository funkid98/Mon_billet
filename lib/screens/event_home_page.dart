import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/hero_section.dart';
import '../widgets/category_section.dart';
import '../widgets/events_section.dart';
import '../constants/colors.dart';

class EventsHomePage extends ConsumerStatefulWidget {
  const EventsHomePage({super.key});

  @override
  ConsumerState<EventsHomePage> createState() => _EventsHomePageState();
}

class _EventsHomePageState extends ConsumerState<EventsHomePage> {
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primaryYellow,
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: const HeroSection(),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: const [
                  CategorySection(),
                  EventsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
