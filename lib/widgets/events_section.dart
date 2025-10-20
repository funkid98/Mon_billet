import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/event_provider.dart';
import 'event_card.dart';

class EventsSection extends ConsumerStatefulWidget {
  const EventsSection({super.key});

  @override
  ConsumerState<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends ConsumerState<EventsSection> {
  String? titleFilter;
  String? selectedPlace;
  DateTime? selectedDate;

  final List<String> types = ['Concert', 'Workshop', 'Meetup'];
  final List<String> places = ['Tunis', 'Sousse', 'Monastir'];

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventsProvider);

    final filteredEvents = events.where((event) {
      final matchTitle = titleFilter == null ||
          event.title.toLowerCase().contains(titleFilter!.toLowerCase());
      final matchPlace = selectedPlace == null || event.place == selectedPlace;
      final matchDate = selectedDate == null ||
          (event.date.year == selectedDate!.year &&
              event.date.month == selectedDate!.month &&
              event.date.day == selectedDate!.day);
      return matchTitle && matchPlace && matchDate;
    }).toList();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'All Events',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterCard(
                  context,
                  label: 'Name',
                  value: titleFilter ?? 'None',
                  icon: Icons.title,
                  onTap: () async {
                    final name = await _showTitleFilterDialog(context);
                    if (name != null) setState(() => titleFilter = name);
                  },
                ),
                SizedBox(width: 16),
                _buildFilterCard(
                  context,
                  label: 'Place',
                  value: selectedPlace ?? 'All',
                  icon: Icons.location_on,
                  onTap: () async {
                    final place = await _showPlaceSelectionDialog(
                        context, places, 'Select Place');
                    if (place != null) setState(() => selectedPlace = place);
                  },
                ),
                const SizedBox(width: 12),
                _buildFilterCard(
                  context,
                  label: 'Date',
                  value: selectedDate != null
                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : 'All',
                  icon: Icons.date_range,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                ),
                const SizedBox(width: 12),
                _buildFilterCard(
                  context,
                  label: 'Reset',
                  value: '',
                  icon: Icons.refresh,
                  onTap: () {
                    setState(() {
                      selectedPlace = null;
                      selectedDate = null;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...filteredEvents.map((event) => EventCard(event: event)),
        ],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.blueGrey),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showTitleFilterDialog(BuildContext context) {
    TextEditingController searchController =
        TextEditingController(text: titleFilter ?? "");

    return showGeneralDialog<String>(
      context: context,
      barrierLabel: "Select Name",
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: StatefulBuilder(builder: (context, setStateDialog) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Enter Event Name",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Type event name...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            padding:
                                const EdgeInsets.all(2), // border thickness
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 24),
                              decoration: BoxDecoration(
                                color: Colors.white, // inner button color
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Color(
                                        0xFF2575FC), // same gradient main color
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            final text = searchController.text.trim();
                            Navigator.pop(context, text.isEmpty ? null : text);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedAnim = CurvedAnimation(
            parent: anim1,
            curve: Curves.easeOutBack,
            reverseCurve: Curves.easeInBack);

        return FadeTransition(
          opacity: curvedAnim,
          child: ScaleTransition(
            scale: curvedAnim,
            child: SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
                      .animate(curvedAnim),
              child: child,
            ),
          ),
        );
      },
    );
  }

  Future<String?> _showPlaceSelectionDialog(
      BuildContext context, List<String> options, String title) {
    String? selectedOption;

    return showGeneralDialog<String>(
      context: context,
      barrierLabel: title,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: StatefulBuilder(builder: (context, setStateDialog) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options[index];
                          final isSelected = option == selectedOption;
                          return InkWell(
                            onTap: () {
                              setStateDialog(() {
                                selectedOption = option;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 12),
                              decoration: isSelected
                                  ? BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    )
                                  : null,
                              child: Text(option,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal)),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            padding:
                                const EdgeInsets.all(2), // border thickness
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 24),
                              decoration: BoxDecoration(
                                color: Colors.white, // inner button color
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Color(
                                        0xFF2575FC), // same gradient main color
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => Navigator.pop(context, selectedOption),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedAnim = CurvedAnimation(
            parent: anim1,
            curve: Curves.easeOutBack,
            reverseCurve: Curves.easeInBack);

        return FadeTransition(
          opacity: curvedAnim,
          child: ScaleTransition(
            scale: curvedAnim,
            child: SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
                      .animate(curvedAnim),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
