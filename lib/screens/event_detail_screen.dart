import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monbil/constants/colors.dart';
import 'package:monbil/screens/payement/ticketparchuse.dart';
import '../models/event.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EventDetailScreen extends ConsumerWidget {
  final Event event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('MMM d • h:mm a');
    final formattedDate = dateFormat.format(event.date);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Hero Image Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Hero(
              tag: event.title,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(event.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms),
                  // Dark overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Navigation Bar
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.share,
                            color: AppColors.textPrimary),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border,
                            color: AppColors.textPrimary),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Sheet Content
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        event.type,
                        style: const TextStyle(
                          color: AppColors.primaryYellow,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                    const SizedBox(height: 16),

                    // Event Title
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                    const SizedBox(height: 16),

                    // Location and Date
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: AppColors.primaryBlue, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          event.place,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Icon(Icons.calendar_today,
                            color: AppColors.primaryBlue, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ).animate().scaleXY(
                          begin: 0.8,
                          end: 1.0,
                          curve: Curves.elasticOut,
                          delay: 400.ms,
                          duration: 400.ms,
                        ),

                    const SizedBox(height: 16),

                    // Attendees
                    Row(
                      children: [
                        SizedBox(
                          width: 72,
                          height: 32,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryBlue,
                                    border: Border.all(
                                        color: AppColors.white, width: 2),
                                  ),
                                  child: const Center(
                                      child: Icon(Icons.person,
                                          color: AppColors.white, size: 16)),
                                ),
                              ),
                              Positioned(
                                left: 20,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.green,
                                    border: Border.all(
                                        color: AppColors.white, width: 2),
                                  ),
                                  child: const Center(
                                      child: Icon(Icons.person,
                                          color: AppColors.white, size: 16)),
                                ),
                              ),
                              Positioned(
                                left: 40,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryBlueDark,
                                    border: Border.all(
                                        color: AppColors.white, width: 2),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

                    const SizedBox(height: 24),

                    // About Event
                    const Text(
                      'About Event',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

                    const SizedBox(height: 12),

                    ExpandableText(
                      text:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla euismod, nisl vel tincidunt cursus, lectus nisl dapibus arcu, non tempor velit purus sed magna. Etiam finibus mi at sapien varius, eget gravida purus aliquet...',
                    ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

                    const SizedBox(height: 24),

                    // Organizer
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryBlue,
                                AppColors.primaryPurpleDark
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                              child: Icon(Icons.music_note,
                                  color: AppColors.white, size: 24)),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'SonicVibe Events',
                            style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.phone,
                              color: AppColors.primaryBlue, size: 20),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.message,
                              color: AppColors.primaryYellow, size: 20),
                        ),
                      ],
                    ).animate().fadeIn(delay: 800.ms, duration: 400.ms),

                    const SizedBox(height: 80), // Extra space for button
                  ],
                ),
              ),
            ),
          ),

          // Buy Tickets Button
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EventTicketPurchaseScreen(event: event),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Buy Tickets',
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
          ),
        ],
      ),
    );
  }
}

// ExpandableText Class
class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLength;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLength = 100,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final needsTrim = widget.text.length > widget.trimLength;
    final displayText = isExpanded || !needsTrim
        ? widget.text
        : widget.text.substring(0, widget.trimLength);

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          height: 1.6,
        ),
        children: [
          TextSpan(text: displayText),
          if (!isExpanded && needsTrim)
            TextSpan(
              text: ' Read more',
              style: const TextStyle(
                  color: AppColors.primaryBlue, fontWeight: FontWeight.w600),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isExpanded = true;
                  });
                },
            ),
          if (isExpanded && needsTrim)
            TextSpan(
              text: ' Read less',
              style: const TextStyle(
                  color: AppColors.primaryBlue, fontWeight: FontWeight.w600),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isExpanded = false;
                  });
                },
            ),
        ],
      ),
    );
  }
}
