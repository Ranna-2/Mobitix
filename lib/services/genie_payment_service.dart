import 'dart:convert';
import 'package:http/http.dart' as http;

class GeniePaymentService {
  // Mock base URL - replace with your local server address
  static const String _baseUrl = 'http://localhost/mobitix/payment.php';

  Future<String> initiatePayment({
    required double amount,
    required String referenceId,
    required String returnUrl,
    required String customerEmail,
    required String customerMobile,
  }) async {
    // For demo purposes, we'll just return a mock payment URL
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // In a real app, this would be the URL to the actual payment gateway
    return '$_baseUrl?method=genie&amount=$amount&reference=$referenceId';
  }

  Future<Map<String, dynamic>> verifyPayment(String paymentId) async {
    // Simulate verification process
    await Future.delayed(const Duration(seconds: 2));

    // Randomly decide if payment succeeds (80% chance) or fails (20% chance)
    final success = DateTime.now().millisecond % 5 != 0; // 80% success rate

    return {
      'status': success ? 'SUCCESS' : 'FAILED',
      'paymentId': paymentId,
      'message': success
          ? 'Payment verified successfully'
          : 'Payment verification failed in mock gateway',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}