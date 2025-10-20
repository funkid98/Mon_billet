import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'search_section.dart';
import '../constants/colors.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    const stepDelay = Duration(milliseconds: 250);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.blueGradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // shrink to content
            children: [
              // 1️⃣ Header
              Row(
                children: [
                  const Text(
                    "Monbil",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: AppColors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: AppColors.white),
                    onPressed: () {},
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 0.ms, curve: Curves.easeIn)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 600.ms,
                    delay: 0.ms,
                    curve: Curves.easeOutBack,
                  )
                  .slideY(
                    begin: -0.2,
                    duration: 600.ms,
                    delay: 0.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: 32),

              // 2️⃣ Tag line
              Row(
                children: const [
                  Icon(Icons.star, color: AppColors.amber, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Discover Amazing Events',
                    style: TextStyle(
                      color: AppColors.amber,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(
                      duration: 600.ms, delay: stepDelay, curve: Curves.easeIn)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 600.ms,
                    delay: stepDelay,
                    curve: Curves.easeOutBack,
                  )
                  .slideY(
                    begin: -0.2,
                    duration: 600.ms,
                    delay: stepDelay,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: 12),

              // 3️⃣ Main title
              const Text(
                'Find Your Next',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate()
                  .fadeIn(
                      duration: 600.ms,
                      delay: stepDelay * 2,
                      curve: Curves.easeIn)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 600.ms,
                    delay: stepDelay * 2,
                    curve: Curves.easeOutBack,
                  )
                  .slideY(
                    begin: -0.2,
                    duration: 600.ms,
                    delay: stepDelay * 2,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: 8),

              // 4️⃣ Subtitle badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Adventure',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                )
                    .animate()
                    .slideY(
                      begin: -0.6,
                      end: 0,
                      duration: 600.ms,
                      delay: stepDelay * 3,
                      curve: Curves.easeOutBack,
                    )
                    .fadeIn(
                        duration: 600.ms,
                        delay: stepDelay * 3,
                        curve: Curves.easeIn)
                    .scale(
                      begin: const Offset(0.6, 0.6),
                      end: const Offset(1, 1),
                      duration: 600.ms,
                      delay: stepDelay * 3,
                      curve: Curves.easeOutBack,
                    ),
              ),

              const SizedBox(height: 16),

              // 5️⃣ Description
              const Text(
                'Browse thousands of concerts,\nsports events, theater shows,\n'
                'and workshops. Book your\ntickets today and create\nmemories that last a lifetime.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
              )
                  .animate()
                  .fadeIn(
                      duration: 600.ms,
                      delay: stepDelay * 4,
                      curve: Curves.easeIn)
                  .slideY(
                    begin: -0.2,
                    duration: 600.ms,
                    delay: stepDelay * 4,
                    curve: Curves.easeOut,
                  )
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 600.ms,
                    delay: stepDelay * 4,
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 24),

              // 6️⃣ Search section
              const SearchSection()
                  .animate()
                  .fadeIn(
                      duration: 600.ms,
                      delay: stepDelay * 5,
                      curve: Curves.easeIn)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    duration: 600.ms,
                    delay: stepDelay * 5,
                    curve: Curves.easeOutBack,
                  )
                  .slideY(
                    begin: -0.2,
                    duration: 600.ms,
                    delay: stepDelay * 5,
                    curve: Curves.easeOut,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
