import 'package:http/http.dart' as http;
import 'dart:convert';

class KokoPaymentService {
  static const String _baseUrl = 'http://192.168.75.242/mobitix/payment.php';

  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String referenceId,
    required String passengerName,
    required String mobile,
    required String email,
    required String boarding,
    required String destination,
    required List<String> seats,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'payment_method': 'Koko',
          'amount': amount,
          'reference_id': referenceId,
          'passenger_name': passengerName,
          'mobile': mobile,
          'email': email,
          'boarding_point': boarding,
          'destination': destination,
          'seats': seats.join(', '),
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Koko payment error: $e');
    }
  }
}

class EzCashPaymentService {
  static const String _baseUrl = 'http://192.168.75.242/mobitix/payment.php';

  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String referenceId,
    required String passengerName,
    required String mobile,
    required String email,
    required String boarding,
    required String destination,
    required List<String> seats,
  }) async {
    try {
      // Simulate eZcash mobile verification step
      await Future.delayed(const Duration(seconds: 2));

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'payment_method': 'eZcash',
          'amount': amount,
          'reference_id': referenceId,
          'passenger_name': passengerName,
          'mobile': mobile,
          'email': email,
          'boarding_point': boarding,
          'destination': destination,
          'seats': seats.join(', '),
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('eZcash payment error: $e');
    }
  }
}