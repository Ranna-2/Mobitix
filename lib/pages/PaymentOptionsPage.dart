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
            Text("Total Amount: $totalAmount LKR", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text("Select Payment Method:", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            _buildPaymentOption(context, "Genie"),
            const SizedBox(height: 10),
            _buildPaymentOption(context, "Koko"),
            const SizedBox(height: 10),
            _buildPaymentOption(context, "eZcash"),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2, // Assuming this is the index for Payment Options
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Mappage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String method) {
    return ElevatedButton(
      onPressed: () {
        // Handle payment processing for the selected method
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected payment method: $method")));
      },
      child: Text(method, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}