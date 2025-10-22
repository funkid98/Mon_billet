import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/event_provider.dart';
import '../providers/category_provider.dart';
import 'event_card.dart';

// Providers for local state (filters)
final titleFilterProvider = StateProvider<String?>((ref) => null);
final placeFilterProvider = StateProvider<String?>((ref) => null);
final dateFilterProvider = StateProvider<DateTime?>((ref) => null);

class EventsSection extends ConsumerStatefulWidget {
  const EventsSection({super.key});

  @override
  ConsumerState<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends ConsumerState<EventsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  final List<String> places = ['Tunis', 'Sousse', 'Monastir'];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final titleFilter = ref.watch(titleFilterProvider);
    final selectedPlace = ref.watch(placeFilterProvider);
    final selectedDate = ref.watch(dateFilterProvider);

    // Trigger animation
    if (selectedCategory != null) {
      if (_slideController.status != AnimationStatus.forward &&
          _slideController.status != AnimationStatus.completed) {
        _slideController.forward();
      }
    } else {
      if (_slideController.status != AnimationStatus.reverse &&
          _slideController.status != AnimationStatus.dismissed) {
        _slideController.reverse();
      }
    }

    // Filter events
    final filteredEvents = events.where((event) {
      final matchCategory =
          selectedCategory == null || event.category == selectedCategory;
      final matchTitle = titleFilter == null ||
          event.title.toLowerCase().contains(titleFilter.toLowerCase());
      final matchPlace = selectedPlace == null || event.place == selectedPlace;
      final matchDate = selectedDate == null ||
          (event.date.year == selectedDate.year &&
              event.date.month == selectedDate.month &&
              event.date.day == selectedDate.day);
      return matchCategory && matchTitle && matchPlace && matchDate;
    }).toList();

    if (selectedCategory == null) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(color: Colors.grey[50]),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with category and count
              Row(
                children: [
                  Text(
                    '$selectedCategory Events',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[700]!, Colors.purple[700]!],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${filteredEvents.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),

              // Filters Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterCard(
                      context,
                      label: 'Name',
                      value: titleFilter ?? 'All',
                      icon: Icons.title,
                      onTap: () async {
                        final name =
                            await _showTitleFilterDialog(context, titleFilter);
                        if (name != null) {
                          ref.read(titleFilterProvider.notifier).state = name;
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildFilterCard(
                      context,
                      label: 'Place',
                      value: selectedPlace ?? 'All',
                      icon: Icons.location_on,
                      onTap: () async {
                        final place = await _showPlaceSelectionDialog(
                            context, places, 'Select Place', selectedPlace);
                        if (place != null) {
                          ref.read(placeFilterProvider.notifier).state = place;
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildFilterCard(
                      context,
                      label: 'Date',
                      value: selectedDate != null
                          ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                          : 'All',
                      icon: Icons.date_range,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          ref.read(dateFilterProvider.notifier).state = picked;
                        }
                      },
                    ),
                    if (titleFilter != null ||
                        selectedPlace != null ||
                        selectedDate != null) ...[
                      const SizedBox(width: 10),
                      _buildFilterCard(
                        context,
                        label: 'Reset',
                        value: '',
                        icon: Icons.refresh,
                        onTap: () {
                          ref.read(titleFilterProvider.notifier).state = null;
                          ref.read(placeFilterProvider.notifier).state = null;
                          ref.read(dateFilterProvider.notifier).state = null;
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Event list or empty message
              if (filteredEvents.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...filteredEvents.asMap().entries.map((entry) {
                  final index = entry.key;
                  final event = entry.value;
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    curve: Curves.easeOutCubic,
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: EventCard(event: event),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isReset = label == 'Reset';
    final hasValue = value.isNotEmpty && value != 'All';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: isReset
                ? LinearGradient(
                    colors: [Colors.red[400]!, Colors.orange[400]!])
                : hasValue
                    ? LinearGradient(
                        colors: [Colors.blue[600]!, Colors.purple[600]!])
                    : null,
            color: isReset || hasValue ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  isReset || hasValue ? Colors.transparent : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isReset
                    ? Colors.red.withOpacity(0.2)
                    : hasValue
                        ? Colors.blue.withOpacity(0.2)
                        : Colors.black.withOpacity(0.05),
                blurRadius: isReset || hasValue ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isReset || hasValue ? Colors.white : Colors.grey[700],
              ),
              if (!isReset) ...[
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        color: hasValue
                            ? Colors.white.withOpacity(0.8)
                            : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: hasValue ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showTitleFilterDialog(
      BuildContext context, String? current) async {
    TextEditingController searchController =
        TextEditingController(text: current ?? "");

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Event Name"),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Type event name..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final text = searchController.text.trim();
              Navigator.pop(context, text.isEmpty ? null : text);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  Future<String?> _showPlaceSelectionDialog(BuildContext context,
      List<String> options, String title, String? current) async {
    String? selectedOption = current;

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedOption,
                onChanged: (val) {
                  setState(() {
                    selectedOption = val;
                  });
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context, selectedOption),
              child: const Text("Confirm")),
        ],
      ),
    );
  }
}
