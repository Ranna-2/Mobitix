import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobitix/pages/HomePage.dart';
import 'package:mobitix/pages/SearchPage.dart';
import 'package:mobitix/pages/SeatDetailsPage.dart';
import 'package:mobitix/widgets/CustomBottomNavBar.dart';
import 'MapPage.dart';
import 'ProfilePage.dart';
import 'package:http/http.dart' as http;

class SeatSelectionPage extends StatefulWidget {
  final String busId;
  final String busName;

  const SeatSelectionPage({
    Key? key,
    required this.busId,
    this.busName = 'Express Bus',
  }) : super(key: key);

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  final Set<int> selectedSeats = {};
  final double seatPrice = 1500.00;
  Set<int> _reservedSeats = {};
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchReservedSeats().then((seats) {
      setState(() {
        _reservedSeats = seats;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Seats'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBusHeader(),
            const SizedBox(height: 20),
            _buildSeatGrid(),
            const SizedBox(height: 20),
            _buildSeatLegend(),
            const SizedBox(height: 20),
            _buildPassengerDetails(),
            const SizedBox(height: 20),
            _buildPriceSummary(),
            const SizedBox(height: 10),
            _buildContinueButton(),
          ],
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

  Widget _buildBusHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.busName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Departure: 09:15 AM'),
                const Text('Arrival: 01:15 PM'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text('LKR 1500.00', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('per seat', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatGrid() {
    return Column(
      children: [
        const Text('FRONT', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: 52,
          itemBuilder: (context, index) {
            if (index == 2 || (index >= 44 && index <= 45)) {
              return const SizedBox.shrink();
            }
            return _buildSeatItem(index + 1);
          },
        ),
      ],
    );
  }
  Future<Set<int>> _fetchReservedSeats() async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      final response = await http.get(
        Uri.parse('http://192.168.106.242/mobitix/check_seat_availability.php?bus_id=${widget.busId}&date=$formattedDate'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reservedSeats = List<int>.from(data['reserved_seats'].map((e) => int.parse(e.toString())));
        return reservedSeats.toSet();
      } else {
        throw Exception('Failed to load reserved seats');
      }
    } catch (e) {
      print('Error fetching reserved seats: $e');
      return {}; // Return empty set if there's an error
    }
  }

  Widget _buildSeatItem(int seatNumber) {
    bool isOccupied = _reservedSeats.contains(seatNumber); // Now using the fetched reserved seats
    bool isSelected = selectedSeats.contains(seatNumber);

    return GestureDetector(
      onTap: isOccupied
          ? null
          : () {
        setState(() {
          isSelected ? selectedSeats.remove(seatNumber) : selectedSeats.add(seatNumber);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isOccupied
              ? Colors.grey
              : isSelected
              ? Colors.blueAccent
              : Colors.white,
          border: Border.all(color: isOccupied ? Colors.grey.shade700 : Colors.blueAccent),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.blue.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
        ),
        child: Center(
          child: Text(
            seatNumber.toString(),
            style: TextStyle(
              color: isOccupied ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSeatLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem(Colors.white, 'Available'),
        _buildLegendItem(Colors.blueAccent, 'Selected'),
        _buildLegendItem(Colors.grey, 'Booked'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildPassengerDetails() {
    return const Text(
      'Passenger details will be collected after seat selection.',
      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
    );
  }

  Widget _buildPriceSummary() {
    double totalPrice = selectedSeats.length * seatPrice;
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'Total: LKR ${totalPrice.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.arrow_forward),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          if (selectedSeats.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select at least one seat.")),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeatDetailsPage(
                selectedSeats: selectedSeats.map((e) => e.toString()).toList(),
                busId: widget.busId, // Add this line to pass the busId
              ),
            ),
          );
        },
        label: const Text('Continue', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
