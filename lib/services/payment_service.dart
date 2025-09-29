import 'dart:async';

/// Mock payment service to simulate a payment flow.
class PaymentService {
  /// Simulates processing a payment and returns a transaction id.
  static Future<String> payINR(int amount, {String? note}) async {
    await Future.delayed(const Duration(seconds: 2));
    // In real app, integrate Razorpay/Stripe here.
    return 'TXN-${DateTime.now().millisecondsSinceEpoch}';
  }
}
