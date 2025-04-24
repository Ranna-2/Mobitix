import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:mobitix/widgets/CustomBottomNavBar.dart';
import 'HomePage.dart';
import 'SearchPage.dart';
import 'MapPage.dart';
import 'ProfilePage.dart';
import '../services/genie_payment_service.dart';

class PaymentOptionsPage extends StatelessWidget {
  final int totalAmount;
  final List<String> seats;
  final String passengerName;
  final String mobile;
  final String email;
  final String boarding;
  final String destination;

  const PaymentOptionsPage({
    Key? key,
    required this.totalAmount,
    required this.seats,
    required this.passengerName,
    required this.mobile,
    required this.email,
    required this.boarding,
    required this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Options"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shadowColor: Colors.black26,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Trip Summary", style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    _buildSummaryRow("Passenger:", passengerName),
                    _buildSummaryRow("Seats:", seats.join(", ")),
                    _buildSummaryRow("Route:", "$boarding → $destination"),
                    _buildSummaryRow("Amount:", "LKR $totalAmount"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text("Select Payment Method", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildPaymentOption(context, "Genie", Icons.payment),
            const SizedBox(height: 12),
            _buildPaymentOption(context, "Koko", Icons.account_balance_wallet),
            const SizedBox(height: 12),
            _buildPaymentOption(context, "eZcash", Icons.phone_android),
            const SizedBox(height: 12),
            _buildPaymentOption(context, "Onboard Payment", Icons.attach_money),
          ],
        ),
      ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SearchPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Mappage()));
          }
          else if (index == 4) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfilePage()));
          }
        },
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String method, IconData icon) {
    return InkWell(
      onTap: () {
        if (method == "Genie") {
          _processGeniePayment(context);
        } else {
          _showPaymentConfirmation(context, method);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Colors.blueAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Text(method, style: const TextStyle(fontSize: 16)),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processGeniePayment(BuildContext context) async {
    try {
      final genieService = GeniePaymentService();

      // Generate a unique reference ID for this transaction
      final referenceId = 'mobitix_${DateTime.now().millisecondsSinceEpoch}';

      // For testing, you can use a deep link URL that your app can handle
      // In production, this should be a URL that returns to your app
      const returnUrl = 'mobitix://payment-complete';

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Initiate payment
      final paymentUrl = await genieService.initiatePayment(
        amount: totalAmount.toDouble(),
        referenceId: referenceId,
        returnUrl: returnUrl,
        customerEmail: email,
        customerMobile: mobile,
      );

      // Close loading dialog
      Navigator.of(context).pop();

      // Launch Genie payment page
      final result = await FlutterWebAuth2.authenticate(
        url: paymentUrl,
        callbackUrlScheme: "mobitix",
      );

      // Extract payment ID from result URL
      final uri = Uri.parse(result);
      final paymentId = uri.queryParameters['paymentId'];

      if (paymentId == null) {
        throw Exception('Payment ID not found in return URL');
      }

      // Verify payment
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final verification = await genieService.verifyPayment(paymentId);

      // Close loading dialog
      Navigator.of(context).pop();

      if (verification['status'] == 'SUCCESS') {
        // Payment successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful via Genie!')),
        );

        // Navigate to ticket or confirmation page
        // You'll need to implement this based on your app flow
      } else {
        // Payment failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${verification['message']}')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close any open dialogs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing payment: $e')),
      );
    }
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }

  void _showPaymentConfirmation(BuildContext context, String method) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: Text("Proceed with payment via $method for LKR $totalAmount?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Payment processed with $method")),
              );
              // Navigate or handle next step after payment
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}