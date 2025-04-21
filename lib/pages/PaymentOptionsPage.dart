import 'package:flutter/material.dart';
import 'package:mobitix/widgets/CustomBottomNavBar.dart';
import 'HomePage.dart';
import 'SearchPage.dart';
import 'MapPage.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shadowColor: Colors.black26,
              child: Padding(
                padding: const EdgeInsets.all(16),
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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SearchPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Mappage()));
          }
        },
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String method, IconData icon) {
    return InkWell(
      onTap: () => _showPaymentConfirmation(context, method),
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