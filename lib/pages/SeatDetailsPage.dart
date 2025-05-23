import 'package:flutter/material.dart';
import 'package:mobitix/pages/TicketsPage.dart';
import 'PaymentOptionsPage.dart';
import 'SearchPage.dart';
import 'HomePage.dart';
import 'MapPage.dart';
import 'ProfilePage.dart';
import 'package:mobitix/widgets/CustomBottomNavBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class SeatDetailsPage extends StatefulWidget {
  final List<String> selectedSeats;
  final String busId; // Added busId parameter

  const SeatDetailsPage({
    Key? key,
    required this.selectedSeats,
    required this.busId, // Added busId parameter
  }) : super(key: key);

  @override
  _SeatDetailsPageState createState() => _SeatDetailsPageState();
}

class _SeatDetailsPageState extends State<SeatDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController boardingController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  int seatPrice = 1500;

  @override
  Widget build(BuildContext context) {
    int totalPrice = widget.selectedSeats.length * seatPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip summary section
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Trip Summary",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: widget.selectedSeats
                          .map((seat) => Chip(label: Text(seat)))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    Text("Total: $totalPrice LKR",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Passenger Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            _buildTextField(
                controller: nameController,
                label: "Full Name",
                icon: Icons.person),
            _buildTextField(
                controller: mobileController,
                label: "Mobile Number",
                icon: Icons.phone,
                inputType: TextInputType.phone),
            _buildTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email,
                inputType: TextInputType.emailAddress),

            const SizedBox(height: 20),
            const Text("Travel Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            _buildTextField(
                controller: boardingController,
                label: "Boarding Point",
                icon: Icons.location_on),
            _buildTextField(
                controller: destinationController,
                label: "Destination Point",
                icon: Icons.flag),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payment),
                label: const Text("Continue to Pay"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: Colors.teal,
                  textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: () async {
                  if (_validateFields()) {
                    try {
                      // First reserve the seats
                      final response = await http.post(
                        Uri.parse('http://192.168.106.242/mobitix/reserve_seats.php'),
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode({
                          'bus_id': widget.busId,
                          'seats': widget.selectedSeats,
                          'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        }),
                      );

                      if (response.statusCode == 200) {
                        // Proceed to payment if reservation was successful
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentOptionsPage(
                              totalAmount: totalPrice,
                              seats: widget.selectedSeats,
                              passengerName: nameController.text,
                              mobile: mobileController.text,
                              email: emailController.text,
                              boarding: boardingController.text,
                              destination: destinationController.text,
                              busId: widget.busId,
                            ),
                          ),
                        );
                      } else {
                        final error = json.decode(response.body)['error'];
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error ?? 'Failed to reserve seats')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3, // Set current index to 2 for TicketsPage
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePage())
            );
          } else if (index == 1) {
            // Handle search page navigation if needed
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TicketsPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Mappage())
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage())
            );
          }
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  bool _validateFields() {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        emailController.text.isEmpty ||
        boardingController.text.isEmpty ||
        destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all details")),
      );
      return false;
    }
    return true;
  }
}