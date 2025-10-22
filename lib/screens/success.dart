import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:monbil/constants/colors.dart';
import 'dart:math' as math;

class TicketSuccessScreen extends StatefulWidget {
  final String ticketId;
  final String eventTitle;
  final String price;
  final String cardholderName;

  const TicketSuccessScreen({
    super.key,
    required this.ticketId,
    required this.eventTitle,
    required this.price,
    required this.cardholderName,
  });

  @override
  State<TicketSuccessScreen> createState() => _TicketSuccessScreenState();
}

class _TicketSuccessScreenState extends State<TicketSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late AnimationController _ticketController;
  late AnimationController _confettiController;
  late Animation<double> _checkmarkAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _checkmarkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _ticketController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _checkmarkAnimation = CurvedAnimation(
      parent: _checkmarkController,
      curve: Curves.elasticOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ticketController,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ticketController,
      curve: Curves.easeOut,
    ));

    _checkmarkController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _ticketController.forward();
    });
    _confettiController.repeat();
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    _ticketController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryPurpleDark.withOpacity(0.1),
              AppColors.background,
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildConfetti(),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildSuccessAnimation(),
                    const SizedBox(height: 32),
                    _buildSuccessTitle(),
                    const SizedBox(height: 40),
                    _buildTicketCard(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfetti() {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ConfettiPainter(_confettiController.value),
        );
      },
    );
  }

  Widget _buildSuccessAnimation() {
    return ScaleTransition(
      scale: _checkmarkAnimation,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade400,
              Colors.green.shade600,
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.4),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 70,
        ),
      ),
    );
  }

  Widget _buildSuccessTitle() {
    return Column(
      children: [
        const Text(
          'Payment Successful!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, color: Colors.green, size: 18),
              const SizedBox(width: 8),
              Text(
                'Your ticket is ready!',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurpleDark.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildTicketHeader(),
              _buildPerforatedDivider(),
              _buildTicketBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketHeader() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlueDark,
            Colors.blueAccent.shade400,
            Colors.indigo.shade400,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.confirmation_number_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.eventTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'E-TICKET',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerforatedDivider() {
    return SizedBox(
      height: 24,
      child: Stack(
        children: [
          Positioned(
            left: -12,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -12,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                30,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 4,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketBody() {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.greyLight,
                width: 2,
              ),
            ),
            child: QrImageView(
              data: widget.ticketId,
              version: QrVersions.auto,
              size: 180,
              backgroundColor: Colors.white,
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.circle,
                color: AppColors.primaryPurpleDark,
              ),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: AppColors.primaryPurpleDark,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryPurpleDark.withOpacity(0.1),
                  Colors.indigo.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryPurpleDark.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'TICKET ID',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.ticketId,
                  style: TextStyle(
                    color: AppColors.primaryPurpleDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.greyLighter,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Attendee Name',
                  value: widget.cardholderName,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.event_outlined,
                  label: 'Event',
                  value: widget.eventTitle,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.payments_outlined,
                  label: 'Amount Paid',
                  value: widget.price,
                  valueColor: Colors.green.shade700,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Purchase Date',
                  value: _formatDate(DateTime.now()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryPurpleDark.withOpacity(0.15),
                Colors.indigo.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryPurpleDark,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlueDark,
                AppColors.primaryBlue,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurpleDark.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Ticket saved successfully!'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.download_rounded, color: Colors.white, size: 22),
                    SizedBox(width: 12),
                    Text(
                      'Download Ticket',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryPurpleDark.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_rounded,
                      color: AppColors.primaryBlueDark,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Back to Home',
                      style: TextStyle(
                        color: AppColors.primaryBlueDark,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class ConfettiPainter extends CustomPainter {
  final double animationValue;
  final List<Confetti> confettiList = [];

  ConfettiPainter(this.animationValue) {
    if (confettiList.isEmpty) {
      for (int i = 0; i < 40; i++) {
        confettiList.add(Confetti());
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var confetti in confettiList) {
      final paint = Paint()
        ..color = confetti.color.withOpacity(0.7)
        ..style = PaintingStyle.fill;

      final progress = (animationValue + confetti.offset) % 1.0;
      final x = confetti.x * size.width;
      final y = progress * size.height;
      final rotation = progress * confetti.rotationSpeed * 2 * math.pi;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      if (confetti.shape == 0) {
        canvas.drawCircle(Offset.zero, confetti.size, paint);
      } else {
        final rect = Rect.fromCenter(
          center: Offset.zero,
          width: confetti.size * 2,
          height: confetti.size * 2,
        );
        canvas.drawRect(rect, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Confetti {
  final double x;
  final double offset;
  final double size;
  final Color color;
  final int shape;
  final double rotationSpeed;

  Confetti()
      : x = math.Random().nextDouble(),
        offset = math.Random().nextDouble(),
        size = math.Random().nextDouble() * 4 + 2,
        color = [
          Colors.purple,
          Colors.blue,
          Colors.pink,
          Colors.yellow,
          Colors.green,
          Colors.orange,
        ][math.Random().nextInt(6)],
        shape = math.Random().nextInt(2),
        rotationSpeed = math.Random().nextDouble() * 4 + 2;
}
