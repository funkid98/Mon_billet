import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier();
});

class PaymentState {
  final bool isLoading;
  final bool success;
  final String? error;

  PaymentState({required this.isLoading, required this.success, this.error});

  factory PaymentState.initial() =>
      PaymentState(isLoading: false, success: false);

  PaymentState copyWith({bool? isLoading, bool? success, String? error}) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      error: error,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier() : super(PaymentState.initial());

  Future<void> pay(Function onSuccess) async {
    state = state.copyWith(isLoading: true);
    try {
      // Simulate payment delay (replace with Stripe API call)
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(isLoading: false, success: true);
      onSuccess();
    } catch (e) {
      state =
          state.copyWith(isLoading: false, success: false, error: e.toString());
    }
  }
}
