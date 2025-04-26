import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:mobitix/widgets/CustomBottomNavBar.dart';
import 'HomePage.dart';
import 'SearchPage.dart';
import 'MapPage.dart';
import 'ProfilePage.dart';
import 'TicketConfirmationPage.dart';
import '../services/genie_payment_service.dart';
import '../services/mock_payment_services.dart';
import '../model/ticket.dart';

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
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Trip Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow("Passenger:", passengerName),
                    _buildSummaryRow("Seats:", seats.join(", ")),
                    _buildSummaryRow("Route:", "$boarding → $destination"),
                    const Divider(height: 20),
                    _buildSummaryRow(
                      "Total Amount:",
                      "LKR ${totalAmount.toStringAsFixed(2)}",
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods Section
            const Text(
              "Select Payment Method",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Genie Payment Option
            _buildPaymentOption(
              context,
              "Genie",
              Icons.payment,
              Colors.purpleAccent,
            ),
            const SizedBox(height: 12),

            // Koko Payment Option
            _buildPaymentOption(
              context,
              "Koko",
              Icons.account_balance_wallet,
              Colors.green,
            ),
            const SizedBox(height: 12),

            // eZcash Payment Option
            _buildPaymentOption(
              context,
              "eZcash",
              Icons.phone_android,
              Colors.orange,
            ),
            const SizedBox(height: 12),

            // Onboard Payment Option
            _buildPaymentOption(
              context,
              "Onboard Payment",
              Icons.attach_money,
              Colors.blueGrey,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomePage()));
          } else if (index == 1) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => SearchPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => Mappage()));
          } else if (index == 4) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => ProfilePage()));
          }
        },
      ),
    );
  }

  Widget _buildPaymentOption(
      BuildContext context, String method, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        if (method == "Genie") {
          _processGeniePayment(context);
        } else if (method == "Koko") {
          _processKokoPayment(context);
        } else if (method == "eZcash") {
          _processEzCashPayment(context);
        } else {
          _processOnboardPayment(context);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  method,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processGeniePayment(BuildContext context) async {
    try {
      final genieService = GeniePaymentService();
      final referenceId = 'genie_${DateTime.now().millisecondsSinceEpoch}';
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

      // Show mock Genie payment dialog
      final result = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Genie Payment Gateway'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'images/genie.png', // Add your Genie logo asset
                  height: 60,
                ),
                const SizedBox(height: 20),
                Text(
                  'Amount: LKR ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Reference: $referenceId',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Mock Genie Payment Simulation',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'For demonstration purposes only',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter any text to simulate payment',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    Navigator.pop(ctx,
                        'mobitix://payment-complete?paymentId=$referenceId');
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(
                  ctx, 'mobitix://payment-complete?status=cancelled'),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    ctx, 'mobitix://payment-complete?paymentId=$referenceId');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
              ),
              child: const Text('Confirm Payment'),
            ),
          ],
        ),
      );

      final uri = Uri.parse(result);
      final paymentId = uri.queryParameters['paymentId'];

      if (paymentId == null || uri.queryParameters['status'] == 'cancelled') {
        throw Exception('Payment was cancelled');
      }

      // Verify payment
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final verification = await genieService.verifyPayment(paymentId);
      Navigator.of(context).pop();

      if (verification['status'] == 'SUCCESS') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful via Genie!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to confirmation page
        _navigateToConfirmation(context, 'Genie', referenceId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${verification['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _processKokoPayment(BuildContext context) async {
    try {
      final kokoService = KokoPaymentService();
      final referenceId = 'koko_${DateTime.now().millisecondsSinceEpoch}';

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Process payment
      final result = await kokoService.processPayment(
        amount: totalAmount.toDouble(),
        referenceId: referenceId,
        passengerName: passengerName,
        mobile: mobile,
        email: email,
        boarding: boarding,
        destination: destination,
        seats: seats,
      );

      // Close loading dialog
      Navigator.of(context).pop();

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful via Koko!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to confirmation page
        _navigateToConfirmation(context, 'Koko', referenceId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing Koko payment: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _processEzCashPayment(BuildContext context) async {
    try {
      final ezCashService = EzCashPaymentService();
      final referenceId = 'ezcash_${DateTime.now().millisecondsSinceEpoch}';

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Process payment
      final result = await ezCashService.processPayment(
        amount: totalAmount.toDouble(),
        referenceId: referenceId,
        passengerName: passengerName,
        mobile: mobile,
        email: email,
        boarding: boarding,
        destination: destination,
        seats: seats,
      );

      // Close loading dialog
      Navigator.of(context).pop();

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful via eZcash!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to confirmation page
        _navigateToConfirmation(context, 'eZcash', referenceId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing eZcash payment: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _processOnboardPayment(BuildContext context) async {
    final referenceId = 'onboard_${DateTime.now().millisecondsSinceEpoch}';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Onboard Payment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("You will pay the conductor when boarding the bus."),
            const SizedBox(height: 20),
            Text(
              "Amount: LKR ${totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Reference: $referenceId",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Onboard payment reservation confirmed!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to confirmation page
      _navigateToConfirmation(context, 'Onboard Payment', referenceId);
    }
  }

  void _navigateToConfirmation(
      BuildContext context, String method, String referenceId) {
    final newTicket = Ticket(
      id: referenceId,
      passengerName: passengerName,
      mobile: mobile,
      email: email,
      seats: seats,
      boarding: boarding,
      destination: destination,
      totalAmount: totalAmount.toDouble(),
      bookingDate: DateTime.now(),
      travelDate: DateTime.now().add(const Duration(days: 1)), // Example travel date
      busName: 'Express Bus', // You should get this from previous screens
      busId: 'bus123', // You should get this from previous screens
      paymentMethod: method,
      referenceId: referenceId,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TicketConfirmationPage(ticket: newTicket),
      ),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Payment Confirmed"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 20),
            Text(
              "Paid via $method",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Reference: $referenceId"),
            const SizedBox(height: 20),
            Text(
              "LKR ${totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
              );
            },
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
