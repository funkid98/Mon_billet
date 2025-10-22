import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:monbil/constants/colors.dart';
import '../models/event.dart';
import '../screens/event_detail_screen.dart'; // 👈 new detail page

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) {
        setState(() => _isPressed = false);

        // 👇 Navigate with Hero animation + fade
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: 400.ms,
            pageBuilder: (_, __, ___) => EventDetailScreen(event: widget.event),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: Hero(
        tag: widget.event.title, // 👈 unique tag for transition
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isPressed ? 0.3 : 0.1),
                blurRadius: _isPressed ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.asset(
                  widget.event.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _buildTag(
                    widget.event.badge == 'Popular' ? 'Popular' : 'New',
                    widget.event.badge == 'Popular'
                        ? Colors.orange
                        : Colors.blue,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildTag(widget.event.price, Colors.green),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          widget.event.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.event.place,
                          style: const TextStyle(
                            color: AppColors.greyLight,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          // 👇 flutter_animate press animation
          .animate(target: _isPressed ? 1 : 0)
          .moveY(begin: 0, end: -10, duration: 120.ms)
          .scale(begin: const Offset(1, 1), end: const Offset(1.03, 1.03)),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
