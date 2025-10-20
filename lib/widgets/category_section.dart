import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_provider.dart';
import '../constants/colors.dart';

class CategorySection extends ConsumerStatefulWidget {
  const CategorySection({super.key});

  @override
  ConsumerState<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends ConsumerState<CategorySection>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAnimations();
    });
  }

  void _initializeAnimations() {
    if (_isInitialized) return;

    final categories = ref.read(categoriesProvider);

    for (int i = 0; i < categories.length + 1; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
      _controllers.add(controller);
      _animations.add(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }

    _isInitialized = true;

    _runSequentialFade();
  }

  Future<void> _runSequentialFade() async {
    for (var controller in _controllers) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) controller.forward();
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with fade & slide
          _isInitialized
              ? FadeTransition(
                  opacity: _animations[0],
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.3),
                      end: Offset.zero,
                    ).animate(_animations[0]),
                    child: const Text(
                      'Browse by Category',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
              : const Text(
                  'Browse by Category',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
          const SizedBox(height: 20),
          // Category items
          ...categories.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            final isSelected = selectedCategory == category.name;

            final card = InkWell(
              onTap: () {
                ref.read(selectedCategoryProvider.notifier).state =
                    category.name;
              },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColors.primaryBlueDark,
                            AppColors.primaryPurpleDark
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.2)
                            : AppColors.primaryBlue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category.icon,
                        size: 22,
                        color:
                            isSelected ? Colors.white : AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${category.count}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            return _isInitialized && index + 1 < _animations.length
                ? FadeTransition(
                    opacity: _animations[index + 1],
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.2),
                        end: Offset.zero,
                      ).animate(_animations[index + 1]),
                      child: card,
                    ),
                  )
                : card;
          }),
        ],
      ),
    );
  }
}
