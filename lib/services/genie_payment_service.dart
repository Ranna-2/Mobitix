import 'dart:convert';
import 'package:http/http.dart' as http;

class GeniePaymentService {
  static const String _appId = '36bafce7-a201-429b-a9e2-c5b78546677c';
  static const String _appKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6IjM2YmFmY2U3LWEyMDEtNDI5Yi1hOWUyLWM1Yjc4NTQ2Njc3YyIsImNvbXBhbnlJZCI6IjYzOTdmMzlkZjA3ZmJhMDAwODQyYTkwYiIsImlhdCI6MTY3MDkwMjY4NSwiZXhwIjo0ODI2NTc2Mjg1fQ.fy12dgFhA3iB_RCjD7y8j5HClNRZUiBZgAg-QzFpxaE';

  static const String _baseUrl = 'https://api.uat.geniebiz.lk';

  Map<String, String> _buildHeaders({bool includeAppId = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_appKey',
    };

    if (includeAppId) {
      headers['X-App-Id'] = _appId;
    }

    return headers;
  }

  Future<String> initiatePayment({
    required double amount,
    required String referenceId,
    required String returnUrl,
    required String customerEmail,
    required String customerMobile,
  }) async {
    final uri = Uri.parse('$_baseUrl/payments/initiate');

    final body = {
      'amount': amount,
      'referenceId': referenceId,
      'returnUrl': returnUrl,
      'customerEmail': customerEmail,
      'customerMobile': customerMobile,
      'description': 'Mobitix Bus Ticket Payment',
    };

    try {
      print('📤 [Initiate Payment] Sending POST to $uri');
      print('🧾 Request Headers: ${_buildHeaders()}');
      print('📦 Request Body: ${jsonEncode(body)}');

      final response = await http.post(
        uri,
        headers: _buildHeaders(includeAppId: false),
        body: jsonEncode(body),
      );

      print('📥 Response Code: ${response.statusCode}');
      print('📨 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentUrl = data['paymentUrl'];
        if (paymentUrl == null) throw Exception('No paymentUrl in response.');
        return paymentUrl;
      } else {
        throw Exception('Initiate Payment failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('❌ Error in initiatePayment: $e');
    }
  }

  Future<Map<String, dynamic>> verifyPayment(String paymentId) async {
    final uri = Uri.parse('$_baseUrl/payments/$paymentId/verify');

    try {
      print('📤 [Verify Payment] Sending GET to $uri');
      print('🧾 Request Headers: ${_buildHeaders()}');

      final response = await http.get(
        uri,
        headers: _buildHeaders(includeAppId: false),

      );

      print('📥 Response Code: ${response.statusCode}');
      print('📨 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Verify Payment failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('❌ Error in verifyPayment: $e');
    }
  }
}