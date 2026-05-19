import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/payment.dart';

class PaymentState {
  const PaymentState({
    this.activePayment,
    this.paymentHistory = const [],
    this.selectedMethod = 'cash',
    this.isLoading = false,
    this.errorMessage,
  });

  final Payment? activePayment;
  final List<Payment> paymentHistory;
  final String selectedMethod;
  final bool isLoading;
  final String? errorMessage;

  PaymentState copyWith({
    Payment? activePayment,
    List<Payment>? paymentHistory,
    String? selectedMethod,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PaymentState(
      activePayment: activePayment ?? this.activePayment,
      paymentHistory: paymentHistory ?? this.paymentHistory,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class PaymentController extends StateNotifier<PaymentState> {
  PaymentController() : super(const PaymentState());

  void selectMethod(String method) {
    state = state.copyWith(
      selectedMethod: method,
      activePayment: state.activePayment?.copyWith(method: method),
    );
  }

  void createPayment(Payment payment) {
    state = state.copyWith(
      activePayment: payment,
      selectedMethod: payment.method,
      isLoading: false,
      errorMessage: null,
    );
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading, errorMessage: null);
  }

  void confirmPayment({String confirmedBy = 'passenger'}) {
    final payment = state.activePayment;
    if (payment == null) {
      state = state.copyWith(errorMessage: 'No payment to confirm.');
      return;
    }

    final confirmedPayment = payment.copyWith(
      status: 'paid',
      confirmedBy: confirmedBy,
      confirmedAt: DateTime.now(),
    );

    state = state.copyWith(
      activePayment: confirmedPayment,
      paymentHistory: [confirmedPayment, ...state.paymentHistory],
      isLoading: false,
      errorMessage: null,
    );
  }

  void markFailed(String message) {
    state = state.copyWith(
      activePayment: state.activePayment?.copyWith(status: 'failed'),
      isLoading: false,
      errorMessage: message,
    );
  }
}

final paymentStateProvider =
    StateNotifierProvider<PaymentController, PaymentState>(
      (ref) => PaymentController(),
    );
