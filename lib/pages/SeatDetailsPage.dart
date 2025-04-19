import 'package:flutter/material.dart';
import 'PaymentOptionsPage.dart';

class SeatDetailsPage extends StatefulWidget {
  final List<String> selectedSeats;

  const SeatDetailsPage({Key? key, required this.selectedSeats}) : super(key: key);

  @override
  _SeatDetailsPageState createState() => _SeatDetailsPageState();
}

class _SeatDetailsPageState extends State<SeatDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController boardingController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  int seatPrice = 500; // Example price per seat in LKR

  @override
  Widget build(BuildContext context) {
    int totalPrice = widget.selectedSeats.length * seatPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seat Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Seats Selected:", style: Theme.of(context).textTheme.titleMedium),
            Wrap(
              spacing: 8,
              children: widget.selectedSeats.map((seat) => Chip(label: Text(seat))).toList(),
            ),
            const SizedBox(height: 12),
            Text("Total: $totalPrice LKR", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(height: 24),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Passenger Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: boardingController,
              decoration: const InputDecoration(
                labelText: "Boarding Point",
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: destinationController,
              decoration: const InputDecoration(
                labelText: "Destination Point",
                prefixIcon: Icon(Icons.flag),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payment),
                label: const Text("Continue to Pay"),
                onPressed: () {
                  // Validate and navigate to payment
                  if (_validateFields()) {
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
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
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

class PaymentPage extends StatelessWidget {
  final int totalAmount;
  final List<String> seats;
  final String passengerName;
  final String mobile;
  final String email;
  final String boarding;
  final String destination;

  const PaymentPage({
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
    // This is just a placeholder screen
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Proceeding to payment of $totalAmount LKR for seats: ${seats.join(", ")}\n"
              "Passenger: $passengerName\nBoarding: $boarding\nDestination: $destination",
        ),
      ),
    );
  }
}
