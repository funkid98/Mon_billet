import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monbil/constants/colors.dart';
import 'package:monbil/screens/payement/formatter/formatter.dart';
import 'package:monbil/screens/success.dart';

import '../../models/event.dart';
import 'payement_provider.dart';

class EventTicketPurchaseScreen extends ConsumerStatefulWidget {
  final Event event;
  const EventTicketPurchaseScreen({super.key, required this.event});

  @override
  ConsumerState<EventTicketPurchaseScreen> createState() =>
      _EventTicketPurchaseScreenState();
}

class _EventTicketPurchaseScreenState
    extends ConsumerState<EventTicketPurchaseScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardholderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardholderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Strip spaces for processing
  String _onlyDigits(String value) => value.replaceAll(RegExp(r'\D'), '');

  // Display card number on the preview: first 4 digits + masked groups
  String _formatCardNumberForDisplay(String value) {
    final digits = _onlyDigits(value);
    if (digits.isEmpty) return '•••• XXXX XXXX XXXX';
    final first4 =
        digits.length >= 4 ? digits.substring(0, 4) : digits.padRight(4, '•');
    // Build groups with spaces
    return '$first4 XXXX XXXX XXXX';
  }

  // Display expiry as MM/YY
  String _formatExpiryDateForDisplay(String value) {
    final digits = _onlyDigits(value);
    if (digits.length >= 4) {
      final mm = digits.substring(0, 2);
      final yy = digits.substring(2, 4);
      return '$mm/$yy';
    } else if (digits.length >= 2) {
      final mm = digits.substring(0, 2);
      final yy = digits.substring(2);
      return yy.isEmpty ? '$mm/YY' : '$mm/$yy';
    }
    return 'MM/YY';
  }

  // Detect card brand from number (basic detection)
  String _detectCardBrand(String value) {
    final digits = _onlyDigits(value);
    if (digits.isEmpty) return 'UNKNOWN';
    // Visa: starts with 4
    if (digits.startsWith('4')) return 'VISA';
    // MasterCard: 51-55 or 2221-2720
    final firstTwo =
        digits.length >= 2 ? int.tryParse(digits.substring(0, 2)) : null;
    final firstFour =
        digits.length >= 4 ? int.tryParse(digits.substring(0, 4)) : null;
    final firstSix =
        digits.length >= 6 ? int.tryParse(digits.substring(0, 6)) : null;
    if (firstTwo != null && firstTwo >= 51 && firstTwo <= 55)
      return 'MASTERCARD';
    if (firstFour != null && firstFour >= 2221 && firstFour <= 2720)
      return 'MASTERCARD';
    // Amex: 34 or 37
    if (firstTwo != null && (firstTwo == 34 || firstTwo == 37)) return 'AMEX';
    // Discover (basic ranges)
    if (digits.startsWith('6011') ||
        digits.startsWith('65') ||
        (firstSix != null && firstSix >= 622126 && firstSix <= 622925)) {
      return 'DISCOVER';
    }
    return 'UNKNOWN';
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);
    final paymentNotifier = ref.read(paymentProvider.notifier);

    // compute brand each build
    final cardBrand = _detectCardBrand(_cardNumberController.text);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryBlueDark,
              AppColors.primaryBlueDark.withOpacity(0.8),
              AppColors.background,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 32),
                            _buildCreditCardPreview(cardBrand),
                            const SizedBox(height: 24),
                            _buildPaymentForm(),
                            const SizedBox(height: 24),
                            _buildPayButton(paymentNotifier, paymentState),
                            const SizedBox(height: 16),
                            _buildSecurityBadge(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.confirmation_number_outlined,
                    color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.event.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.stars, color: Colors.amber, size: 16),
              const SizedBox(width: 6),
              Text(
                'Secure your spot',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreditCardPreview(String cardBrand) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlueDark.withOpacity(0.9),
            Colors.lightBlueAccent.shade400,
            Colors.indigo.shade500,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurpleDark.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.credit_card, color: Colors.white, size: 32),
                    // Show brand text (or could swap for an image asset)
                    Text(
                      cardBrand,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _cardNumberController.text.isEmpty
                          ? '•••• XXXX XXXX XXXX'
                          : _formatCardNumberForDisplay(
                              _cardNumberController.text),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CARDHOLDER',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _cardholderController.text.isEmpty
                                  ? 'YOUR NAME'
                                  : _cardholderController.text.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EXPIRES',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _expiryDateController.text.isEmpty
                                  ? 'MM/YY'
                                  : _formatExpiryDateForDisplay(
                                      _expiryDateController.text),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            label: 'Card Number',
            controller: _cardNumberController,
            hint: '1234 5678 9012 3456',
            icon: Icons.credit_card_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              CardNumberInputFormatter(),
            ],
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Cardholder Name',
            controller: _cardholderController,
            hint: 'John Doe',
            icon: Icons.person_outline,
            textCapitalization: TextCapitalization.words,
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Expiry Date',
                  controller: _expiryDateController,
                  hint: 'MM/YY',
                  icon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    ExpiryDateInputFormatter(),
                  ],
                  onChanged: (value) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  label: 'CVV',
                  controller: _cvvController,
                  hint: '123',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization? textCapitalization,
    bool obscureText = false,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters as List<TextInputFormatter>?,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          obscureText: obscureText,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.4),
            ),
            prefixIcon:
                Icon(icon, color: AppColors.primaryPurpleDark, size: 20),
            filled: true,
            fillColor: AppColors.greyLighter,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.primaryPurpleDark,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton(
      PaymentNotifier paymentNotifier, PaymentState paymentState) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: paymentState.isLoading
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  paymentNotifier.pay(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TicketSuccessScreen(
                          ticketId: '#${DateTime.now().millisecondsSinceEpoch}',
                          eventTitle: widget.event.title,
                          price: widget.event.price,
                          cardholderName: _cardholderController.text,
                        ),
                      ),
                    );
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlueDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: paymentState.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Pay ${widget.event.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSecurityBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.verified_user, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Text(
                'Secure & encrypted payment',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
