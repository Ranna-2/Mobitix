import 'package:flutter/material.dart';
import 'package:mobitix/pages/HomePage.dart';
import 'package:mobitix/pages/SearchPage.dart';
import 'package:mobitix/pages/SeatDetailsPage.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Seats'),
        centerTitle: true,
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
            _buildContinueButton(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBusHeader() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.busName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('Departure: 08:00 AM'),
                const Text('Arrival: 12:30 PM'),
              ],
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('LKR 500.00'),
                Text('per seat'),
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
        const Text('Front', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: 52,
          itemBuilder: (context, index) {
            if (index == 2 || (index >= 44 && index <= 45)) {
              return const SizedBox.shrink();
            }

            int seatNumber = index + 1;
            return _buildSeatItem(seatNumber);
          },
        ),
      ],
    );
  }

  Widget _buildSeatItem(int seatNumber) {
    bool isOccupied = [4, 7, 15, 22, 30, 38].contains(seatNumber);
    bool isSelected = selectedSeats.contains(seatNumber);

    return GestureDetector(
      onTap: isOccupied
          ? null
          : () {
        setState(() {
          if (isSelected) {
            selectedSeats.remove(seatNumber);
          } else {
            selectedSeats.add(seatNumber);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isOccupied
              ? Colors.grey
              : isSelected
              ? Colors.blue
              : Colors.white,
          border: Border.all(color: isOccupied ? Colors.grey : Colors.blue),
          borderRadius: BorderRadius.circular(8),
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
        _buildLegendItem(Colors.blue, 'Selected'),
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
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }

  Widget _buildPassengerDetails() {
    return const Text(
      'Passenger details will be collected after seat selection.',
      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
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
              ),
            ),
          );
        },
        child: const Text('CONTINUE'),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1,
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
        }
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: "Ticket"),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
